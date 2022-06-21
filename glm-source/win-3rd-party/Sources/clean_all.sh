#!/bin/sh

export ZLIBV=1.2.12
export FRREETYPE2V=2.12.1
export JPEGV=9e
export LIBPNGV=1.6.37
export GD=gd-2.3.3
export CURLV=7.83.1
export SZIPV=2.1.1
export HDF5V=1.12.0
export NETCDFV=4.8.1
#export NETCDFFV=4.5.4

export DSTDIR=x64-Release
export ZLIB=zlib-${ZLIBV}
export FREETYPE2=freetype-${FRREETYPE2V}
export JPEG=jpegsrc.v${JPEGV}
export LIBPNG=libpng-${LIBPNGV}
export LIBGD=lib${GD}
export CURL=curl-${CURLV}
export SZIP=szip-${SZIPV}
export HDF5=hdf5-${HDF5V}
export NETCDF=netcdf-c-${NETCDFV}
#export NETCDFF=netcdf-fortran-${NETCDFFV}


for i in $SZIP $ZLIB $HDF5 $LIBPNG $CURL $FREETYPE2 ; do
   if [ -d $i ] ; then
      rm -rf $i
   fi
done

   if [ -d jpeg-${JPEGV} ] ; then
      rm -rf jpeg-${JPEGV}
   fi

#for i in $LIBGD $NETCDF $NETCDFF ; do
for i in $LIBGD $NETCDF ; do
   if [ -d $i ] ; then
      rm -rf $i
   fi
done
