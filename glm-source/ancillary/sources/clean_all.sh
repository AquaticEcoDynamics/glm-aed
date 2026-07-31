#!/bin/bash

SQUEEKY="false"

while [ $# -gt 0 ] ; do
  case $1 in
    --squeeky)
      export SQUEEKY=true
      ;;
    *)
      echo "unknown option \"$1\""
      ;;
  esac
  shift
done

. ./versions.inc

JPEGD=jpeg-${JPEGV}


if [ -d ${NETCDF} ] ; then
  rm -rf ${NETCDF}
fi
if [ -d ${NETCDFF} ] ; then
  rm -rf ${NETCDFF}
fi
if [ -d ${MPICH} ] ; then
  rm -rf ${MPICH}
fi
if [ -d ${OMPI} ] ; then
  rm -rf ${OMPI}
fi
if [ -d ${ZLIB} ] ; then
  rm -rf ${ZLIB}
fi
if [ -d ${FREETYPE2} ] ; then
  rm -rf ${FREETYPE2}
fi
if [ -d ${JPEGD} ] ; then
  rm -rf ${JPEGD}
fi
if [ -d ${LIBPNG} ] ; then
  rm -rf ${LIBPNG}
fi
if [ -d ${LIBGD} ] ; then
  rm -rf ${LIBGD}
fi
if [ -d ${CURL} ] ; then
  rm -rf ${CURL}
fi
if [ -d ${LIBAEC} ] ; then
  rm -rf ${LIBAEC}
fi
if [ -d ${HDF5} ] ; then
  rm -rf ${HDF5}
fi

if [ "$SQUEEKY" = "false" ] ; then exit 0 ; fi

if [ -f ${NETCDF}.tar.gz ] ; then
  rm ${NETCDF}.tar.gz
fi
if [ -f ${NETCDFF}.tar.gz ] ; then
  rm ${NETCDFF}.tar.gz
fi
if [ -f ${MPICH}.tar.gz ] ; then
  rm ${MPICH}.tar.gz
fi
if [ -f ${OMPI}.tar.gz ] ; then
  rm ${OMPI}.tar.gz
fi
if [ -f ${ZLIB}.tar.gz ] ; then
  rm ${ZLIB}.tar.gz
fi
if [ -f ${FREETYPE2}.tar.gz ] ; then
  rm ${FREETYPE2}.tar.gz
fi
if [ -f ${JPEG}.tar.gz ] ; then
  rm ${JPEG}.tar.gz
fi
if [ -f ${LIBPNG}.tar.gz ] ; then
  rm ${LIBPNG}.tar.gz
fi
if [ -f ${LIBGD}.tar.gz ] ; then
  rm ${LIBGD}.tar.gz
fi
if [ -f ${CURL}.tar.gz ] ; then
  rm ${CURL}.tar.gz
fi
if [ -f ${LIBAEC}.tar.gz ] ; then
  rm ${LIBAEC}.tar.gz
fi
if [ -f ${HDF5}.tar.gz ] ; then
  rm ${HDF5}.tar.gz
fi

exit 0
