#!/bin/sh

export GRIB_DEFINITION_PATH=`pwd`"/grib_api-1.9.18/definitions/"

src/cost733class \
-per 2000:1:1:12,2008:12:31:12,3d \
-opengl -glrotangle 0.25 \
-dat  dat:slp.dat  lon:-10:30:2.5  lat:35:60:2.5 fdt:2000:1:1:12 ldt:2008:12:31:12 ddt:1d  \
${*}

exit
