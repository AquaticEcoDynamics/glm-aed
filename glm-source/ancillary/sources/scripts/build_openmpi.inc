# ===========================================================================


if [ ! -f "${FINALDIR}/lib/libmpi.a" ] && \
   [ ! -f "${FINALDIR}/lib/libmpi.so" ] && \
   [ ! -f "${FINALDIR}/lib/libmpi.dylib" ] ; then
  echo "====== building $OMPI"

  \rm -rf $OMPI
  tar xzf $OMPI.tar.gz
  if [ ! -d $OMPI ] ; then
    echo error extracting $OMPI
    exit 1
  fi

  cd $OMPI

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
      echo '****' build failed for $OMPI
      exit 1
    fi
  else
    echo '****' config failed for $OMPI
    exit 1
  fi
  cd ..
  echo '****************' done building in $OMPI

  cd $CWD
  summary $OMPI
fi
