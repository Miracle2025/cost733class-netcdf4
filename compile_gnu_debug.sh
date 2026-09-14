#!/bin/sh
#. sh path.sh
alias makeinfo="echo This is a replacement for makeinfo!"
./configure F77=gfortran FC=gfortran --disable-netcdf --disable-opengl --disable-grib FCFLAGS="-fbounds-check -fbacktrace -Wall" && make
