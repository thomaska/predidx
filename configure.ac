#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.
#
# 1. run 'aclocal'
# 2. run 'autoheader'
# 3. run 'autoconf'
# 4. run './configure'  (optionally with parameters)
# 5. run 'make swi'
#
# subsequently: 'autoreconf -vfi'

AC_PREREQ([2.69])
AC_INIT(predidx, 1.0.0)

AC_CONFIG_AUX_DIR([config])
#AC_CONFIG_SRCDIR([test/test.cpp])
AC_CONFIG_HEADERS([src/config.h])

# preset definitions
if test -z "$CFLAGS"; then
  CFLAGS="-g -O2 -fPIC -Wall"
fi

if test -z "$CXXFLAGS"; then
  CXXFLAGS="-g -O2 -std=c++17 -fPIC -Wall"
fi

ARCH=$(uname -s)

# Checks for programs.
AC_PROG_CXX
AC_PROG_CC
AC_PROG_INSTALL
AC_PROG_RANLIB

# Checks for libraries.
AC_SUBST(ARCH)
AC_SUBST(SWI_CFLAGS)
AC_SUBST(SWI_LIBS)
AC_SUBST(SWI_BASE)
AC_SUBST(SWI_ARCH)
AC_SUBST(SWI_SOLIBDIR)
AC_SUBST(SWI_PLLIBDIR)
AC_SUBST(GI_CFLAGS)
AC_SUBST(GI_LIBS)
AC_SUBST(GI_DATADIR)
AC_SUBST(SOTARGET)
AC_SUBST(PLTARGET)

if [[ $ARCH = "Linux" ]]; then
PKG_PROG_PKG_CONFIG()
PKG_CHECK_MODULES([SWI], [swipl])

SWI_BASE=$($PKG_CONFIG --variable=PLBASE swipl)
SWI_ARCH=$($PKG_CONFIG --variable=PLARCH swipl)
SWI_SOLIBDIR=$SWI_BASE/lib/$SWI_ARCH
SWI_PLLIBDIR=$SWI_BASE/library
fi

if [[ $ARCH = "Darwin" ]]; then
  if test -d /usr/local/opt/swi-prolog; then
    MACHINE=$(uname -m)
    SWI_BASE=/usr/local/opt/swi-prolog
    SWI_CFLAGS="-I${SWI_BASE}/libexec/lib/swipl/include"
    SWI_LIBS="-L${SWI_BASE}/libexec/lib/swipl/lib/${MACHINE}-darwin -lswipl"
  else
    AC_MSG_FAILURE([cannot find SWI Prolog])
  fi
fi

# Checks for header files.
AC_CHECK_HEADERS([stdint.h])

# Checks for typedefs, structures, and compiler characteristics.
AC_TYPE_INT32_T
AC_TYPE_INT64_T
AC_TYPE_SIZE_T
AC_TYPE_UINT32_T
AC_TYPE_UINT64_T
AC_CHECK_SIZEOF(long)

# Checks for library functions.
AC_FUNC_MALLOC
AC_FUNC_REALLOC
AC_CHECK_FUNCS([strdup])

AC_CONFIG_FILES([Makefile])

AC_OUTPUT

