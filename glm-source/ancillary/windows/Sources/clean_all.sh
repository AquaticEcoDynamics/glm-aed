#!/bin/sh

. ./versions.inc

export DSTDIR=msys
export ZLIB=zlib-${ZLIBV}
export FREETYPE2=freetype-${FRREETYPE2V}
export JPEG=jpegsrc.v${JPEGV}
export LIBPNG=libpng-${LIBPNGV}
export LIBGD=lib${GD}
export CURL=curl-${CURLV}
export SZIP=szip-${SZIPV}
export LIBAEC=libaec-${LIBAECV}
export HDF5=hdf5-${HDF5V}
export NETCDF=netcdf-c-${NETCDFV}
export NETCDFF=netcdf-fortran-${NETCDFFV}


for i in $SZIP $ZLIB $LIBAEC $HDF5 $LIBPNG $CURL $FREETYPE2 ; do
   if [ -d $i ] ; then
      rm -rf $i
   fi
done

   if [ -d jpeg-${JPEGV} ] ; then
      rm -rf jpeg-${JPEGV}
   fi

for i in $LIBGD $NETCDF $NETCDFF ; do
   if [ -d $i ] ; then
      rm -rf $i
   fi
done
