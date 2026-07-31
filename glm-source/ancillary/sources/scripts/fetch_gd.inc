# ===========================================================================


if [ ! -f ${ZLIB}.tar.gz ] ; then
   . ./scripts/fetch_zlib.inc
fi

if [ ! -f ${FREETYPE2}.tar.gz ] ; then
   echo fetching ${FREETYPE2}.tar.gz
   echo "curl ${MINUS_K} -L https://download.savannah.gnu.org/releases/freetype/${FREETYPE2}.tar.gz -o ${FREETYPE2}.tar.gz"
   curl ${MINUS_K} -L https://download.savannah.gnu.org/releases/freetype/${FREETYPE2}.tar.gz -o ${FREETYPE2}.tar.gz
   if [ $? -ne 0 ] ; then
      echo failed to fetch ${FREETYPE2}.tar.gz
      exit 1
   elif [ "$UNPACK" = "true" ] ; then
      tar -xzf ${FREETYPE2}.tar.gz
   fi
fi

if [ ! -f ${JPEG}.tar.gz ] ; then
   echo fetching ${JPEG}.tar.gz
   curl ${MINUS_K} http://www.ijg.org/files/${JPEG}.tar.gz -o ${JPEG}.tar.gz
   if [ $? -ne 0 ] ; then
      echo failed to fetch ${JPEG}.tar.gz
      exit 1
   elif [ "$UNPACK" = "true" ] ; then
      tar -xzf ${JPEG}.tar.gz
   fi
fi

if [ ! -f ${LIBPNG}.tar.gz ] ; then
   echo fetching ${LIBPNG}.tar.gz
   curl ${MINUS_K} -L http://prdownloads.sourceforge.net/libpng/${LIBPNG}.tar.gz -o ${LIBPNG}.tar.gz
   if [ $? -ne 0 ] ; then
      echo failed to fetch ${LIBPNG}.tar.gz
      exit 1
   elif [ "$UNPACK" = "true" ] ; then
      tar xzf ${LIBPNG}.tar.gz
   fi
fi

if [ ! -f ${LIBGD}.tar.gz ] ; then
   echo fetching ${LIBGD}.tar.gz
   curl ${MINUS_K} -L https://github.com/libgd/libgd/releases/download/${GD}/${LIBGD}.tar.gz -o ${LIBGD}.tar.gz
   if [ $? -ne 0 ] ; then
      echo failed to fetch ${LIBGD}.tar.gz
      exit 1
   elif [ "$UNPACK" = "true" ] ; then
      tar xzf ${LIBGD}.tar.gz
   fi
fi
