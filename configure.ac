#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ(2.61)
AC_INIT([wiiload],[0.5.1],[https://github.com/devkitPro/wiiload/issues])
AC_CONFIG_SRCDIR([source/main.c])

AM_INIT_AUTOMAKE([subdir-objects])

AC_CANONICAL_BUILD
AC_CANONICAL_HOST

AC_PROG_CC

AC_CHECK_LIB([z], [gzread], , 
    [AC_MSG_ERROR([zlib not found, see http://www.zlib.net])]) 

case "$host" in
	*-mingw32*)
		WIN_SYS_LIBS=-lws2_32
	;;
esac
AC_SUBST(WIN_SYS_LIBS)
AC_CONFIG_FILES([Makefile])
AC_OUTPUT
