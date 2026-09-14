#!/bin/sh
./configure FC=gfortran FCFLAGS="-fopenmp -O3 -fbounds-check -fbacktrace -Wall" --disable-opengl --disable-grib
make
