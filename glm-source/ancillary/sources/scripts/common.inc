# ============================================================================

export CFLAGS="-I${FINALDIR}/include"
export CPPFLAGS="-I${FINALDIR}/include"
export LDFLAGS="-L${FINALDIR}/lib"

# Work out what system type we are operating on
case `uname` in
  "Darwin"|"Linux"|"FreeBSD")
    export OSTYPE=`uname -s`
    export CFLAGS="$CFLAGS -fPIC"
    export LIBZA=libz.a
    ;;
  MINGW*)
    export OSTYPE="Msys"
    if [ "${ZLIBV}" = "1.3.1" ] ; then
      export LIBZA=libzlibstatic.a
    else
      export LIBZA=libzs.a
    fi
    ;;
esac

#---------------
summary () {
  where=$1
  echo "==================================="
  echo "$FINALDIR after building $1"
  ls $FINALDIR
  echo '--> include'
  ls $FINALDIR/include
  echo '--> lib'
  ls $FINALDIR/lib
  echo "==================================="
  echo
}

#---------------

if [ ! -d $FINALDIR/include ] ; then
  mkdir $FINALDIR/include
fi
if [ ! -d $FINALDIR/lib ] ; then
  mkdir $FINALDIR/lib
fi

#---------------

TARGET_LIBAEC=libaec.a
TARGET_LIBCURL=libcurl.a
TARGET_LIBFREETYPE=libfreetype.a
TARGET_LIBGD=libgd.so
TARGET_LIBHDF=libhdf5.settings
TARGET_LIBHDF=libhdf5.a
TARGET_LIBJPEG=libjpeg.a
TARGET_LIBNETCDF=libnetcdf.settings
TARGET_LIBNETCDF=libnetcdf.so
TARGET_LIBNETCDFF=libnetcdff.settings
TARGET_LIBNETCDFF=libnetcdff.so
TARGET_LIBPNG=libpng.a
TARGET_LIBSZ=libsz.a
TARGET_LIBZ=${LIBZA}

#---------------
