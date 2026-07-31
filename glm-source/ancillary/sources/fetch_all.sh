#!/bin/bash

export GETCDFCE=""
export GETCDFC=""
export GETCDFF=""
export GETMPICH=""
export GETOMPI=""
export GET_GD=""
export GET_SQLITE=""

ARGS=""
while [ $# -gt 0 ] ; do
  case $1 in
    --all)
      export GETCDFCE=true
      export GETCDFC=true
      export GETCDFF=true
      export GET_GD=true
      ;;
    --unpack)
      export UNPACK=true
      ;;
    --ignore-certs)
      export MINUS_K='-k'
      ;;
    --need-ncdfc-extras)
      export GETCDFCE=true
      export GETCDFC=true
      ;;
    --need-netcdf_c)
      export GETCDFC=true
      ;;
    --need-netcdf_f)
      export GETCDFF=true
      ;;
    --need-mpich)
      export GETMPICH=true
      ;;
    --need-openmpi)
      export GETOMPI=true
      ;;
    --need-gd)
      export GET_GD=true
      ;;
    --need-sqlite)
      export GET_SQLITE=true
      ;;
    --debug)
      export DEBUG=true
      ;;
    *)
      echo "fetch_all.sh: unknown flag $1"
      ;;
  esac
  shift
done

# ------------------------------------------

. ./versions.inc

. ./scripts/common.inc

if [ "$OSTYPE" = "Msys" ] ; then
  export MINUS_K='-k'
fi

# ------------------------------------------

if [ "$GETCDFCE" = "true" ] ; then
  . ./scripts/fetch_extras.inc
fi

if [ "$GETCDFC" = "true" ] ; then
  if [ ! -f ${NETCDF}.tar.gz ] ; then
    echo fetching ${NETCDF}.tar.gz
    curl ${MINUS_K} -LJO https://github.com/Unidata/netcdf-c/archive/refs/tags/v${NETCDFV}.tar.gz
    if [ $? -ne 0 ] ; then
      echo failed to fetch ${NETCDF}.tar.gz
      exit 1
    elif [ "$UNPACK" = "true" ] ; then
      tar xzf ${NETCDF}.tar.gz
    fi
  fi
fi

if [ "$GETCDFF" = "true" ] ; then
  if [ ! -f ${NETCDFF}.tar.gz ] ; then
    echo fetching ${NETCDFF}.tar.gz
    curl ${MINUS_K} -LJO https://github.com/Unidata/netcdf-fortran/archive/refs/tags/v${NETCDFFV}.tar.gz
    if [ $? -ne 0 ] ; then
      echo failed to fetch ${NETCDFF}.tar.gz
      exit 1
    elif [ "$UNPACK" = "true" ] ; then
      tar xzf ${NETCDFF}.tar.gz
    fi
  fi
fi

if [ "$GETMPICH" = "true" ] ; then
  if [ ! -f ${MPICH}.tar.gz ] ; then
    echo fetching ${MPICH}.tar.gz
    curl ${MINUS_K} -LJO https://www.mpich.org/static/downloads/${MPICHV}/${MPICH}.tar.gz
    if [ $? -ne 0 ] ; then
      echo failed to fetch ${MPICH}.tar.gz
      exit 1
    elif [ "$UNPACK" = "true" ] ; then
      tar xzf ${MPICH}.tar.gz
    fi
  fi
fi

if [ "$GETOMPI" = "true" ] ; then
  if [ ! -f ${OMPI}.tar.gz ] ; then
    echo fetching ${OMPI}.tar.gz
    curl ${MINUS_K} -LJO https://download.open-mpi.org/release/open-mpi/v${OMPIMAJ}/openmpi-${OMPIV}.tar.gz
    if [ $? -ne 0 ] ; then
      echo failed to fetch ${OMPI}.tar.gz
      exit 1
    elif [ "$UNPACK" = "true" ] ; then
      tar xzf ${OMPI}.tar.gz
    fi
  fi
fi

if [ "$GET_GD" = "true" ] ; then
  . ./scripts/fetch_gd.inc
fi

if [ "$GET_SQLITE" = "true" ] ; then
  . ./scripts/fetch_sqlite.inc
fi

exit $?
