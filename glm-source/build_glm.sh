#!/bin/sh

# CURDIR should be the directory of the project we are building
export CURDIR=`pwd`/GLM
# CWD should be the tools directory in which CURDIR lives
export CWD=`dirname ${CURDIR}`

#
# These are defaults for glm
#
export WITH_AED=true
export AED=true
export WITH_AED_PLUS=false
if [ -d ${CWD}/libaed-dev ] ; then
  export WITH_AED_PLUS=true
fi
export WITH_API=true
export API=true
export USE_DL=false
export WITH_PLOTS=true
export WITH_XPLOTS=true
export WITH_MPI=false


export PLOTDIR=${CWD}/libplot
export UTILDIR=${CWD}/libutil

case `uname` in
  "Darwin"|"Linux"|"FreeBSD")
    export OSTYPE=`uname -s`
    ;;
  MINGW*)
    export OSTYPE="Msys"
    ;;
esac

case $OSTYPE in
  Darwin)
    export LIB_EXT=dylib
    ;;
  Msys)
    export LIB_EXT=dll
    ;;
  *)
    export LIB_EXT=so
    ;;
esac

if [ "$OSTYPE" = "FreeBSD" ] ; then
  export FC=flang
  export CC=clang
  export MAKE=gmake
else
  export FC=gfortran
  export CC=gcc
  export MAKE=make
fi

ARGS=""
while [ $# -gt 0 ] ; do
  ARGS="$ARGS $1"
  case $1 in
    --debug)
      export DEBUG=true
      ;;
    --checks)
      export WITH_CHECKS=true
      ;;
    --mdebug)
      export MDEBUG=true
      ;;
    --fence)
      export FENCE=true
      ;;
    --with-aed)
      export WITH_AED=true
      ;;
    --without-aed)
      export WITH_AED=false
      ;;
    --with-aed-plus)
      export WITH_AED_PLUS=true
      ;;
    --without-aed-plus)
      export WITH_AED_PLUS=false
      ;;
    --with-lib)
      export WITH_LIB=true
      ;;
    --without-lib)
      export WITH_LIB=false
      ;;
    --gfort)
      export FC=gfortran
      ;;
    --ifx)
      export FC=ifx
      ;;
    --ifort)
      export FC=ifort
      ;;
    --clang)
      export CC=clang
      ;;
    --flang)
      export FC=flang
      ;;
    --no-gui)
      export WITH_PLOTS=false
      export WITH_XPLOTS=false
      ;;
    --dont-package)
      export NO_PKG=true
      ;;
    --auto-prereq)
      export AUTO_PREQ=true
      ;;
    --help)
      echo "build_glm accepts the following flags:"
      echo "  --debug            : build with debugging symbols"
      echo "  --gfort            : use the gfortran compiler"
      echo "  --ifort            : use the older intel fortran compiler"
      echo "  --ifx              : use the newer intel fortran compiler"
      echo "  --clang            : use the clang C/C++ compiler"
      echo "  --flang            : use the flang fortran compiler"
      echo
      echo "  --with-aed         : build with aed enabled"
      echo "  --without-aed      : build without aed enabled"
      echo "  --with-aed-plus    : build with aed and aed-plus enabled"
      echo "  --without-aed-plus : build without aed and aed-plus enabled"
      echo "  --with-lib         : build library (libglm) as well"
      echo "  --without-lib      : dont build libglm (default)"
      echo
      echo "  --auto-prereq      : if needed, also build ancillary pre-requirments"
      echo

      exit 0
      ;;
    *)
      echo "Unknown option \"$1\""
      exit 1
      ;;
  esac
  shift
done

export F77=$FC
export F90=$FC
export F95=$FC

export MPI=OPENMPI

. ${CWD}/build_env.inc

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
    if [ $? -ne 0 ] ; then
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
# export FFLAGS="$FFLAGS -fPIC"
  if [ "${USE_DL}" = "true" ] ; then
    cmake ${FABMDIR} -DBUILD_SHARED_LIBS=1 || exit 1
  else
    cmake ${FABMDIR} || exit 1
  fi
  ${MAKE} || exit 1
fi

if [ "${WITH_AED}" = "true" ] || [ "${WITH_API}" = "true" ] ; then
  . ${CWD}/build_aedlibs.inc
fi

if [ -d "${UTILDIR}" ] ; then
  echo "making libutil"
  cd "${UTILDIR}"
  ${MAKE} || exit 1
  cd "${CWD}"
fi

if [ "$OSTYPE" = "Msys" ] ; then
  if [ ! -d ancillary/lib ] ; then
    echo making windows ancillary extras
    cd ancillary
    ./build.sh || exit 1
  fi
fi

if [ "$WITH_PLOTS" = "true" ] ; then
  echo "making libplot"
  cd "${PLOTDIR}"
  ${MAKE} || exit 1
fi

cd "${CURDIR}"
if [ -f obj/aed_external.o ] ; then
  /bin/rm obj/aed_external.o
fi

# Update versions in resource files
if [ -f src/glm.h ] ; then
  VERSION=`grep GLM_VERSION src/glm.h | cut -f2 -d\"`
else
  VERSION=`grep GLM_VERSION include/glm.h | cut -f2 -d\"`
fi
cd "${CURDIR}/win"
${CURDIR}/vers.sh $VERSION
#cd ${CURDIR}/win-dll
#${CURDIR}/vers.sh $VERSION
cd "${CURDIR}"
get_commit_id >> ${CWD}/cur_state.log

export LIBRARY_PATH=$LIB
if [ "$WITH_LIB" = "true" ] ; then
  LIBTARG="libglm.${LIB_EXT}"
else
  LIBTARG=""
fi
${MAKE} glm $LIBTARG AEDBENDIR=$DAEDBENDIR AEDDMODIR=$DAEDDMODIR || exit 1
if [ "${DAEDDEVDIR}" != "" ] ; then
  if [ -d "${DAEDDEVDIR}" ] ; then
    echo now build plus version
    /bin/rm obj/aed_external.o
    /bin/rm obj/glm_main.o
    if [ "$WITH_LIB" = "true" ] ; then
      LIBTARG="libglm+.${LIB_EXT}"
    else
      LIBTARG=""
    fi
    ${MAKE} glm+ $LIBTARG WITH_AED_PLUS=1 \
                     AEDBENDIR=$DAEDBENDIR AEDDMODIR=$DAEDDMODIR \
                     AEDRIPDIR=$DAEDRIPDIR AEDLGTDIR=$DAEDLGTDIR \
                     AEDDEVDIR=$DAEDDEVDIR PHREEQDIR=$PHREEQDIR || exit 1
  fi
fi

cd "${CWD}"

if [ "$NO_PKG" = "true" ] ; then
  # all done
  exit 0
fi

# =====================================================================
# Package building bit

# ***************************** Linux *********************************
if [ "$OSTYPE" = "Linux" ] ; then
  RELEASE=`lsb_release -is | tr '[A-Z]' '[a-z]'`
  if [ $RELEASE = ubuntu ] || [ $RELEASE = debian ] ; then
    BINPATH=binaries/$RELEASE/$(lsb_release -rs)
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
  # MOSLINE=`grep 'SOFTWARE LICENSE AGREEMENT FOR ' "/System/Library/CoreServices/Setup Assistant.app/Contents/Resources/en.lproj/OSXSoftwareLicense.rtf"`
  # pre Lion :   MOSNAME=`echo ${MOSLINE} | awk -F 'Mac OS X ' '{print $NF}'  | tr -d '\\' | tr ' ' '_'`
  # pre Sierra : MOSNAME=`echo ${MOSLINE} | awk -F 'OS X ' '{print $NF}'  | tr -d '\\' | tr ' ' '_'`
  # MOSNAME=`echo ${MOSLINE} | awk -F 'macOS ' '{print $NF}'  | tr -d '\\' | tr ' ' '_'`
  MOSNAME=`cat "/System/Library/CoreServices/Setup Assistant.app/Contents/Resources/en.lproj/OSXSoftwareLicense.rtf" | awk -F 'macOS ' '/SOFTWARE LICENSE AGREEMENT FOR/ {print $NF}' | tr -d '\\' | tr ' ' '_'`

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
fi

# ***************************** FreeBSD *******************************
if [ "$OSTYPE" = "FreeBSD" ] ; then
  USRENV=`uname -r`
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
fi

# ***************************** Msys *******************************
if [ "$OSTYPE" = "Msys" ] ; then
  cd ${CURDIR}/..

# VERSION=`grep GLM_VERSION GLM/src/glm.h | cut -f2 -d\"`
# the above should alread exist
  BINPATH="binaries/windows"

  if [ ! -d "${BINPATH}" ] ; then
    mkdir -p "${BINPATH}"
  fi
  mkdir glm_$VERSION

  cp ancillary/bin/libnetcdf.dll glm_$VERSION
  cp ancillary/bin/libgd.dll glm_$VERSION
  for dll in libgfortran libgcc_s_seh libquadmath libwinpthread ; do
    dllp=`find /c/ProgramData/ -name $dll\*.dll 2> /dev/null | head -1`
    if [ "$dllp" != "" ] ; then
      echo \"$dllp\"
      cp "$dllp" glm_$VERSION
    else
      echo "$dll not found"
    fi
  done
  /bin/cp "${CURDIR}/glm" glm_$VERSION
  # zip up the bundle
  powershell -Command "Compress-Archive -LiteralPath glm_$VERSION -DestinationPath glm_$VERSION.zip"
  mv  glm_$VERSION.zip ${BINPATH}

  if [ -x ${CURDIR}/glm+ ] ; then
    mkdir glm+_$VERSION
    cp glm_$VERSION/*.dll glm+_$VERSION
    /bin/cp "${CURDIR}/glm+" glm+_$VERSION

    # zip up the + bundle
    powershell -Command "Compress-Archive -LiteralPath glm+_$VERSION -DestinationPath glm+_$VERSION.zip"
    mv glm+_$VERSION.zip ${BINPATH}
    mv glm+_$VERSION ${BINPATH}
  fi
  mv glm_$VERSION ${BINPATH}
fi

# ***************************** All *******************************
cd ${CWD}

echo Finished build for $OSTYPE

if [ -d ${BINPATH}/glm_$VERSION ] ; then
  if [ -d ${BINPATH}/glm_latest ] ; then
    /bin/rm -rf ${BINPATH}/glm_latest
  fi
  /bin/mv ${BINPATH}/glm_$VERSION ${BINPATH}/glm_latest
else
  if [ ! -d ${BINPATH}/glm_latest ] ; then
    /bin/mkdir ${BINPATH}/glm_latest
  fi
fi
cp cur_state.log ${BINPATH}/glm_latest/glm_source.versions
echo "glm_$VERSION" > ${BINPATH}/glm_latest/VERSION
/bin/cp ${CURDIR}/glm ${BINPATH}/glm_latest
echo Generating ReleaseInfo.txt for glm
./admin/make_release_info.sh > ${BINPATH}/glm_latest/ReleaseInfo.txt

if [ -x ${CURDIR}/glm+ ] ; then
  if [ -d ${BINPATH}/glm+_$VERSION ] ; then
    if [ -d ${BINPATH}/glm+_latest ] ; then
      /bin/rm -rf ${BINPATH}/glm+_latest
    fi
    /bin/mv ${BINPATH}/glm+_$VERSION ${BINPATH}/glm+_latest
  else
    if [ ! -d ${BINPATH}/glm+_latest ] ; then
      /bin/mkdir ${BINPATH}/glm+_latest
    fi
  fi
  cp cur_state.log ${BINPATH}/glm+_latest/glm+_source.versions
  echo "glm+_$VERSION" > ${BINPATH}/glm+_latest/VERSION
  /bin/cp ${CURDIR}/glm+ ${BINPATH}/glm+_latest
  echo Generating ReleaseInfo.txt for glm+
  ./admin/make_release_info.sh plus > ${BINPATH}/glm+_latest/ReleaseInfo.txt
fi

if [ "$WITH_LIB" = "true" ] ; then
  if [ -d ${BINPATH}/pglm_$VERSION ] ; then /bin/rm -rf ${BINPATH}/pglm_$VERSION ; fi
  if [ -d ${BINPATH}/pglm_latest ] ; then /bin/rm -rf ${BINPATH}/pglm_latest ; fi

  /bin/mkdir ${BINPATH}/pglm_$VERSION
  /bin/cp -r ${CURDIR}/pglm ${BINPATH}/pglm_$VERSION/
  /bin/cp ${CURDIR}/libglm.${LIB_EXT} ${BINPATH}/pglm_$VERSION/
  ./admin/make_release_info.sh > ${BINPATH}/pglm_$VERSION/ReleaseInfo.txt

  if [ "$WITH_AED_PLUS" = "true" ] ; then
    if [ -d ${BINPATH}/pglm+_$VERSION ] ; then /bin/rm -rf ${BINPATH}/pglm+_$VERSION ; fi
    if [ -d ${BINPATH}/pglm+_latest ] ; then /bin/rm -rf ${BINPATH}/pglm+_latest ; fi

    /bin/mkdir ${BINPATH}/pglm+_$VERSION
    /bin/cp -r ${CURDIR}/pglm ${BINPATH}/pglm+_$VERSION/
    /bin/cp ${CURDIR}/libglm+.${LIB_EXT} ${BINPATH}/pglm+_$VERSION/
    cd ${BINPATH}/pglm+_$VERSION
    /bin/ln -s libglm+.${LIB_EXT} libglm.${LIB_EXT}
    cd ${CWD}
    ./admin/make_release_info.sh plus > ${BINPATH}/pglm+_$VERSION/ReleaseInfo.txt
  fi

  cd ${BINPATH}
  /bin/tar czf pglm_$VERSION.tar.gz pglm_$VERSION
  /bin/mv pglm_$VERSION pglm_latest

  if [ "$WITH_AED_PLUS" = "true" ] ; then
    /bin/tar czf pglm+_$VERSION.tar.gz pglm+_$VERSION
    /bin/mv pglm+_$VERSION pglm+_latest
  fi
fi

echo Finished packaging for $OSTYPE

exit 0
