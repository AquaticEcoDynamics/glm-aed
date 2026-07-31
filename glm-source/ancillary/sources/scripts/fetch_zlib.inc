# ===========================================================================

if [ ! -f ${ZLIB}.tar.gz ] ; then
   echo fetching ${ZLIB}.tar.gz
 # curl ${MINUS_K} http://www.zlib.net/${ZLIB}.tar.gz -o ${ZLIB}.tar.gz
   curl ${MINUS_K} -LJO https://github.com/madler/zlib/archive/refs/tags/v${ZLIBV}.tar.gz
   if [ $? -ne 0 ] ; then
      echo failed to fetch ${ZLIB}.tar.gz
      if [ -f ${ZLIB}.tar.gz ] ; then
         /bin/rm ${ZLIB}.tar.gz
      fi
      exit 1
   fi
   if [ "$UNPACK" = "true" ] ; then
      tar -xzf ${ZLIB}.tar.gz
   fi
fi
#-------------------
