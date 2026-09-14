#!/bin/sh
export LANG=C
export LC_ALL=C
./configure FC=ifort CC=icc FCFLAGS="-openmp -O3 -mp -heap-arrays 1024" && make
#./configure FC=ifort CC=icc FCFLAGS="-openmp -openmp-report 2 -O3 -mp" && make
