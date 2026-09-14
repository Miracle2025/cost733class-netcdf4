AC_PREREQ([2.67])
AC_INIT([cost733class], [1.4], [a.philipp@geo.uni-augsburg.de])
AM_INIT_AUTOMAKE([foreign])

AC_PROG_RANLIB([AC_CHECK_PROG(RANLIB, ranlib, ranlib, :)])
AC_PROG_CC([gcc icc])
AC_LANG_C
AC_PROG_FC([gfortran ifort])
AC_PROG_F77([gfortran ifort])

dnl ---- netCDF (system library, replaces the vendored netcdf-4.0.1) ----
AC_ARG_ENABLE([netcdf],
  [AS_HELP_STRING([--disable-netcdf  Do not use netcdf functions])],
  [netcdf=x$enableval],
  [netcdf=xyes])

if test $netcdf = xyes; then
  AC_CHECK_PROG([NFCONFIG], [nf-config], [nf-config], [no])
  if test x$NFCONFIG = xno; then
    AC_MSG_ERROR([nf-config not found -- install the system netCDF-Fortran
development package (libnetcdff-dev on Debian/Ubuntu,
netcdf-fortran-devel on Fedora) or configure with --disable-netcdf.])
  fi
  NETCDF_FFLAGS=`$NFCONFIG --fflags`
  NETCDF_LIBS=`$NFCONFIG --flibs`
fi
AC_SUBST([NETCDF_FFLAGS])
AC_SUBST([NETCDF_LIBS])
AM_CONDITIONAL([NETCDF], test $netcdf = xyes)

dnl ---- GRIB and OpenGL were dropped in this fork -----------------------
dnl The vendored grib_api-1.9.18 and f03gl trees are no longer shipped.
dnl Keep the flags only to fail with a clear message instead of a
dnl configure/build error deep inside missing directories.
AC_ARG_ENABLE([grib],
  [AS_HELP_STRING([--enable-grib  (removed in this fork -- flag kept for a clear error)])],
  [AC_MSG_ERROR([--enable-grib: GRIB input is not available in this fork; the vendored grib_api tree was removed.])],
  [])
AC_ARG_ENABLE([opengl],
  [AS_HELP_STRING([--enable-opengl  (removed in this fork -- flag kept for a clear error)])],
  [AC_MSG_ERROR([--enable-opengl: the OpenGL viewer is not available in this fork; the vendored f03gl tree was removed.])],
  [])

AC_CONFIG_FILES([Makefile src/Makefile])
AC_OUTPUT

AC_MSG_NOTICE([

  Fine! Configuration completed.

    Say 'make' to compile the cost733 package,
    if everything goes fine the executable is in
           src/cost733class
    then. Please help to improve this package at:
    http://geo23.geo.uni-augsburg.de/cost733class-1.2
          ])
