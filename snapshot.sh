#!/bin/bash

dir=`pwd` 
dir=`basename ${dir}` 

make clean
make distclean
rm src/*.mod

echo 'All changes commited? Fetching update from SVN-server?'
read a

svn update
#version=`svn update --quiet | awk '{print $2}' | sed 's|\.||g'`
#version=`svn update --quiet`

version=`svn info | grep -i evision | awk '{print $2}' | sed 's|\.||g'`
echo version=$version
#exit

if [ $version -lt 10 ] ; then version=0${version} ; fi
dir="${dir}_RC_revision${version}"
echo $dir 

#autoreconf --install

cd ..
if [ -f ${dir}.tar ] ; then rm ${dir}.tar ; fi
if [ -f ${dir}.tar.bz2 ] ; then rm ${dir}.tar.bz2 ; fi

svn export cost733class-1.2 cost733class-1.2_RC_revision${version}

tar -c -v  \
--exclude=*.mod --exclude=*~ --exclude=*.clam \
--exclude=\#* --exclude=*.cla --exclude=test/out* \
--exclude=*.nc --exclude=*.svn --exclude=zug* \
-f ${dir}.tar ${dir}

echo bzip2 -9 ${dir}.tar ...

bzip2 -9 ${dir}.tar

echo send to cost733class server?
read a
scp ${dir}.tar.bz2 cost733class-1.2/doc/cost733class_userguide.pdf \
root@schmutter.geo.uni-augsburg.de:/iguafs/wwws/schmutter/cost733/download/cost733class-1.2/

cd -

