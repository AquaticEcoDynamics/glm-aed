#!/bin/sh

CWD=`pwd`

if [ ! -d  ../msys ] ; then
  mkdir ../msys
fi
cd ../msys
export FINALDIR=`pwd`
cd "$CWD"

. ./versions.inc

if [ ! -f "$FINALDIR/lib/libzlibstatic.a" ] ; then
  export ZLIB="zlib-$ZLIBV"
fi

export CURL="curl-$CURLV"
export LIBAEC="libaec-${LIBAECV}"
export HDF5="hdf5-$HDF5V"
export NETCDF="netcdf-c-$NETCDFV"
#export NETCDFF="netcdf-fortran-$NETCDFFV"

#---------------

export CFLAGS="-I$FINALDIR/include"
export CPPFLAGS="-I$FINALDIR/include"
export LDFLAGS="-L$FINALDIR/lib"

#---------------
summary () {
  where=$1
  echo "==================================="
  echo "mysy after building $1"
  ls ../msys
  echo 'include'
  ls ../msys/include
  echo 'lib'
  ls ../msys/lib
  echo "==================================="
  echo
}


#---------------
if [ ! -d ../msys ] ; then
  mkdir ../msys
fi
if [ ! -d ../msys/include ] ; then
  mkdir ../msys/include
fi
if [ ! -d ../msys/lib ] ; then
  mkdir ../msys/lib
fi
#---------------

if [ "$ZLIB" != "" ] ; then
  echo "====== building $ZLIB"

  \rm -rf $ZLIB
  tar xzf $ZLIB.tar.gz
  cd $ZLIB
  mkdir build
  cd build

  cmake .. -G "MinGW Makefiles" \
           -DCMAKE_FIND_ROOT_PATH="$FINALDIR" \
           -DBUILD_SHARED_LIBS:BOOL=OFF \
           -DZLIB_BUILD_EXAMPLES:BOOL=OFF \
           -DCMAKE_BUILD_TYPE:STRING=Release \
           -DCMAKE_INSTALL_PREFIX="$FINALDIR" -LAH >& ../../cmake-info-zlib
  if [ $? != 0 ] ; then
    echo cmake $ZLIB failed
    exit 1
  fi

  cmake --build . --clean-first --config Release #--target INSTALL
  if [ $? != 0 ] ; then
    echo $ZLIB build failed
    exit 1
  fi
  cmake -P cmake_install.cmake

  cd $CWD

  summary $ZLIB
fi

#---------------

if [ "$LIBAEC" != "" ] ; then
  echo "====== building $LIBAEC"

  \rm -rf $LIBAEC
  tar xzf $LIBAEC.tar.gz
  cd $LIBAEC
  mkdir build
  cd build

  cmake .. -G "MinGW Makefiles" \
           -DCMAKE_FIND_ROOT_PATH="$FINALDIR" \
           -DBUILD_SHARED_LIBS:BOOL=OFF \
           -DCMAKE_BUILD_TYPE:STRING=Release \
           -DCMAKE_INSTALL_PREFIX="$FINALDIR" -LAH >& ../../cmake-info-libaec
  if [ $? != 0 ] ; then
    echo cmake $LIBAEC failed
    exit 1
  fi

  cmake --build . --clean-first --config Release #--target INSTALL
  if [ $? != 0 ] ; then
    echo $LIBAEC build failed
    exit 1
  fi
  cmake -P cmake_install.cmake
  /bin/rm $FINALDIR/lib/libsz.dll.a

  cd $CWD

  summary $LIBAEC
fi

#---------------

if [ "$CURL" != "" ] ; then
  echo "====== building $CURL"

  \rm -rf $CURL
  tar xzf $CURL.tar.gz
  cd $CURL
  mkdir build
  cd build

  cmake .. -G "MinGW Makefiles" \
           -DCMAKE_FIND_ROOT_PATH="$FINALDIR" \
           -DBUILD_SHARED_LIBS:BOOL=OFF \
           -DBUILD_STATIC_CURL:BOOL=ON \
           -DCMAKE_BUILD_TYPE:STRING=Release \
           -DZLIB_LIBRARY_RELEASE:FILEPATH="$FINALDIR/lib/libzlibstatic.a" \
           -DCMAKE_INSTALL_PREFIX="$FINALDIR" -LAH >& ../../cmake-info-curl
  if [ $? != 0 ] ; then
    echo cmake $CURL failed
    exit 1
  fi

  cmake --build . --clean-first --config Release #--target INSTALL
  if [ $? != 0 ] ; then
    echo $CURL build failed
    exit 1
  fi
  cmake -P cmake_install.cmake

  cd $CWD

  summary $CURL
fi

#---------------

if [ "$HDF5" != "" ] ; then
  echo "====== building $HDF5"

  \rm -rf $HDF5
  tar xzf $HDF5.tar.gz
  cd $HDF5
  mkdir build
  cd build

  cmake .. -G "MinGW Makefiles" \
           -DCMAKE_FIND_ROOT_PATH="$FINALDIR"  \
           -DBUILD_SHARED_LIBS:BOOL=OFF \
           -DCMAKE_BUILD_TYPE:STRING=Release \
           -DBUILD_TESTING=OFF  \
           -DCMAKE_C_FLAGS="-I$FINALDIR/include"  \
           -DHDF5_ENABLE_Z_LIB_SUPPORT:PATH="$FINALDIR"  \
           -DHDF5_ENABLE_SZIP_SUPPORT:PATH="$FINALDIR" \
           -Dlibaec_DIR="$FINALDIR" \
           -Dlibaec_LIBRARY="$FINALDIR/lib/libaec.a" \
           -DZLIB_DIR:PATH="$FINALDIR" \
           -DZLIB_LIBRARY:PATH="$FINALDIR/lib/libzlibstatic.a"  \
           -DSZIP_LIBRARY:PATH="$FINALDIR/lib/libsz.a"  \
           -DHDF5_BUILD_CXX:BOOL=OFF \
           -DHDF5_BUILD_FORTRAN:BOOL=OFF \
           -DCMAKE_INSTALL_PREFIX="$FINALDIR" -LAH >& ../../cmake-info-hdf5

#          -DZLIB_INCLUDE_DIR="$FINALDIR/include"  \
#          -DSZIP_INCLUDE_DIR="$FINALDIR/include"  \
#          -DDEFAULT_API_VERSION:STRING=v110  \

  if [ $? != 0 ] ; then
    echo cmake $HDF5 failed
    exit 1
  fi

  cmake --build . --clean-first --config Release #--target INSTALL
  if [ $? != 0 ] ; then
    echo $HDF5 build failed
    exit 1
  fi
  cmake -P cmake_install.cmake

  cd $CWD

  summary $HDF5
fi

#---------------

if [ "$NETCDF" != "" ] ; then
  echo "====== building $NETCDF"

  \rm -rf $NETCDF
  tar xzf $NETCDF.tar.gz
  cd $NETCDF
  if [ ! -d fuzz ] ; then
    mkdir fuzz
    touch fuzz/CMakeLists.txt
  fi

  mkdir build
  cd build

  cmake .. -G "MinGW Makefiles" \
           -DCMAKE_FIND_ROOT_PATH="$FINALDIR"  \
           -DBUILD_SHARED_LIBS:BOOL=ON \
           -DCMAKE_BUILD_TYPE:STRING=Release \
           -DCURL_LIBRARIES=OFF \
           -DENABLE_TESTS=OFF \
           -DENABLE_DAP=OFF \
           -DBUILD_UTILITIES:BOOL=OFF \
           -DENABLE_BYTERANGE:BOOL=OFF \
           -DENABLE_NCZARR:BOOL=OFF \
           -DZLIB_LIBRARY:PATH="$FINALDIR/lib/libzlibstatic.a"  \
           -DSZIP_LIBRARY:PATH="$FINALDIR/lib/libsz.a"  \
           -DCMAKE_MODULE_LINKER_FLAGS:STRING=-L"$FINALDIR/lib" \
           -DCMAKE_VERBOSE_MAKEFILE:BOOL=TRUE \
           -DCMAKE_INSTALL_PREFIX="$FINALDIR" -LAH >& ../../cmake-info-netcdf-c

#          -DBUILD_SHARED_LIBS:BOOL=ON \
#          -DCMAKE_BUILD_TYPE:STRING=Release \
#          -DHDF5_C_LIBRARY="$FINALDIR" \
#          -DHDF5_ROOT="$FINALDIR" \
#          -DSZIP_ROOT="$FINALDIR" \
#          -DZLIB_ROOT="$FINALDIR" \
#          -DHDF5_DIR="$FINALDIR/cmake/hdf5" \

  if [ $? != 0 ] ; then
    echo cmake $NETCDF failed
    exit 1
  fi

  cmake --build . --clean-first --config Release #--target INSTALL
  if [ $? != 0 ] ; then
    echo $NETCDF build failed
    exit 1
  fi
  cmake -P cmake_install.cmake

  cd $CWD

  summary $NETCDF
fi

#---------------

if [ "$NETCDFF" != "" ] ; then
  echo "====== building $NETCDFF"

  \rm -rf $NETCDFF
  tar xzf $NETCDFF.tar.gz
  cd $NETCDFF
  sed -i -e 's!CHECK_LIBRARY_EXISTS(${NETCDF_C_LIBRARY} nc_def_var_szip "" HAVE_DEF_VAR_SZIP)!SET(HAVE_DEF_VAR_SZIP TRUE)!' CMakeLists.txt


  mkdir build
  cd build

  export NetCDF_ROOT=$FINALDIR
  export NetCDF_C_ROOT=$FINALDIR
# export CPPFLAGS="-I${FINALDIR}/include"
# export LDFLAGS="-L${FINALDIR} -lnetcdf"

  cmake .. -G "MinGW Makefiles" \
           -DCMAKE_FIND_ROOT_PATH="$FINALDIR" \
           -DBUILD_SHARED_LIBS:BOOL=OFF  \
           -DCMAKE_BUILD_TYPE:STRING=Release \
           -DENABLE_TESTS=OFF \
           -DBUILD_TESTING:BOOL=OFF \
           -DBUILD_UTILITIES:BOOL=OFF \
           -DBUILD_EXAMPLES:BOOL=OFF \
           -DNETCDF_INCLUDE_DIR="$FINALDIR/include" \
           -DNETCDF_C_LIBRARY="$FINALDIR/lib/netcdf.lib" \
           -DCMAKE_INSTALL_PREFIX="$FINALDIR" -LAH >& ../../cmake-info-netcdf-f

  if [ $? != 0 ] ; then
    echo cmake $NETCDFF failed
    exit 1
  fi

  cmake --build . --clean-first --config Release #--target INSTALL
  if [ $? != 0 ] ; then
    echo $NETCDFF build failed
    exit 1
  fi
  cmake -P cmake_install.cmake
  if [ -d "${FINALDIR}/include/Release" ] ; then
    mv "${FINALDIR}/include/Release/"* "${FINALDIR}/include/"
    rmdir "${FINALDIR}/include/Release"
  fi

  cd $CWD

  summary $NETCDFF
fi


exit 0
