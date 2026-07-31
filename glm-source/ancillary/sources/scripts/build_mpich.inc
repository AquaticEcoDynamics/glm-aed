# ===========================================================================

echo "====== building $MPICH"

if [ ! -f "${FINALDIR}/lib/libmpi.a" ] && \
   [ ! -f "${FINALDIR}/lib/libmpi.so" ] && \
   [ ! -f "${FINALDIR}/lib/libmpi.dylib" ] ; then

  \rm -rf $MPICH
  tar xzf $MPICH.tar.gz
  if [ ! -d $MPICH ] ; then
    echo cant unpack $MPICH.tar.gz
    exit 1
  fi
  cd $MPICH

  if [ "$OSNAME" = "Darwin" ] ; then
    # on macos we'll need --with-libevent=/opt/homebrew
    EXTRA_CONF="--with-libevent=/opt/homebrew"
  else
    EXTRA_CONF=""
  fi

  ./configure --prefix=${FINALDIR} --enable-shared=no ${EXTRA_CONF}
  if [ $? -eq 0 ] ; then
    make
    if [ $? -eq 0 ] ; then
      make install
    else
      echo '****' build failed for $MPICH
      exit 1
    fi
  else
    echo '****' config failed for $MPICH
    exit 1
  fi
  cd ..
  echo '****************' done building in $MPICH

  cd $CWD
  summary $MPICH

fi
