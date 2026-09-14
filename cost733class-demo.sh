#!/bin/sh

cost733class \
-per 2000:1:1:12,2008:12:31:12,3d \
-opengl -glrotangle 0.25 \
-dat  pth:/usr/local/cost733class-1.2/slp.dat  lon:-10:30:2.5  lat:35:60:2.5 fdt:2000:1:1:12 ldt:2008:12:31:12 ddt:1d  \
${*}

exit
