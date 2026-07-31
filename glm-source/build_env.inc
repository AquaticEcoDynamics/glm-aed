#
# Source this file in build scripts after setting FC
#

# Work out what system type we are operating on
case `uname` in
  "Darwin"|"Linux"|"FreeBSD")
    export OSTYPE=`uname -s`
    ;;
  MINGW*)
    export OSTYPE="Msys"
    ;;
esac

if [ "$OSTYPE" = "FreeBSD" ] ; then
  export MAKE=gmake
fi
if [ "$WITH_AED_PLUS" = "true" ] ; then
  # since -dev has the plotting we need libgd
  NEED_GD=true
fi

# echo building environment for `basename $0`
case "`basename $0`" in
# "build_aedlibs.sh")
#   ;;
  "build_glm.sh")
    NEED_NCDFC=true
    NEED_GD=true
    ;;
# "build_aed-fv.sh")
#   ;;
  "build_elcom.sh")
    NEED_NCDFC=true
    NEED_NCDFF=true
    ;;
  "build_zeroD.sh")
    NEED_NCDFC=true
    NEED_GD=true
    ;;
  "build_schism.sh")
    NEED_NCDFC=true
    NEED_NCDFF=true
    NEED_OMPI=true
    NEED_GD=true
    ;;
# "build_modflow6.sh")
#   ;;
# "build_swan.sh")
#   ;;
# "build_tuflow.sh")
#   ;;
# "build_delft3d.sh")
#   ;;
# "build_telemac.sh")
#   ;;
esac


#---------------
get_commit_id () {
  cid=`git log -1 | head -1 | cut -f2 -d\ `
  me=`grep -w url .git/config | head -1 | cut -f3 -d\ `
  stat=`git status -s --untracked-files=no | wc -l`
  echo "$cid from $me with $stat changes"
}
#---------------

#---------------
find_header () {
  echo "include"
}
#---------------

#---------------
find_library () {
  echo "lib"
}
#---------------


# Are we using intel fortran (no longer supported on mac)
# Currently only tuflowfv NEEDS intel fortran
if [ "$FC" = "ifort"  ] || [ "$FC" = "ifx" ] ; then
  if [ "$OSTYPE" = "Linux" ] ; then
    export start_sh="$(ps -p $$ -o command= | awk '{print $1}')" ;
    # ifort config scripts wont work with /bin/sh
    # so we restart using bash
    if [ "$start_sh" = "/bin/sh" ] ; then
      /bin/bash $0 $ARGS
      exit $?
    fi

    # different releases put setup script in different places
    if [ -x /opt/intel/setvars.sh ] ; then
      . /opt/intel/setvars.sh
    elif [ -d /opt/intel/oneapi ] ; then
      . /opt/intel/oneapi/setvars.sh
    elif [ -d /opt/intel/bin ] ; then
      . /opt/intel/bin/compilervars.sh intel64
    fi
  fi

  if [ "$OSTYPE" = "Msys" ] ; then
    if [ "$MY_PS" = "" ] ; then
      export MY_PS=$$
    fi
    if [ "$MY_PS" = "$$" ] ; then
      which ${FC} > /dev/null 2>&1
      if [ $? -ne 0 ] ; then

        cat << EOF | cmd
@echo off

@"C:\Program Files (x86)\Intel\oneAPI\setvars.bat"
@"C:\Program Files\Git\bin\bash.exe" -c "$0 $ARGS"

EOF
        echo
        exit $?
      fi
    fi
  fi

  which ${FC} > /dev/null 2>&1
  if [ $? -ne 0 ] ; then
    echo ${FC} compiler requested, but not found
    exit 1
  fi
fi

# If we're on MacOS, work out if we have MacPorts or HomeBrew
if [ "$OSTYPE" = "Darwin" ] ; then
  brew -v > /dev/null 2>&1
  if [ $? -eq 0 ] ; then
    export HOMEBREW=true
    DEFAULTPATH=/opt/homebrew
  else
    which port > /dev/null 2>&1
    if [ $? -eq 0 ] ; then
      export MACPORTS=true
      DEFAULTPATH=/opt/local
    fi
  fi
fi

# see if we have openmpi, netcdf-c, netcdf-fortran and libgd in our default path, set the
# default "home" for each

if [ "$OSTYPE" = "Msys" ] ; then
  export PATH="$PATH:`pwd`/ancillary/bin"
fi

# Do we need/have ompi
if [ "$NEED_OMPI" = "true" ] ; then
  OMPIBASE=
  BINDIR=`which ompi_info`
  if [ "$BINDIR" != "" ] ; then
    BINDIR=`dirname $BINDIR`
    if [ "$BINDIR" != "" ] ; then
      OMPIBASE=`dirname $BINDIR`
    fi
  fi
  if [ "$OMPIBASE" = "" ] ; then
    NEED_OMPI=true
#   echo no open-mpi found
  else
    NEED_OMPI=false
  fi
fi

# do we need/have netcdf-c
if [ "$NEED_NCDFC" = "true" ] ; then
  BINDIR=`which nc-config`
  if [ "$BINDIR" != "" ] ; then
    BINDIR=`dirname $BINDIR`
    if [ "$BINDIR" != "" ] ; then
      NCDFCBASE=`dirname $BINDIR`
    fi
  fi
  if [ "$NCDFCBASE" = "" ] ; then
    NEED_NCDFC=true
#   echo no netcdf found
  else
    NEED_NCDFC=false
  fi
fi
unset BINDIR

if [ "$FC" = "ifort" ] || [ "$FC" = "ifx" ] || \
   [ "$FC" = "flang" ] ; then
  if [ -d ancillary/bin ] ; then
    if [ -x ancillary/bin/nf-config ] ; then
      BINDIR="`pwd`/ancillary/bin"
    fi
  fi
fi

if [ "$BINDIR" = "" ] ; then
  BINDIR=`which nf-config`
  if [ "$BINDIR" != "" ] ; then
    BINDIR=`dirname $BINDIR`
  fi
fi

if [ "$BINDIR" != "" ] ; then
  NF_FC=`$BINDIR/nf-config --fc`
  if [ "`basename $NF_FC .exe`" = "${FC}" ] ; then
    NCDFFBASE=`dirname $BINDIR`
    export NEED_NCDFF=false
  else
    echo fortran compiler mismatch on nf-config "( $NF_FC != $FC )"
  fi
fi
unset BINDIR

# if we haven't found netcdf-fortran ...
if [ "$NEED_NCDFF" = "true" ] && [ "${NCDFFBASE}" = "" ]; then
  BASEDIR='.'
  TCWD=`pwd`
  if [ -d ancillary ] ; then
    BASEDIR=`pwd`
  else
    if [ -d ../ancillary ] ; then
      cd ..
      BASEDIR=`pwd`
    fi
  fi
  if [ -f ${CWD}/ancillary/include/netcdf.mod ] ; then
    export NEED_NCDFF=false
  fi
  export NCDFFBASE=${CWD}/ancillary
  if [ "${NCDFFBASE}" != "" ]; then
    export PATH="${NCDFFBASE}/bin:${PATH}"
  fi
  cd ${TCWD}
  unset TCWD

  if [ "${NCFCBASE}" = "" ] ; then
    NCFCBASE=${NCDFFBASE}
  fi
fi

export NETCDFHOME=${NCDFFBASE}

if [ "$NEED_GD" = "true" ] ; then
  if [ -f /usr/include/gd.h ] || [ -f ancillary/include/gd.h ] ; then
    NEED_GD=false
  fi
fi

NEEDS=
if [ "$NEED_NCDFC" = "true" ] ; then NEEDS="$NEEDS --need-ncdfc-extras --need-netcdf_c" ; fi
if [ "$NEED_NCDFF" = "true" ] ; then NEEDS="$NEEDS --need-netcdf_f" ; fi
if [ "$NEED_OMPI" = "true" ] ; then NEEDS="$NEEDS --need-openmpi" ; fi
if [ "$NEED_GD" = "true" ] ; then NEEDS="$NEEDS --need-gd" ; fi

# If any package is needed that we know about, then build it
if [ "$NEED_NCDFC" = "true" ] || [ "$NEED_NCDFF" = "true" ] || \
    [ "$NEED_OMPI" = "true" ] || [ "$NEED_GD" = "true" ] ; then

  if [ "$NEED_NCDFC" = "true" ] ; then echo "NetCDF libs not found" ; fi
  if [ "$NEED_NCDFF" = "true" ] ; then echo "NetCDF fortran libs not found" ; fi
  if [ "$NEED_OMPI" = "true" ] ; then echo "openmpi libs not found" ; fi
  if [ "$NEED_GD" = "true" ] ; then echo "gd libs not found" ; fi

  if [ "$AUTO_PREQ" = "true" ] ; then
    echo attempting to build in ancillary
    cd ancillary
    ./build.sh ${NEEDS} || exit 1
  else
    echo not auto building prerequisites
  fi

  if [ "$NEED_NCDFC" = "true" ] ; then export NCDFCBASE="${CWD}/ancillary" ; fi
  if [ "$NEED_NCDFF" = "true" ] ; then export NCDFFBASE="${CWD}/ancillary" ; fi
  if [ "$NEED_OMPI"  = "true" ] ; then export OMPIBASE="${CWD}/ancillary" ; fi
fi

export INCLUDES="$INCLUDES -I${CWD}/ancillary/include"
export LDFLAGS="$LDFLAGS -L${CWD}/ancillary/lib"

echo basic info :
echo    NCDFCBASE=$NCDFCBASE
echo    NCDFFBASE=$NCDFFBASE
echo    OMPIBASE=$OMPIBASE

