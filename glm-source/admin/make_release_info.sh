#!/bin/bash

export OUTFILE="ReleaseInfo.txt"
export MAINLIST="GLM libplot libutil libaed-water libaed-benthic libaed-demo libaed2"
export PLUSLIST="libaed-riparian libaed-dev libaed2-plus"
export PATH="../.git/modules/glm-source/GLM"

ls $PATH

extract_vers () {
# export RPO=`cat .git/config | grep -w url | rev | cut -d'/' -f 1 | rev`
# mingw doesnt have rev, so do it this way.
  export RPO=`cat ${PATH}/config | grep -w url | tr '/' '\n' | tail -1`
  export VRS=`cat ${PATH}/HEAD | cut -c -7`
  echo "$VRS $RPO"
}

do_list () {
  for src in $* ; do
    if [ -d $src ] ; then
      cd $src
        extract_vers
      cd ..
    fi
  done
}

do_it () {
  echo PATH=$PATH
  export PATH=$PATH:/usr/bin:/bin
  echo 0
  ls ../
  echo 1
  ls ../.git
  echo 2
  ls ../.git/modules
  echo 3
  ls ../.git/modules/glm-source
  echo 4
  ls ../.git/modules/glm-source/GLM
  echo config
  cat "${PATH}/config"
  echo head
  cat "${PATH}/HEAD"
  echo "This build is produced from the following git points :"
  echo
  extract_vers
  do_list ${MAINLIST}

  # For the PLUS versions :
  echo
  echo "The plus version also has :"
  echo
  do_list ${PLUSLIST}
}

do_it #> ${OUTFILE}

exit 0
