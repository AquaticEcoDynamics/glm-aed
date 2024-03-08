#!/bin/sh

./fetch_all.sh
if [ $? != 0 ] ; then
  exit 1
else
  ./build_netcdf.sh
fi
if [ $? != 0 ] ; then
  exit 1
else
  ./build_gd.sh
 fi

exit 0
