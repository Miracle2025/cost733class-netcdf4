# Upstream defects fixed in this fork

All findings were reproduced empirically before fixing (see
[VALIDATION.md](VALIDATION.md) for the test evidence). Line numbers refer to
the upstream 1.4 sources as imported in the baseline commit.

## Build system

**B0. Stale generated build files.** Upstream edited `configure.ac` and the
`Makefile.am` files (adding NETCDF/GRIB/OPENGL conditionals) but shipped
`configure`/`Makefile.in` generated *before* those edits: the shipped
`configure` has no `--disable-netcdf` and the Makefiles build/link the
vendored netcdf unconditionally. This fork regenerates everything with
`autoreconf` and drops the vendored third-party trees.

**B1. Vendored netcdf-4.0.1 (2008) built without netCDF-4.** Only netCDF-3
classic files can be read; every modern NETCDF4/HDF5 file fails with
`ERROR: netcdf:NetCDF: Unknown file format`. Fixed by linking the system
netcdf-fortran via `nf-config` (`configure.ac`, `Makefile.am`,
`src/Makefile.am`).

## netCDF input path

**N1. Positional axis-order assumption (`src/netcdfinput.f90`).**
The reader assumed the data variable is stored `(lon,lat,[lev,]time)` and
built the hyperslab `start/count/stride` positionally. Two consequences:

- Under the *vendored* 2008 Fortran binding, `nf90_inquire_variable`
  reports dimension IDs reversed relative to modern netcdf-c/netcdff for
  the same file (verified with a standalone probe: a variable defined
  `(lon,lat,lev,time)` reports dimids `(4,3,2,1)`). The positional code
  only worked for files whose axes happened to be stored time-first.
- Under the *system* netcdf-fortran the IDs are as-defined, and a CF-style
  `(time,[lev,]lat,lon)` file would have been read **silently scrambled**
  (the request stays in-bounds, so no error is raised).

Fixed by classifying every dimension of the data variable by name, reading
with per-axis `start/count/stride`, and `reshape(..., order=...)`-ing the
slab into the internal layout. Both storage orders and both bindings now
yield identical results (VALIDATION T7).

**N2. Time-unit whitelist (`src/netcdfcheck.f90`).** Only three literal
unit strings were accepted (`hours since 1-1-1 00:00:0.0` and the 1800/1900
variants), each with its own copy of the decoding code. Any CF units string
such as `seconds since 1970-01-01` aborted with
`ERROR: time unit in netcdf file not supported yet!`, and int64 second
values are silently narrowed into `integer`. Fixed with a generic
`<unit> since <epoch>` parser (`cf_time_factor` + `days_from_civil`,
proleptic Gregorian) that maps everything onto the existing integer
hours-since-1900 clock. The three legacy literals parse as ordinary special
cases, so old files are unaffected (VALIDATION T8).

**N3. Silently ignored crop (`src/netcdfcheck.f90`).** For netCDF input,
`netcdfcheck` overwrites the `@lon/@lat` specification with the *file
extent*; the intended crop mechanism is the separate `@slo/@sla` specs.
If a user passes `@lon:40:110:...` for a 40–120° file, the request is
silently discarded and the **full domain is read without any warning** —
wrong results with no error (reproduced: identical-file statistics showed
the full-domain slab). Fixed by promoting a differing `@lon/@lat` spec to
the subgrid selection (equivalent to `@slo/@sla`) with an informative
`NOTE:` line at `-v 2`. `@slo/@sla` keep working unchanged.

**N4. Uninitialized indices for ascending latitude (`src/selectgrid.f90`).**
`fy/ly` are only assigned in the descending-latitude branch (`latmod==1`).
For files stored south-to-north the indices stay uninitialized
(observed values `fy=0, ly=31928`), producing
`ERROR: netcdf:NetCDF: Start+count exceeds dimension bound`. Fixed by
filling the ascending branch.

**N5. Hourly data rejected (`src/list4dates.f90`).** The validity test
reads `dtime/=12 .and. dtime/=6 .and. dtime/=3 .and. dtime/=2 .and. dtime/=2`
— the final `dtime/=1` was mistyped as a second `dtime/=2`, so hourly
input aborts although the error message itself advertises 1 h as legal.
One-token fix.

**N6. Hard-coded coordinate names.** Only `time`/`lon`/`lat`/`level|lev`
were recognized, so current CDS files (`valid_time`, `pressure_level`,
`latitude`, `longitude`) failed or were mis-scanned. The alias lists are
now extended consistently in `netcdfcheck.f90` and `netcdfinput.f90`
(including the coordinate-variable lookup that was hard-wired to
`NF90_INQ_VARID(ncid,"time",...)`).

## Not fixed here (documented limitations)

- PCT aborts on degenerate samples (few dozen timesteps) inside the
  untouched `pca.f90` GPA rotation.
- Longitude wrap-around subgrid logic is kept as-is.
- GRIB input / OpenGL viewer removed with their vendored trees.
