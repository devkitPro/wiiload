#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ(2.61)
AC_INIT([wiiload],[0.5.1],[davem@devkitpro.org])
AC_CONFIG_SRCDIR([source/main.c])

AM_INIT_AUTOMAKE([1.10])

AC_CANONICAL_BUILD
AC_CANONICAL_HOST

AC_PROG_CC

AC_CHECK_LIB([z], [gzread], , 
    [AC_MSG_ERROR([zlib not found, see http://www.zlib.net])]) 

AC_CONFIG_FILES([Makefile])
AC_OUTPUT
