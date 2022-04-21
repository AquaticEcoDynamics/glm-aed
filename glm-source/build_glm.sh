#!/bin/bash

cd GLM
. ./GLM_CONFIG
cd ..

export WITH_PLOTS=false
export WITH_XPLOTS=false

# export FC=ifort

while [ $# -gt 0 ] ; do
  case $1 in
    --debug)
      export DEBUG=true
      ;;
    --fence)
      export FENCE=true
      ;;
    --fabm)
      export FABM=true
      ;;
    --gfort)
      export FC=gfortran
      ;;
    --ifort)
      export FC=ifort
      ;;
    *)
      ;;
  esac
  shift
done

export MAKE=make
export OSTYPE=`uname -s`
if [ "$OSTYPE" = "Darwin" ] ; then
  if [ "$HOMEBREW" = "" ] ; then
    brew -v > /dev/null 2>&1
    if [ $? != 0 ] ; then
      which port > /dev/null 2>&1
      if [ $? != 0 ] ; then
        echo no ports and no brew
      else
        export MACPORTS=true
      fi
    else
      export HOMEBREW=true
    fi
  fi
else
  if [ "$OSTYPE" = "FreeBSD" ] ; then
    export FC=flang
    export MAKE=gmake
  fi
fi


# see if FC is defined, if not look for gfortran at least v8
if [ "$FC" = "" ] ; then
  gfortran -v > /dev/null 2>&1
  if [ $? != 0 ] ; then
    export FC=ifort
  else
    VERS=`gfortran -dumpversion | cut -d\. -f1`
    if [ $VERS -ge 8 ] ; then
      export FC=gfortran
    else
      gfortran-8 -v > /dev/null 2>&1
      if [ $? != 0 ] ; then
        export FC=ifort
      else
        export gfortran-8
      fi
    fi
  fi
fi

if [ "$FC" = "ifort" ] ; then
  if [ -d /opt/intel/oneapi ] ; then
     . /opt/intel/oneapi/setvars.sh
  else
    if [ -d /opt/intel/bin ] ; then
       . /opt/intel/bin/compilervars.sh intel64
    fi
    which ifort > /dev/null 2>&1
    if [ $? != 0 ] ; then
       echo ifort compiler requested, but not found
       exit 1
    fi
  fi
fi

export F77=$FC
export F90=$FC
export F95=$FC

export MPI=OPENMPI

if [ "$AED2DIR" = "" ] ; then
  export AED2DIR=../libaed2
fi
if [ "$PLOTDIR" = "" ] ; then
  export PLOTDIR=../libplot
fi
if [ "$UTILDIR" = "" ] ; then
  export UTILDIR=../libutil
fi

if [ "$FABM" = "true" ] ; then
  if [ ! -d $FABMDIR ] ; then
    echo "FABM directory not found"
    export FABM=false
  else
    which cmake > /dev/null 2>&1
    if [ $? != 0 ] ; then
      echo "cmake not found - FABM cannot be built"
      export FABM=false
    fi
  fi
  if [ "$FABM" = "false" ] ; then
    echo build with FABM requested but FABM cannot be built
    exit 1
  fi

  export FABMHOST=glm
  cd ${FABMDIR}
  if [ ! -d build ] ; then
    mkdir build
  fi
  cd build
  export FFLAGS+=-fPIC
  if [ "${USE_DL}" = "true" ] ; then
    cmake ${FABMDIR}/src -DBUILD_SHARED_LIBS=1 || exit 1
  else
    cmake ${FABMDIR}/src || exit 1
  fi
  ${MAKE} || exit 1
fi

if [ "${AED2}" = "true" ] ; then
  cd ${AED2DIR}
  ${MAKE} || exit 1
  cd ..
  if [ "${AED2PLS}" != "" ] ; then
    if [ -d ${AED2PLS} ] ; then
      cd ${AED2PLS}
      ${MAKE} || exit 1
      cd ..
    fi
  fi
fi

if [ "${AED}" = "true" ] ; then
  cd  ${CURDIR}/../libaed-water
  ${MAKE} || exit 1
  DAEDWATDIR=`pwd`
  if [ -d ${CURDIR}/../libaed-benthic ] ; then
    echo build libaed-benthic
    cd  ${CURDIR}/../libaed-benthic
    ${MAKE} || exit 1
    DAEDBENDIR=`pwd`
  fi
  if [ -d ${CURDIR}/../libaed-riparian ] ; then
    echo build libaed-riparian
    cd  ${CURDIR}/../libaed-riparian
    ${MAKE} || exit 1
    DAEDRIPDIR=`pwd`
  fi
  if [ -d ${CURDIR}/../libaed-demo ] ; then
    echo build libaed-demo
    cd  ${CURDIR}/../libaed-demo
    ${MAKE} || exit 1
    DAEDDMODIR=`pwd`
  fi
  if [ -d ${CURDIR}/../libaed-dev ] ; then
    echo build libaed-dev
    cd  ${CURDIR}/../libaed-dev
    ${MAKE} || exit 1
    DAEDDEVDIR=`pwd`
  fi
fi

if [ "$WITH_PLOTS" = "true" ] ; then
  cd ${PLOTDIR}
  ${MAKE} || exit 1
fi

cd ${UTILDIR}
${MAKE} || exit 1

cd ${CURDIR}/..
if [ "$FC" = "flang" ] && [ -d flang_extra ] ; then
  echo making flang extras
  cd flang_extra
  ${MAKE} || exit 1
fi

cd ${CURDIR}
if [ -f obj/aed_external.o ] ; then
  /bin/rm obj/aed_external.o
fi
${MAKE} AEDBENDIR=$DAEDBENDIR AEDDMODIR=$DAEDDMODIR || exit 1
if [ "${DAEDDEVDIR}" != "" -a -d ${DAEDDEVDIR} ] ; then
  echo now build plus version
  /bin/rm obj/aed_external.o
  ${MAKE} glm+ AEDBENDIR=$DAEDBENDIR AEDDMODIR=$DAEDDMODIR AEDRIPDIR=$DAEDRIPDIR AEDDEVDIR=$DAEDDEVDIR || exit 1
fi


VERSION=`grep GLM_VERSION src/glm.h | cut -f2 -d\"`

cd ${CURDIR}/win
${CURDIR}/vers.sh $VERSION
#cd ${CURDIR}/win-dll
#${CURDIR}/vers.sh $VERSION
cd ${CURDIR}/..

if [ "$OSTYPE" = "Linux" ] ; then
  if [ $(lsb_release -is) = Ubuntu ] ; then
    if [ ! -d binaries/ubuntu/$(lsb_release -rs) ] ; then
      mkdir -p binaries/ubuntu/$(lsb_release -rs)/
    fi
    cd ${CURDIR}
    if [ -x glm+ ] ; then
       /bin/cp debian/control-with+ debian/control
    else
       /bin/cp debian/control-no+ debian/control
    fi
    VERSDEB=`head -1 debian/changelog | cut -f2 -d\( | cut -f1 -d-`
    echo debian version $VERSDEB
    if [ "$VERSION" != "$VERSDEB" ] ; then
      echo updating debian version
      dch --newversion ${VERSION}-0 "new version ${VERSION}"
    fi
    VERSRUL=`grep 'version=' debian/rules | cut -f2 -d=`
    if [ "$VERSION" != "$VERSRUL" ] ; then
      sed -i "s/version=$VERSRUL/version=$VERSION/" debian/rules
    fi

    fakeroot ${MAKE} -f debian/rules binary || exit 1

    cd ..

    mv glm*.deb binaries/ubuntu/$(lsb_release -rs)/
  else
    echo "No package build for $(lsb_release -is)"
  fi
fi
if [ "$OSTYPE" = "Darwin" ] ; then
  MOSLINE=`grep 'SOFTWARE LICENSE AGREEMENT FOR ' '/System/Library/CoreServices/Setup Assistant.app/Contents/Resources/en.lproj/OSXSoftwareLicense.rtf'`
  # pre Lion :   MOSNAME=`echo ${MOSLINE} | awk -F 'Mac OS X ' '{print $NF}'  | tr -d '\\' | tr ' ' '_'`
  # pre Sierra : MOSNAME=`echo ${MOSLINE} | awk -F 'OS X ' '{print $NF}'  | tr -d '\\' | tr ' ' '_'`
  MOSNAME=`echo ${MOSLINE} | awk -F 'macOS ' '{print $NF}'  | tr -d '\\' | tr ' ' '_'`

  if [ ! -d "binaries/macos/${MOSNAME}" ] ; then
     mkdir -p "binaries/macos/${MOSNAME}"
  fi
  cd ${CURDIR}/macos
  if [ "${HOMEBREW}" = "" ] ; then
    HOMEBREW=false
  fi
  /bin/bash macpkg.sh ${HOMEBREW}
  mv ${CURDIR}/macos/glm_*.zip "${CURDIR}/../binaries/macos/${MOSNAME}/"

  if [ "${DAEDDEVDIR}" != "" -a -d "${DAEDDEVDIR}" ] ; then
    /bin/bash macpkg.sh ${HOMEBREW} glm+
    mv ${CURDIR}/macos/glm+_*.zip "${CURDIR}/../binaries/macos/${MOSNAME}/"
  else
    echo No GLM+
  fi

  cd ${CURDIR}/..
fi

exit 0
