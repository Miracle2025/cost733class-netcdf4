#!/bin/sh
./configure --disable-jpeg FCFLAGS="-fbounds-check -fbacktrace -Wall" && make
