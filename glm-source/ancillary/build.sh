#!/bin/sh
#

export FINALDIR=`pwd`

# -----------------------

cd sources

if [ $# -gt 0 ] ; then
  ./build_all.sh $*
else
  echo "build --all"
  if [ "$OSTYPE" = "FreeBSD" ] ; then
    ./build_all.sh --need-ncdfc-extras --need-netcdf_c --need-gd
  else
    ./build_all.sh --all
  fi
fi

exit $?
