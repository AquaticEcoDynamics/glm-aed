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
export NETCDFFV=4.5.4

#@REM The directory Build has project files to build the libraries using
#@REM VisualStudio 2017/2019 ; use all_libs.sln. They are set up to
#@REM access source files from directories in this directory called :
#@REM 
#@REM They are available from :
#@REM 
#@REM zlib           : http://www.zlib.net/
#@REM freetype       : http://www.freetype.org/download.html
#@REM jpeg           : http://www.ijg.org/
#@REM libpng         : http://www.libpng.org/pub/png/libpng.html
#@REM libgd          : http://libgd.github.io/
#@REM curl           : https://curl.haxx.se/download.html
#@REM szip           : https://support.hdfgroup.org/doc_resource/SZIP/
#@REM hdf5           : https://www.hdfgroup.org/downloads/hdf5/source-code/
#@REM netcdf &
#@REM netcdf-fortran : https://www.unidata.ucar.edu/downloads/netcdf/index.jsp
#@REM 

export ZLIB=zlib-${ZLIBV}
export FREETYPE2=freetype-${FRREETYPE2V}
export JPEG=jpegsrc.v${JPEGV}
export LIBPNG=libpng-${LIBPNGV}
export LIBGD=lib${GD}
export CURL=curl-${CURLV}
export SZIP=szip-${SZIPV}
export HDF5=hdf5-${HDF5V}
export NETCDF=netcdf-c-${NETCDFV}
export NETCDFF=netcdf-fortran-${NETCDFFV}

   if [ ! -d jpeg-${JPEGV} ] ; then
     if [ -f ${JPEG}.tar.gz ] ; then
       echo Unpacking ${JPEG}.tar.gz
       tar -xzf ${JPEG}.tar.gz
     else
       echo ${JPEG}.tar.gz not found!
     fi
   fi

#----------------------------------------------------------------
unpack_src () {
   src=$1
   if [ ! -d $src ] ; then
      if [ -f $src.tar.gz ] ; then
       echo Unpacking $src.tar.gz
       tar -xzf $src.tar.gz
     else
       echo $src.tar.gz not found!
     fi
   fi
}
#----------------------------------------------------------------

   unpack_src  $ZLIB
   unpack_src  $LIBPNG
   unpack_src  $FREETYPE2
   unpack_src  $LIBGD
   patch -p0 < libgd.patch
   unpack_src  $SZIP
   unpack_src  $CURL
   unpack_src  $HDF5
   unpack_src  $NETCDF
   unpack_src  $NETCDFF

exit 0

