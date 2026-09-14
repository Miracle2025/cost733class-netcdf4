#!/bin/sh
./configure --disable-grib FCFLAGS="-fbounds-check -fbacktrace -Wall" && make

