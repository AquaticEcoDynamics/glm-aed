#!/bin/bash

SQUEEKY=false

while [ $# -gt 0 ] ; do
  case $1 in
    --debug)
      export DEBUG=true
      ;;
    --squeeky)
      export SQUEEKY=true
      ;;
    *)
      echo "unknown option \"$1\""
      ;;
  esac
  shift
done

if [ "$SQUEEKY" = "true" ] ; then
  /bin/rm -rf include bin lib sbin share etc cmake*

  cd sources
  ./clean_all.sh --squeeky
else
  cd sources
  ./clean_all.sh
fi

exit 0
