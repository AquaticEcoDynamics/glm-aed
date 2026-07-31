# ===========================================================================

if [ ! -f "${FINALDIR}/lib/libnetcdf.a" ] && \
   [ ! -f "${FINALDIR}/lib/libnetcdf.so" ] && \
   [ ! -f "${FINALDIR}/lib/libnetcdf.dylib" ] ; then
  echo "====== building $NETCDF"

  \rm -rf $NETCDF
  tar xzf $NETCDF.tar.gz
  if [ ! -d $NETCDF ] ; then
    echo error extracting $NETCDF
    exit 1
  fi
  cd $NETCDF
  if [ ! -d fuzz ] ; then
    mkdir fuzz
    touch fuzz/CMakeLists.txt
  fi

  mkdir build
  cd build

  cmake .. -G "Unix Makefiles" \
           -DCMAKE_FIND_ROOT_PATH="${FINALDIR}"  \
           -DBUILD_SHARED_LIBS:BOOL=ON \
           -DCMAKE_BUILD_TYPE:STRING=Release \
           -DCURL_LIBRARIES=OFF \
           -DENABLE_TESTS=OFF \
           -DENABLE_DAP=OFF \
           -DBUILD_UTILITIES:BOOL=OFF \
           -DENABLE_BYTERANGE:BOOL=OFF \
           -DENABLE_NCZARR:BOOL=OFF \
           -DCMAKE_C_FLAGS:STRING=-fpermissive \
           -DCMAKE_MODULE_LINKER_FLAGS:STRING=-L"${FINALDIR}/lib" \
           -DZLIB_LIBRARY:PATH="${FINALDIR}/lib/${LIBZA}"  \
           -DSZIP_LIBRARY:PATH="${FINALDIR}/lib/libsz.a"  \
           -DCMAKE_INSTALL_PREFIX="${FINALDIR}" -LAH > ${FINALDIR}/cmake-info-netcdf-c 2>&1

#          -DBUILD_SHARED_LIBS:BOOL=OFF \
#          -DBUILD_STATIC_LIBS:BOOL=ON \

#          -DHDF5_hdf5_LIBRARY_RELEASE:FILEPATH="${FINALDIR}/lib/libhdf5.a" \
#          -DHDF5_hdf5_hl_LIBRARY_RELEASE:FILEPATH="${FINALDIR}/lib/libhdf5_hl.a" \
#          -DHDF5_C_INCLUDE_DIR:PATH="${FINALDIR}/include" \
#          -DHDF5_DIR:PATH="${FINALDIR}/cmake" \

  if [ $? -ne 0 ] ; then
    echo cmake $NETCDF failed
    exit 1
  fi

  cmake --build . --clean-first --config Release #--target INSTALL
  if [ $? -ne 0 ] ; then
    echo $NETCDF build failed
    exit 1
  fi
  cmake -P cmake_install.cmake

  cd $CWD
  summary $NETCDF
fi
