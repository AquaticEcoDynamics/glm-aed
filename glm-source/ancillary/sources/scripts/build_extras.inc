# ============================================================================
# ============================================================================

. ./scripts/build_zlib.inc

#---------------

#if [ "$LIBAEC" != "" ] ; then
if [ ! -f "${FINALDIR}/lib/libaec.a" ] ; then
  echo "====== building $LIBAEC"

  \rm -rf $LIBAEC
  tar xzf $LIBAEC.tar.gz
  if [ ! -d $LIBAEC ] ; then
    echo cant unpack $LIBAEC.tar.gz
    exit 1
  fi
  cd $LIBAEC
  mkdir build
  cd build

  cmake .. -G "Unix Makefiles" \
           -DCMAKE_FIND_ROOT_PATH="${FINALDIR}" \
           -DBUILD_SHARED_LIBS:BOOL=OFF \
           -DCMAKE_BUILD_TYPE:STRING=Release \
           -DCMAKE_INSTALL_PREFIX="${FINALDIR}" -LAH > ${FINALDIR}/cmake-info-libaec 2>&1
  if [ $? -ne 0 ] ; then
    echo cmake $LIBAEC failed
    exit 1
  fi

  cmake --build . --clean-first --config Release #--target INSTALL
  if [ $? -ne 0 ] ; then
    echo $LIBAEC build failed
    exit 1
  fi
  cmake -P cmake_install.cmake
  /bin/rm ${FINALDIR}/lib/libsz.dll.a

  cd $CWD

  summary $LIBAEC
fi

#---------------

#if [ "$CURL" != "" ] ; then
if [ ! -f "${FINALDIR}/lib/libcurl.a" ] ; then
  echo "====== building $CURL"

  \rm -rf $CURL
  tar xzf $CURL.tar.gz
  if [ ! -d $CURL ] ; then
    echo cant unpack $CURL.tar.gz
    exit 1
  fi
  cd $CURL
  mkdir build
  cd build

  cmake .. -G "Unix Makefiles" \
           -DCMAKE_FIND_ROOT_PATH="${FINALDIR}" \
           -DBUILD_SHARED_LIBS:BOOL=OFF \
           -DBUILD_STATIC_CURL:BOOL=ON \
           -DCURL_USE_LIBPSL:BOOL=OFF \
           -DCMAKE_BUILD_TYPE:STRING=Release \
           -DZLIB_LIBRARY_RELEASE:FILEPATH="${FINALDIR}/lib/${LIBZA}" \
           -DCMAKE_INSTALL_PREFIX="${FINALDIR}" -LAH > ${FINALDIR}/cmake-info-curl 2>&1
  if [ $? -ne 0 ] ; then
    echo cmake $CURL failed
    exit 1
  fi

  cmake --build . --clean-first --config Release #--target INSTALL
  if [ $? -ne 0 ] ; then
    echo $CURL build failed
    exit 1
  fi
  cmake -P cmake_install.cmake

  cd $CWD

  summary $CURL
fi

#---------------

#if [ "$HDF5" != "" ] ; then
if [ ! -f "${FINALDIR}/lib/libhdf5.a" ] ; then
  echo "====== building $HDF5"

  \rm -rf $HDF5
  tar xzf $HDF5.tar.gz
  if [ ! -d $HDF5 ] ; then
    echo cant unpack $HDF5.tar.gz
    exit 1
  fi
  cd $HDF5
  mkdir build
  cd build

  cmake .. -G "Unix Makefiles" \
           -DCMAKE_FIND_ROOT_PATH="${FINALDIR}"  \
           -DBUILD_SHARED_LIBS:BOOL=OFF \
           -DCMAKE_BUILD_TYPE:STRING=Release \
           -DBUILD_TESTING=OFF  \
           -DCMAKE_C_FLAGS="-I${FINALDIR}/include -DFLT16_MAX=__FLT16_MAX__"  \
           -DHDF5_ENABLE_Z_LIB_SUPPORT:PATH="${FINALDIR}"  \
           -DHDF5_ENABLE_SZIP_SUPPORT:PATH="${FINALDIR}" \
           -DHDF5_USE_LIBAEC_STATIC:BOOL=ON \
           -DHDF5_USE_ZLIB_STATIC:BOOL=ON \
           -DSZIP_USE_EXTERNAL:BOOL=ON \
           -Dlibaec_DIR="${FINALDIR}" \
           -Dlibaec_LIBRARY="${FINALDIR}/lib/libaec.a" \
           -DZLIB_DIR:PATH="${FINALDIR}" \
           -DZLIB_LIBRARY:PATH="${FINALDIR}/lib/${LIBZA}"  \
           -DSZIP_LIBRARY:PATH="${FINALDIR}/lib/libsz.a"  \
           -DHDF5_BUILD_CXX:BOOL=OFF \
           -DHDF5_BUILD_FORTRAN:BOOL=OFF \
           -DCMAKE_INSTALL_PREFIX="${FINALDIR}" -LAH > ${FINALDIR}/cmake-info-hdf5 2>&1

  if [ $? -ne 0 ] ; then
    echo cmake $HDF5 failed
    exit 1
  fi

  cmake --build . --clean-first --config Release #--target INSTALL
  if [ $? -ne 0 ] ; then
    echo $HDF5 build failed
    exit 1
  fi
  cmake -P cmake_install.cmake

  cd $CWD

  summary $HDF5
fi

#---------------
