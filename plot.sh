#!/bin/sh

ncent=$2
if [ $# -lt 2 ] ; then
echo Usage: $0 '<file>.nc <number of centroids>'
exit
fi

HIRES=0
TITLE=centroid
TITLE=`echo $1 | sed 's|_cnt.nc||g'`
n=0
for arg in $@ ; do
n=`expr $n + 1`
case $arg in 
-hires) HIRES=1 ;;
#-title) shift 1 ; TITLE=$arg ;;
esac
done

gradsbin=`which gradsnc` || gradsbin=grads
cent=0

CBAR=0
#if [ ! -f cbarn.gs ] ; then wget -O cbarn.gs http://dss.ucar.edu/datasets/ds090.0/software/pcgrads/CBARN.GS ; fi
if [ ! -f cbarn.gs ] ; then wget -O cbarn.gs http://geo23.geo.uni-augsburg.de/download/cbarn.gs ; fi
if [ ! -f cbarn.gs ] ; then CBAR=1 ; fi

echo CBAR=$CBAR

while [ $cent -lt $ncent ] ; do
cent=`expr $cent + 1`
if [ $cent -lt 10 ] ; then cent=0$cent ; fi

echo "
 'sdfopen "${1}"'
 'set lev "${cent}"'
 'set rgb 16 100 100 255'
 'set rgb 17 130 130 255'
 'set rgb 18 160 160 255'
 'set rgb 19 190 190 255'
 'set rgb 20 220 220 255'
 'set rgb 21 255 220 220'
 'set rgb 22 255 190 190'
 'set rgb 23 255 160 160'
 'set rgb 24 255 130 130'
 'set rgb 25 255 100 100'
 'set rbcols 16 17 18 19 20 21 22 23 24 25'
 'set grid off'
 'set grads off'" > grads.plot

if [ $HIRES -eq 1 ] ; then echo "'set mpdset hires'">> grads.plot ; fi

echo "
 'set csmooth on'
 'set gxout shaded'
 'd cent' " >> grads.plot

if [ $CBAR -eq 0 ] ; then echo using cbarn.gs ; echo " 'run cbarn.gs' " >> grads.plot ; fi

echo "
 'set csmooth on'
 'set gxout contour'
 'set clab off'
 'd cent'
 'set line 1'
 'set strsiz 2.8'
 'draw title "${TITLE}" "${cent}"'
 'printim "${1}_c${cent}".png x800 y600 white '
 'quit'" >> grads.plot

 $gradsbin -blc grads.plot

done
 
