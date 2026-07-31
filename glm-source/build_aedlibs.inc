
cd ${CWD}
get_commit_id > cur_state.log

echo "build libaed-water"
cd "${CWD}/libaed-water"
get_commit_id >> ${CWD}/cur_state.log
${MAKE} || exit 1
DAEDWATDIR=`pwd`
if [ -d "${CWD}/libaed-benthic" ] ; then
  echo build libaed-benthic
  cd "${CWD}/libaed-benthic"
  get_commit_id >> ${CWD}/cur_state.log
  ${MAKE} || exit 1
  DAEDBENDIR=`pwd`
fi

if [ -d "${CWD}/libaed-demo" ] ; then
  echo build libaed-demo
  cd "${CWD}/libaed-demo"
  get_commit_id >> ${CWD}/cur_state.log
  ${MAKE} || exit 1
  DAEDDMODIR=`pwd`
fi

if [ "$WITH_AED_PLUS" = "true" ] ; then
  if [ -d "${CWD}/libaed-riparian" ] ; then
    echo build libaed-riparian
    cd "${CWD}/libaed-riparian"
    get_commit_id >> ${CWD}/cur_state.log
    ${MAKE} || exit 1
    DAEDRIPDIR=`pwd`
  fi

  if [ -d "${CWD}/libaed-light" ] ; then
    echo build libaed-light
    cd "${CWD}/libaed-light"
    get_commit_id >> ${CWD}/cur_state.log
    ${MAKE} || exit 1
    DAEDLGTDIR=`pwd`
  fi

  if [ -d "${CWD}/libaed-dev" ] ; then
    if [ -d "${CWD}/phreeqcrm" ] ; then
      PHREEQDIR="${CWD}/phreeqcrm"
      cd "${CWD}/phreeqcrm"

      mkdir build

      cd build
      cmake ..

      ${MAKE}
      if [ ! -f build/libPhreeqcRM.a ] ; then
        echo building build/libPhreeqcRM.a failed
        unset PHREEQDIR
      else
        cp build/libPhreeqcRM.a ${CWD}/libaed-dev/lib
      fi
    fi

    if [ -d "${CWD}/modflow6" ] ; then
      which meson > /dev/null 2>&1
      if [ $? -eq 0 ] ; then
        MODFLOWDIR="${CWD}/modflow6"
        cd "${CWD}/modflow6"

        meson setup build --buildtype="release" --prefix="${CWD}/tmp"
        meson compile -C build

        if [ ! -f build/srcbmi/libmf6.so ] ; then
          echo building libmf6.so failed
          unset MODFLOWDIR
        else
          mkdir ${CWD}/libaed-dev/mod
          mkdir ${CWD}/libaed-dev/lib
          cp build/srcbmi/libmf6.so.p/*.mod ${CWD}/libaed-dev/mod
          cp build/srcbmi/libmf6.so ${CWD}/libaed-dev/lib
          if [ "$FC" != "gfortran" ] ; then
            cp build/src/libmf6core.a.p/mf6coremodule.mod   ${CWD}/libaed-dev/mod
            cp build/src/libmf6core.a.p/simstagesmodule.mod ${CWD}/libaed-dev/mod
            cp build/src/libmf6core.a.p/profilermodule.mod  ${CWD}/libaed-dev/mod
            cp build/src/libmf6core.a.p/characterstringmodule.mod ${CWD}/libaed-dev/mod
          fi
        fi
      else
        echo "no meson - skipping modflow6"
      fi
    fi

    echo build libplot
    cd "${CWD}/libplot"
    get_commit_id >> ${CWD}/cur_state.log
    ${MAKE} || exit 1

    echo build libutil
    cd "${CWD}/libutil"
    get_commit_id >> ${CWD}/cur_state.log
    ${MAKE} || exit 1

    echo build libaed-dev
    cd "${CWD}/libaed-dev"
    get_commit_id >> ${CWD}/cur_state.log
    MORE_FLAGS=""
    if [ "$PHREEQDIR" != "" ] ; then
      MORE_FLAGS="$MORE_FLAGS PHREEQDIR=$PHREEQDIR"
    fi
    if [ "$MODFLOWDIR" != "" ] ; then
      MORE_FLAGS="$MORE_FLAGS MODFLOWDIR=$MODFLOWDIR"
    fi
    if [ "$WITH_MPI" = "true" ] ; then
     # This breaks things - something to do with mpifort that gets called
     #MORE_FLAGS="$MORE_FLAGS WITH_MPI=true"
      MORE_FLAGS="$MORE_FLAGS WITH_MPI=false"
    fi
    ${MAKE} $MORE_FLAGS || exit 1
    DAEDDEVDIR=`pwd`
  fi
fi

if [ -d "${CWD}/libaed-api" ] ; then
  echo build libaed-api
  cd "${CWD}/libaed-api"
  get_commit_id >> ${CWD}/cur_state.log
  ${MAKE} || exit 1
  DAEDAPIDIR=`pwd`
  if [ "$WITH_AED_PLUS" != "true" ] ; then
    ${MAKE} NO_RIPARIAN=1 NO_LGT=1 NO_DEV=1 obj/aed_external.o
  fi
fi

cd ${CWD}
