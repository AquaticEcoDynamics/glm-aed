# ===========================================================================

if [ ! -f "${FINALDIR}/lib/${LIBZA}" ] ; then
  echo "====== building $ZLIB"

  \rm -rf $ZLIB
  tar xzf $ZLIB.tar.gz
  if [ ! -d $ZLIB ] ; then
    echo cant unpack $ZLIB.tar.gz
    exit 1
  fi
  cd $ZLIB
  mkdir build
  cd build

  cmake .. -G "Unix Makefiles" \
           -DCMAKE_FIND_ROOT_PATH="${FINALDIR}" \
           -DZLIB_BUILD_SHARED:BOOL=OFF \
           -DZLIB_BUILD_STATIC:BOOL=ON \
           -DZLIB_BUILD_EXAMPLES:BOOL=OFF \
           -DCMAKE_BUILD_TYPE:STRING=Release \
           -DCMAKE_INSTALL_PREFIX="${FINALDIR}" -LAH > ${FINALDIR}/cmake-info-zlib 2>&1
  if [ $? -ne 0 ] ; then
    echo cmake $ZLIB failed
    exit 1
  fi

  cmake --build . --clean-first --config Release #--target INSTALL
  if [ $? -ne 0 ] ; then
    echo $ZLIB build failed
    exit 1
  fi
  cmake -P cmake_install.cmake

# ln -s $FINALDIR/lib/libz.a $FINALDIR/lib/libzlibstatic.a

  cd $CWD

  summary $ZLIB
fi
#---------------
