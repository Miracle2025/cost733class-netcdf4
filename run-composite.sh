#!/bin/sh
export GRIB_DEFINITION_PATH=`pwd`"/grib_api-1.9.18/definitions/"


if [ ! -f produkt_klima_Tageswerte_19470101_20131231_00232.txt ] ; then 
wget -O produkt_klima_Tageswerte_19470101_20131231_00232.txt \
'http://src.geo.uni-augsburg.de/iguawiki/KursmaterialSS17_NumMeth?action=AttachFile&do=get&target=produkt_klima_Tageswerte_19470101_20131231_00232.txt'
fi
if [ ! -f dwd2tab.f90 ] ; then
wget -O dwd2tab.f90 \
'http://src.geo.uni-augsburg.de/iguawiki/KursmaterialSS17_NumMeth?action=AttachFile&do=get&target=dwd2tab.f90'
fi
gfortran -o dwd2tab dwd2tab.f90
./dwd2tab produkt_klima_Tageswerte_19470101_20131231_00232.txt

# Klassifizieren der Temperaturdaten in 2 Klassen (bins)
src/cost733class \
-per 2000:1:1:12,2008:12:31:12,3d \
-mon 1,2,12 \
-dat  pth:produkt_klima_Tageswerte_19470101_20131231_00232.temp.dat dtc:4 ddt:1d \
-met bin -ncl 2 \
-opengl -glrotangle 0.25

# Erstellen der Druckmittelwertskarten (Zentroide) fuer die zwei Klassen (aus int02.cla)
src/cost733class \
-per 2000:1:1:12,2008:12:31:12,3d \
-mon 1,2,12 \
-dat  pth:slp.dat  lon:-10:30:2.5  lat:35:60:2.5 fdt:2000:1:1:12 ldt:2008:12:31:12 ddt:1d  cnt:cnt02.gs \
-clain pth:int02.cla dtc:4 -met cnt \
-opengl -glrotangle 0.25
