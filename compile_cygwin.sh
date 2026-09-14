cd src
gfortran.exe -c globvar.f90
ls globvar*
gfortran.exe -c opengl_dummy.f90
ls opengl*
gfortran.exe -o cost733class.exe \
aggregate.f90 arguments.f90 assign.f90 binclass.f90 \
centoutput.f90 centroids.f90 ckmeans.f90 clasinput.f90 clasoutput.f90 \
coef4pcaproj.f90 correlate.f90 cpart.f90 datainput.f90 days4mon.f90 \
dataviewinit.f90 dist_ratio.f90 distancevect.f90 distfunc.f90 \
dkmeans.f90 drat.f90 \
ecv.f90 erpicum.f90 ev_pf.f90 finish.f90 fsil.f90 gaussfilter.f90 \
geofunctions.f90 globvar.f90 hcluster.f90 jenkcoll.f90 kirchhofer.f90 \
kmeans.f90 kmedoids.f90 kruiz.f90 list4dates.f90 listcount.f90 lit.f90 \
lund.f90 main.f90 mixturemodel.f90 netcdfcheck-dummy.f90 \
netcdfinput-dummy.f90 newseed.f90 nobs4dates.f90 numday.f90 \
opengl_dummy.f90 ops.f90 pca.f90 pcaxtr.f90 percentile.f90 \
prognosis.f90 prototype.f90 randindex.f90 randomclass.f90 \
randommedoid.f90 sandra.f90 scan_matfile.f90 selectgrid.f90 sil.f90 \
som.f90 sort.f90 sortcla.f90 subfunctions.f90 substitute.f90 \
tmodpca.f90 tmodpcat.f90 wlk.f90 writenetcdf-dummy.f90 wsd_cim.f90
cd ..
