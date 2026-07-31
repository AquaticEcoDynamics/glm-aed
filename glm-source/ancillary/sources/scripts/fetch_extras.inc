# ===========================================================================

if [ ! -f ${ZLIB}.tar.gz ] ; then
   . ./scripts/fetch_zlib.inc
fi

if [ ! -f ${CURL}.tar.gz ] ; then
   echo fetching ${CURL}.tar.gz
   curl ${MINUS_K} -L https://curl.haxx.se/download/${CURL}.tar.gz -o ${CURL}.tar.gz
   if [ $? -ne 0 ] ; then
      echo failed to fetch ${CURL}.tar.gz
      exit 1
   elif [ "$UNPACK" = "true" ] ; then
      tar xzf ${CURL}.tar.gz
   fi
fi

if [ ! -f  ${LIBAEC}.tar.gz ] ; then
   echo fetching ${LIBAEC}.tar.gz
   echo curl ${MINUS_K} -LJO https://github.com/Deutsches-Klimarechenzentrum/libaec/releases/download/v${LIBAECV}/${LIBAEC}.tar.gz
   curl ${MINUS_K} -LJO https://github.com/Deutsches-Klimarechenzentrum/libaec/releases/download/v${LIBAECV}/${LIBAEC}.tar.gz
   if [ $? -ne 0 ] ; then
      echo failed to fetch ${LIBAEC}.tar.gz
      exit 1
   elif [ "$UNPACK" = "true" ] ; then
      tar xzf ${LIBAEC}.tar.gz
   fi
fi

if [ ! -f ${HDF5}.tar.gz ] ; then
   HVER=`echo ${HDF5V} | cut -f1 -d\.`
   HMAJ=`echo ${HDF5V} | cut -f2 -d\.`
   HMIN=`echo ${HDF5V} | cut -f3 -d\.`
   HDFDV="HDF5_${HVER}_${HMAJ}_${HMIN}"
   if [ "${HVER}_${HMAJ}" = "2_1" ] ; then
      HDF5URL="https://support.hdfgroup.org/releases/hdf5/${HVER}.${HMAJ}.${HMIN}/downloads/${HDF5}.tar.gz"
   else
      HDF5URL="https://support.hdfgroup.org/releases/hdf5/v${HVER}_${HMAJ}/v${HVER}_${HMAJ}_${HMIN}/downloads/${HDF5}.tar.gz"
   fi
   echo fetching ${HDF5}.tar.gz from \"${HDF5URL}\"
   curl ${MINUS_K}  -L ${HDF5URL} -o ${HDF5}.tar.gz
   if [ $? -ne 0 ] ; then
      echo failed to fetch ${HDF5}.tar.gz
      exit 1
   elif [ "$UNPACK" = "true" ] ; then
      tar xzf ${HDF5}.tar.gz
   fi
fi
