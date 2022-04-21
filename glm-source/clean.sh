#!/bin/sh

CWD=`pwd`

if [ "$FC" = "" ] ; then
  export FC=gfortran
fi
export MAKE=make
export OSTYPE=`uname -s`
if [ "$OSTYPE" = "FreeBSD" ] ; then
  export MAKE=gmake
  export FC=flang
fi

for i in water benthic riparian demo dev fv ; do
   echo clean libaed-$i
   if [ -d libaed-$i ] ; then
     cd  libaed-$i
     ${MAKE} distclean
     cd ..
   fi
done

for i in libaed2 libaed2-plus libplot libutil GLM ; do
   echo clean $i
   if [ -d $i ] ; then
     cd  $i
     ${MAKE} distclean
     cd ..
   fi
done

exit 0
