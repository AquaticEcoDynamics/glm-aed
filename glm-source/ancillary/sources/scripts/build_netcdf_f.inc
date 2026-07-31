# ===========================================================================

if [ "${OSTYPE}" = "Darwin" ] ; then
  export INC="/opt/homebrew/include"
else
  export INC="/usr/include"
fi

# It seems schisms cmake setup cant find libnetcdff if it is a static lib

#----------------------------------------------------------------

if [ ! -f "${FINALDIR}/lib/libnetcdff.a" ] && \
   [ ! -f "${FINALDIR}/lib/libnetcdff.so" ] && \
   [ ! -f "${FINALDIR}/lib/libnetcdff.dylib" ] ; then
# netcdff depends on netcdf
  echo "====== building $NETCDFF"

  export PATH="${FINALDIR}/bin:$PATH"
  /bin/rm -rf $NETCDFF
  tar -xzf $NETCDFF.tar.gz
  if [ ! -d $NETCDFF ] ; then
    echo cant unpack $NETCDFF.tar.gz
    exit 1
  fi
  cd $NETCDFF
  SRCDIR=`pwd`
  mkdir build
  cd build

  cmake .. -G "Unix Makefiles" \
           -DCMAKE_FIND_ROOT_PATH=${FINALDIR} \
           -DCMAKE_BUILD_TYPE:STRING=Release \
           -DCMAKE_C_FLAGS=-fpermissive \
           -DBUILD_SHARED_LIBS:BOOL=ON  \
           -DENABLE_TESTS=OFF \
           -DBUILD_TESTING:BOOL=OFF \
           -DBUILD_UTILITIES:BOOL=OFF \
           -DBUILD_EXAMPLES:BOOL=OFF \
           -DNETCDF_C_INCLUDE_DIR="${INC}" \
           -DNETCDF_C_LIBRARY="${FINALDIR}/lib/libnetcdf.so" \
           -DCMAKE_INSTALL_PREFIX="${FINALDIR}" -LAH > ${FINALDIR}/cmake-info-netcdf-f 2>&1

#          -DBUILD_SHARED_LIBS:BOOL=OFF  \
#          -DBUILD_STATIC_LIBS:BOOL=ON \

  if [ $? -ne 0 ] ; then
    echo $NETCDFF cmake failed
    which cmake > /dev/null 2>&1
    if [ $? -ne 0 ] ; then echo cmake not installed? ; fi
    exit 1
  fi

  cmake --build . --clean-first --config Release #--target INSTALL
  if [ $? -ne 0 ] ; then
    echo $NETCDFF build failed
    exit 1
  fi
  cmake -P cmake_install.cmake
  if [ $? -ne 0 ] ; then
     echo $NETCDFF install failed
    exit 1
  fi

  echo '!     NetCDF-3.' > ${FINALDIR}/include/netcdf.inc
  cat ${SRCDIR}/fortran/netcdf3.inc >> ${FINALDIR}/include/netcdf.inc
  echo >> ${FINALDIR}/include/netcdf.inc
  echo '!     NetCDF-4.' >> ${FINALDIR}/include/netcdf.inc
  cat ${SRCDIR}/fortran/netcdf4.inc >> ${FINALDIR}/include/netcdf.inc
  echo >> ${FINALDIR}/include/netcdf.inc
  echo '!     NetCDF-2.' >> ${FINALDIR}/include/netcdf.inc
  cat ${SRCDIR}/fortran/netcdf2.inc >> ${FINALDIR}/include/netcdf.inc
  echo >> ${FINALDIR}/include/netcdf.inc
  echo >> ${FINALDIR}/include/netcdf.inc
  echo '!     This is to turn on netCDF internal logging.' >> ${FINALDIR}/include/netcdf.inc
  echo '      integer nf_set_log_level' >> ${FINALDIR}/include/netcdf.inc
  echo '      external nf_set_log_level' >> ${FINALDIR}/include/netcdf.inc

  cd $CWD

  summary $NETCDFF
fi
