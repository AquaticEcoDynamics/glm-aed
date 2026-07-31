# ===========================================================================


if [ ! -f ${SQLITE}.zip ] ; then
   curl ${MINUS_K} https://www.sqlite.org/2026/${SQLITE}.zip -o ${SQLITE}.zip
   if [ $? -ne 0 ] ; then
      echo failed to fetch ${SQLITE}.tar.gz
      exit 1
   elif [ "$UNPACK" = "true" ] ; then
      unzip ${SQLITE}.zip
   fi
fi
