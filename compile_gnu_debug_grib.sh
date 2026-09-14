#!/bin/sh
./configure --disable-opengl --disable-jpeg FCFLAGS="-fbounds-check -fbacktrace -Wall" && make
