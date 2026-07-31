# ===========================================================================

SQLITE="sqlite-src-$SQLTV"

#---------------

if [ "$SQLITE" != "" ] ; then
  echo "====== building $SQLITE"

  \rm -rf $SQLITE
  unzip $SQLITE.zip
  if [ ! -d $SQLITE ] ; then
    echo cant unpack $SQLITE.zip
    exit 1
  fi
  cd $SQLITE

  ./configure --prefix=${FINALDIR}
  sed -i -e 's!INSTALL = C:/Program Files/Git/usr/bin/install!INSTALL = "C:/Program Files/Git/usr/bin/install"!' Makefile
  make install
  cd $CWD

  summary $SQLITE
fi
#---------------
