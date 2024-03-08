#!/bin/sh

CWD=`pwd`

if [ ! -d ../msys ] ; then
  mkdir ../msys
fi
cd ../msys
export FINALDIR=`pwd`
cd "$CWD"

. ./versions.inc

if [ ! -f "$FINALDIR/lib/libzlibstatic.a" ] ; then
  export ZLIB="zlib-$ZLIBV"
fi

export FREETYPE2=freetype-${FRREETYPE2V}
export JPEG=jpegsrc.v${JPEGV}
export LIBPNG=libpng-${LIBPNGV}
export LIBGD=lib${GD}

#---------------

export CFLAGS="-I${FINALDIR}/include"
export CPPFLAGS="-I${FINALDIR}/include"
export LDFLAGS="-L${FINALDIR}/lib"

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

if [ "$JPEG" != "" ] ; then
  \rm -rf jpeg-$JPEGV
  tar xzf $JPEG.tar.gz
  cd jpeg-$JPEGV

  cp jconfig.vc jconfig.h

  sed -e 's/\<cc\>/gcc/' < makefile.ansi > Makefile
  make
  if [ $? != 0 ] ; then
    echo $JPEG build failed
    exit 1
  fi
  cp jpeglib.h jerror.h jconfig.h jmorecfg.h ${FINALDIR}/include
  cp libjpeg.a ${FINALDIR}/lib/

  cd $CWD

  summary $JPEG
fi

#---------------

if [ "$LIBPNG" != "" ] ; then
  \rm -rf $LIBPNG
  tar xzf $LIBPNG.tar.gz
  cd $LIBPNG
  mkdir build
  cd build

  cmake .. -G "MinGW Makefiles" \
           -DCMAKE_FIND_ROOT_PATH="$FINALDIR" \
           -DCMAKE_BUILD_TYPE:STRING=Release \
           -DBUILD_SHARED_LIBS:BOOL=OFF \
           -DBUILD_STATIC_LIBS:BOOL=ON \
           -DZLIB_LIBRARY_RELEASE:FILEPATH="$FINALDIR/lib/libzlibstatic.a" \
           -DCMAKE_INSTALL_PREFIX="$FINALDIR" -LAH >& ../../cmake-info-libpng
  if [ $? != 0 ] ; then
    echo cmake $LIBPNG failed
    exit 1
  fi

  cmake --build . --clean-first --config Release #--target INSTALL
  if [ $? != 0 ] ; then
    echo $LIBPNG build failed
    exit 1
  fi
  cmake -P cmake_install.cmake
# /bin/rm $FINALDIR/lib/libpng16.dll.a
# /bin/rm $FINALDIR/lib/libpng.dll.a

  cd $CWD

  summary $LIBPNG
fi

#---------------

if [ "$FREETYPE2" != "" ] ; then
  \rm -rf $FREETYPE2
  tar xzf $FREETYPE2.tar.gz
  cd $FREETYPE2
  mkdir build
  cd build

  cmake .. -G "MinGW Makefiles" \
           -DCMAKE_FIND_ROOT_PATH="$FINALDIR" \
           -DCMAKE_BUILD_TYPE:STRING=Release \
           -DBUILD_SHARED_LIBS:BOOL=OFF \
           -DBUILD_STATIC_LIBS:BOOL=ON \
           -DZLIB_LIBRARY_RELEASE:FILEPATH="$FINALDIR/lib/libzlibstatic.a" \
           -DPNG_LIBRARY_RELEASE:FILEPATH="$FINALDIR/lib/libpng.a" \
           -DCMAKE_INSTALL_PREFIX="$FINALDIR" -LAH >& ../../cmake-info-libfreetype
  if [ $? != 0 ] ; then
    echo cmake $FREETYPE2 failed
    exit 1
  fi

  cmake --build . --clean-first --config Release #--target INSTALL
  if [ $? != 0 ] ; then
    echo $FREETYPE2 build failed
    exit 1
  fi
  cmake -P cmake_install.cmake

  cd $CWD

  summary $FREETYPE2
fi

#---------------

if [ "$LIBGD" != "" ] ; then
  \rm -rf $LIBGD
  tar xzf $LIBGD.tar.gz
  cd $LIBGD

#  export alt="yes"

#if [ "$alt" != "yes" ] ; then
  mkdir build
  cd build

  cmake .. -G "MinGW Makefiles" \
           -DCMAKE_FIND_ROOT_PATH="$FINALDIR" \
           -DCMAKE_BUILD_TYPE:STRING=Release \
           -DENABLE_JPEG:BOOL=ON \
           -DENABLE_PNG:BOOL=ON  \
           -DENABLE_FREETYPE:BOOL=ON \
           -DVERBOSE_MAKEFILE:BOOL=TRUE \
           -DZLIB_LIBRARY_RELEASE:FILEPATH="$FINALDIR/lib/libzlibstatic.a" \
           -DPNG_LIBRARY_RELEASE:FILEPATH="$FINALDIR/lib/libpng.a" \
           -DCMAKE_INSTALL_PREFIX="$FINALDIR" -LAH >& ../../cmake-info-libgd
  if [ $? != 0 ] ; then
    echo cmake $LIBGD failed
    exit 1
  fi

#          -DBUILD_SHARED_LIBS:BOOL=OFF \
#          -DBUILD_STATIC_LIBS:BOOL=ON \

  cmake --build . --clean-first --config Release #--target INSTALL
  if [ $? != 0 ] ; then
    echo $LIBGD build failed
    exit 1
  fi
  cmake -P cmake_install.cmake
#else
#
## From :
##
## https://github.com/libgd/libgd/issues/826
##
#  patch -p0 < ../libgd.patch
#
#  export CFLAGS="-I${FINALDIR}/include"
#  export CPPFLAGS="-I${FINALDIR}/include"
#  export LDFLAGS="-L${FINALDIR}/lib"
#
## build libgd
## libgd depends on jpeg, png and freetype
#
#   ./configure --prefix=${FINALDIR} --enable-shared=no --with-zlib=${FINALDIR} --with-png=${FINALDIR} --with-freetype=${FINALDIR} --with-jpeg=${FINALDIR}
#
#   if [ $? = 0 ] ; then
#      for j in `find . -name Makefile` ; do
#         sed -e 's/\<SHELL\>/XSHELL/' < $j > Makefile-x
#         mv Makefile-x $j
#      done
#      make
#      if [ $? = 0 ] ; then
#         make install
#      else
#         echo '****' build failed for $LIBGD
#         exit 1
#      fi
#   else
#      echo '****' config failed for $LIBGD
#      exit 1
#   fi
#   cd ..
#   echo '****************' done building in $LIBGD
#fi

  cd $CWD

  summary $LIBGD
fi

#---------------

exit 0
