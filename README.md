# cost733class — netCDF4/CF modernization fork

现代版 cost733class：**直接读取今天的 NETCDF4(HDF5)/CF 文件**（含新 CDS 下载布局），
ASCII 输入行为与上游 1.4 字节级兼容。

A modernized fork of cost733class 1.4 that **reads modern NETCDF4(HDF5)/CF
files directly** (including the current CDS request layout), while keeping
byte-identical behaviour for ASCII input.

Upstream: [cost733class](http://geo23.geo.uni-augsburg.de/cost733class-1.2) by
A. Philipp et al., University of Augsburg — see
[Demuzere et al. (2011), *Theor. Appl. Climatol.* 105, 143–159](https://doi.org/10.1007/s00704-010-0369-z)
and the `doc/` user guide. Licensed GPLv3+ (`LICENSE`, `COPYRIGHT`).

## Why this fork / 为什么 fork

上游 1.4 的发布包内嵌了 2008 年的 netcdf-4.0.1（编译时未启用 netCDF-4），
只能读 netCDF-3 classic；直接喂 CDS 的 NETCDF4 文件会报
`NetCDF: Unknown file format`。换成系统 netcdf-fortran 后又暴露出输入路径上
六个问题（详见 [UPSTREAM_FIXES.md](UPSTREAM_FIXES.md)），其中两个会导致
**静默读错数据**。本 fork 换系统库重编译并修掉全部六处。

The upstream 1.4 tarball vendors netcdf-4.0.1 from 2008 built without
netCDF-4 support (classic format only), and its netCDF input path has six
defects once linked against a modern netcdf-fortran — two of which silently
read the wrong data. This fork links the system library and fixes all six.

## Build (Ubuntu 24.04) / 构建

```bash
sudo apt install build-essential gfortran autoconf automake \
                 libnetcdf-dev libnetcdff-dev
git clone <this-repo> && cd cost733class
autoreconf -fi && ./configure && make -j4
./src/cost733class          # prints usage
```

`./configure` locates netCDF-Fortran via `nf-config`; use `--disable-netcdf`
to build without netCDF support (dummy I/O stubs).
`--enable-grib` / `--enable-opengl` are not available in this fork
(the vendored grib_api/f03gl trees were removed) and fail with a clear message.

## Usage / 用法

```bash
# modern NETCDF4, CDS layout (valid_time / pressure_level / latitude / longitude),
# crop + select the 500 hPa level, PCT with 4 types:
./src/cost733class -dat "@pth:era5_pl_201601.nc@var:z@fmt:netcdf@lon:40:110:0.25@lat:25:65:0.25@sle:500" \
    -met PCT -ncl 4 -cla out.cla -cnt out_cnt.txt

# classic ASCII matrix (unchanged upstream behaviour):
./src/cost733class -dat "@pth:z500.dat@fmt:ascii@lon:40:110:1@lat:25:65:1" \
    -met PCT -ncl 4 -cla out.cla
```

Notes / 说明:

- `@lon/@lat` now behave intuitively for netCDF input: if they differ from
  the file extent they select a subgrid (previously silently ignored —
  see UPSTREAM_FIXES #3). `@slo/@sla` still work as before.
- Accepted coordinate/dimension aliases: `time`, `valid_time`,
  `forecast_reference_time`; `latitude`/`longitude`; `level`, `lev`,
  `pressure_level`, `plev`. Axis storage order does not matter.
- CF time units (`seconds|minutes|hours|days since <epoch>`) are decoded
  generically; the three legacy literal unit strings keep working.
- Latitude may be stored ascending or descending.
- ASCII rows follow the upstream convention: one row per timestep,
  latitudes south→north as the outer loop, longitudes west→east inner.

## Validation / 验证

Same data (ERA5 z500, 2016-01, 124 × 45,241 grid) fed through the netCDF
path and an ASCII export of identical values produce **identical PCT K=4
class sequences**; centroids correlate r = 1.0000 with an independent
Python reference. Old and new binaries produce byte-identical `.cla` for
ASCII and for classic netCDF-3 inputs. Full suite: [VALIDATION.md](VALIDATION.md).

## Known limitations / 已知限制

- PCT aborts on degenerate samples (a few dozen timesteps) inside the
  original `pca.f90` GPA rotation — pre-existing upstream behaviour.
- GRIB input and the OpenGL viewer are removed in this fork.
- Longitude wrap-around domains crossing 0°/360° keep the upstream logic.

## Roadmap

- CI (build + minimal nc/ascii equivalence test)
- `-seed` option for the stochastic methods (SAN/MIX/KMN…; PCT is already
  deterministic)
- 64-bit offset / CDF5 output, CF-compliant netCDF outputs
- OpenMP in the distance kernels

## License

GPLv3+ — see `LICENSE` and `COPYRIGHT` (upstream: A. Philipp, C. Beck et al.,
2013). This fork modifies `configure.ac`, the `Makefile.am` files and
`src/{netcdfcheck,netcdfinput,selectgrid,list4dates}.f90`; the change log
with file references is in [UPSTREAM_FIXES.md](UPSTREAM_FIXES.md).
