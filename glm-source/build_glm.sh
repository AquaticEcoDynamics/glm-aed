#!/bin/sh

cd GLM
. ./GLM_CONFIG
cd ..

case `uname` in
  "Darwin"|"Linux"|"FreeBSD")
    export OSTYPE=`uname -s`
    ;;
  MINGW*)
    export OSTYPE="Msys"
    ;;
esac

export CC=gcc
if [ "$OSTYPE" = "FreeBSD" ] ; then
  export FC=flang
  export CC=clang
else
  export FC=gfortran
fi

ARGS=""
while [ $# -gt 0 ] ; do
  ARGS="$ARGS $1"
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
    --flang)
      export FC=flang
      ;;
    *)
      ;;
  esac
  shift
done

export MAKE=make
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
  start_sh="$(ps -p "$$" -o  command= | awk '{print $1}')"
  # ifort config scripts wont work with /bin/sh
  # so we restart using bash
  if [ "$start_sh" = "/bin/sh" ] ;  then
     echo Restart using bash because ifort cant use /bin/sh
     /bin/bash $0 $ARGS
     exit $?
  fi
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
  if [ -d ${CURDIR}/../libaed-demo ] ; then
    echo build libaed-demo
    cd  ${CURDIR}/../libaed-demo
    ${MAKE} || exit 1
    DAEDDMODIR=`pwd`
  fi
  if [ -d ${CURDIR}/../libaed-riparian ] ; then
    echo build libaed-riparian
    cd  ${CURDIR}/../libaed-riparian
    ${MAKE} || exit 1
    DAEDRIPDIR=`pwd`
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
  if [ "$OSTYPE" = "Msys" ] ; then
    ${MAKE} -f Makefile.msys || exit 1
  else
    ${MAKE} || exit 1
  fi
fi

cd ${UTILDIR}
${MAKE} || exit 1

cd ${CURDIR}/..
if [ "$FC" = "flang" -a -d flang_extra ] ; then
  echo making flang extras
  cd flang_extra
  ${MAKE} || exit 1
fi

cd ${CURDIR}
if [ -f obj/aed_external.o ] ; then
  /bin/rm obj/aed_external.o
fi

# Update versions in resource files
cd ${CURDIR}/win
${CURDIR}/vers.sh $VERSION
#cd ${CURDIR}/win-dll
#${CURDIR}/vers.sh $VERSION
cd ${CURDIR}
VERSION=`grep GLM_VERSION src/glm.h | cut -f2 -d\"`

${MAKE} AEDBENDIR=$DAEDBENDIR AEDDMODIR=$DAEDDMODIR || exit 1
if [ "${DAEDDEVDIR}" != "" -a -d ${DAEDDEVDIR} ] ; then
  echo now build plus version
  /bin/rm obj/aed_external.o
  ${MAKE} glm+ AEDBENDIR=$DAEDBENDIR AEDDMODIR=$DAEDDMODIR AEDRIPDIR=$DAEDRIPDIR AEDDEVDIR=$DAEDDEVDIR || exit 1
fi

cd ${CURDIR}/..

# =====================================================================
# Package building bit

# ***************************** Linux *********************************
if [ "$OSTYPE" = "Linux" ] ; then
  if [ $(lsb_release -is) = Ubuntu ] ; then
    BINPATH=binaries/ubuntu/$(lsb_release -rs)
    if [ ! -d "${BINPATH}" ] ; then
      mkdir -p "${BINPATH}"/
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

    mv glm*.deb ${BINPATH}/
  else
    BINPATH="binaries/$(lsb_release -is)/$(lsb_release -rs)"
    echo "No package build for $(lsb_release -is)"
  fi
fi

# ****************************** MacOS ********************************
if [ "$OSTYPE" = "Darwin" ] ; then
  MOSLINE=`grep 'SOFTWARE LICENSE AGREEMENT FOR ' '/System/Library/CoreServices/Setup Assistant.app/Contents/Resources/en.lproj/OSXSoftwareLicense.rtf'`
  # pre Lion :   MOSNAME=`echo ${MOSLINE} | awk -F 'Mac OS X ' '{print $NF}'  | tr -d '\\' | tr ' ' '_'`
  # pre Sierra : MOSNAME=`echo ${MOSLINE} | awk -F 'OS X ' '{print $NF}'  | tr -d '\\' | tr ' ' '_'`
  MOSNAME=`echo ${MOSLINE} | awk -F 'macOS ' '{print $NF}'  | tr -d '\\' | tr ' ' '_'`

  BINPATH="binaries/macos/${MOSNAME}"
  if [ ! -d "${BINPATH}" ] ; then
     mkdir -p "${BINPATH}"
  fi
  cd ${CURDIR}/macos
  if [ "${HOMEBREW}" = "" ] ; then
    HOMEBREW=false
  fi
  /bin/bash macpkg.sh ${HOMEBREW}
  mv ${CURDIR}/macos/glm_*.zip "${CURDIR}/../${BINPATH}/"

  if [ "${DAEDDEVDIR}" != "" -a -d "${DAEDDEVDIR}" ] ; then
    /bin/bash macpkg.sh ${HOMEBREW} glm+
    mv ${CURDIR}/macos/glm+_*.zip "${CURDIR}/../${BINPATH}/"
  else
    echo No GLM+
  fi

  cd ${CURDIR}/..
fi

# ***************************** FreeBSD *******************************
if [ "$OSTYPE" = "FreeBSD" ] ; then
  USRENV=`uname -K`
  BINPATH="binaries/freebsd/${USRENV}"
  if [ ! -d "${BINPATH}" ] ; then
    mkdir -p "${BINPATH}"
  fi

  cd ${CURDIR}/freebsd

  VERSRUL=`grep '^version:' create_pkg.sh | cut -f2 -d\"`
  if [ "$VERSION" != "$VERSRUL" ] ; then
    echo sed -e "s/version: \"${VERSRUL}\"/version: \"${VERSION}\"/" -i.x create_pkg.sh
    sed -e "s/version: \"${VERSRUL}\"/version: \"${VERSION}\"/" -i.x create_pkg.sh
    /bin/rm create_pkg.sh.x
  fi

  /bin/sh create_pkg.sh glm
  if [ -x ../glm+ ] ; then
    /bin/sh create_pkg.sh glm+
  fi

  mv *.pkg ${CURDIR}/../${BINPATH}

  cd ${CURDIR}/..
fi

# ***************************** Msys *******************************
if [ "$OSTYPE" = "Msys" ] ; then
  cd ${CURDIR}/..

  VERSION=`grep GLM_VERSION GLM/src/glm.h | cut -f2 -d\"`
  BINPATH="binaries/windows"

  if [ ! -d "${BINPATH}" ] ; then
    mkdir -p "${BINPATH}"
  fi
  mkdir glm_$VERSION
  cp win-3rd-party/x64-Release/bin/libnetcdf.dll glm_$VERSION
  for dll in libgfortran-5.dll libgcc_s_seh-1.dll libquadmath-0.dll libwinpthread-1.dll ; do
    dllp=`find /c/ProgramData/chocolatey/lib/mingw/tools/install/mingw64/ -name $dll 2> /dev/null | head -1`
    echo \"$dllp\"
    cp "$dllp" glm_$VERSION
  done
  /bin/cp "${CURDIR}/glm" glm_$VERSION
# gzip -o "${BINPATH}/glm_$VERSION.zip" glm_$VERSION
  powershell -Command "Compress-Archive -LiteralPath glm_$VERSION -DestinationPath glm_$VERSION.zip"
  mv  glm_$VERSION.zip ${BINPATH}

  if [ -x ${CURDIR}/glm+ ] ; then
    mkdir glm+_$VERSION
    cp glm_$VERSION/*.dll glm+_$VERSION
    /bin/cp "${CURDIR}/glm+" glm+_$VERSION
#   gzip -o "${BINPATH}/glm+_$VERSION.zip" glm+_$VERSION
    powershell -Command "Compress-Archive -LiteralPath glm+_$VERSION -DestinationPath glm+_$VERSION.zip"
    mv  glm+_$VERSION.zip ${BINPATH}
    /bin/rm -r glm+_$VERSION
  fi
  /bin/rm -r glm_$VERSION
fi

# ***************************** All *******************************
if [ -x ${BINPATH}/glm_$VERSION ] ; then
  /bin/rm -r ${BINPATH}/glm_$VERSION
fi
/bin/mkdir ${BINPATH}/glm_$VERSION
/bin/cp ${CURDIR}/glm ${BINPATH}/glm_$VERSION
if [ -x ${CURDIR}/glm+ ] ; then
  /bin/cp ${CURDIR}/glm+ ${BINPATH}/glm_$VERSION
fi
./admin/make_release_info.sh > ${BINPATH}/glm_$VERSION/ReleaseInfo.txt

exit 0
