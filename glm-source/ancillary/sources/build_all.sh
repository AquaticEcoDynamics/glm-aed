#!/bin/bash

export DO_CDFCE=""
export DO_CDFC=""
export DO_CDFF=""
export DO_MPICH=""
export DO_OMPI=""
export DO_GD=""
export DO_SQLITE=""

export CWD=`pwd`
if [ "${FINALDIR}" = "" ] ;  then
  echo no FINALDIR defined
  exit 1
fi

ARGS=""
while [ $# -gt 0 ] ; do
  case $1 in
    --help)
      PRTHELP=true
      ;;
    --all)
      export DO_CDFCE=true
      export DO_CDFC=true
      export DO_CDFF=true
      export DO_GD=true
      ./fetch_all.sh $1 || exit 1
      ;;
    --need-ncdfc-extras)
      export DO_CDFCE=true
      ./fetch_all.sh $1 || exit 1
      export DO_CDFC=true
      ;;
    --need-netcdf_c)
      ./fetch_all.sh $1 || exit 1
      export DO_CDFC=true
      ;;
    --need-netcdf_f)
      ./fetch_all.sh $1 || exit 1
      export DO_CDFF=true
      ;;
    --need-mpich)
      ./fetch_all.sh $1 || exit 1
      export DO_MPICH=true
      ;;
    --need-openmpi)
      ./fetch_all.sh $1 || exit 1
      export DO_OMPI=true
      ;;
    --need-gd)
      ./fetch_all.sh $1 || exit 1
      export DO_GD=true
      ;;
    --need-sqlite)
      ./fetch_all.sh $1 || exit 1
      export DO_SQLITE=true
      ;;
    --debug)
      export DEBUG=true
      ;;
    *)
      echo "build_all.sh: unknown flag $1"
      PRTHELP=true
      ;;
  esac
  shift
done

#----------------------------------------------------------------
if [ "$PRTHELP" = "true" ] ; then
  echo " --help              : print this blurb"
  echo " --need-ncdfc-extras : build the extra stuff needed by netcdf-c"
  echo " --need-netcdf_c     : build netcdf-c"
  echo " --need-netcdf_f     : build netcdf-fortran"
  echo " --need-mpich        : build mpich version of MPI"
  echo " --need-openmpi      : build openmpi version of MPI"
  echo " --need-gd           : build gd lib (include a few other libs needed by gd"
  echo " --need-sqlite       : build sqlite lib"
  echo " --all               : shorthand for extras, c, f, openmpi and gd"
  echo " --debug             : currently does nothing"

  exit 0
fi

#----------------------------------------------------------------

. ./versions.inc

. ./scripts/common.inc

if [ "$DO_CDFC" = "true" ] ; then
  if [ "$DO_CDFCE" = "true" ] ; then
    . ./scripts/build_extras.inc
  fi
  . ./scripts/build_netcdf_c.inc
fi
if [ "$DO_CDFF" = "true" ] ; then
  . ./scripts/build_netcdf_f.inc
fi
if [ "$DO_MPICH" = "true" ] ; then
  . ./scripts/build_mpich.inc
fi
if [ "$DO_OMPI" = "true" ] ; then
  . ./scripts/build_openmpi.inc
fi
if [ "$DO_GD" = "true" ] ; then
  . ./scripts/build_gd.inc
fi
if [ "$DO_SQLITE" = "true" ] ; then
  . ./scripts/build_sqlite.inc
fi

exit 0
