# Validation record

Environment: WSL Ubuntu 24.04, gfortran 13.3, netcdf-fortran 4.5.4,
netcdf-c 4.9.2. "New" = this fork; "old" = the upstream-1.4 binary built
against the vendored netcdf-4.0.1 (static, classic-only).

Reference data: `era5_pct_z_u_v_t_850_700_500_201601.nc`
(ERA5 monthly, CDS layout `valid_time/pressure_level/latitude/longitude`,
6-hourly, 124 steps). Crop `@lon:40:110:0.25 @lat:25:65:0.25 @sle:500`
→ 281 × 161 = 45,241 grid points. PCT `-ncl 4` throughout. PCT contains no
RNG (deterministic; repeated runs are md5-identical).

| # | Test | Result |
|---|------|--------|
| T1 | old binary, ASCII anchor (msl 42×651 dat, known from prior sessions) | md5 `1408abee8dac0d6d56816a4848ca858b` — **PASS** |
| T2 | new binary, same ASCII input | md5 identical to T1 — **PASS** (ASCII path byte-compatible) |
| T3 | new binary, direct NETCDF4 read of the CDS file with crop + `@sle:500` | input stats min 48815.53 / mean 54150.21 / sdev 1516.69 == Python truth for the same crop — **PASS** (pre-fix this read the full domain: min 47860.15 / mean 53814.13) |
| T4 | **core cross-check**: ASCII export of the identical values (`%.16e`, south→north rows) vs direct netCDF read | identical class sequence for all 124 steps (class-column md5 `9ba7a75b4e594c3c9816fb9e72737582` on both paths) — **PASS** |
| T5 | hourly NETCDF4 file (24 steps) | no `ddt for hour` rejection anymore; input stage completes; PCT later aborts inside the untouched `pca.f90` GPA rotation on the degenerate 24-obs sample (pre-existing upstream limitation) — **PASS (input stage)** |
| T6 | same values stored with ascending latitude (NETCDF4 twin) | identical class sequence to T3 — **PASS** |
| T7 | same values stored lon-first in netCDF-3 classic (upstream's own storage order) | identical class sequence to T3 — **PASS** (both axis orders converge) |
| T8 | old vs new binary on netCDF-3 classic files (single-level and multi-level `@sle:500`) | `.cla` md5 `156c52224cdf0fecb255236c2b42025f` byte-identical for both binaries — **PASS** (backward compatibility) |
| T9 | centroids of the direct NETCDF4 run vs independent Python computation | per-class Pearson r = 1.0000 (n = 53/41/25/5) — **PASS** |

Reproduction scripts (kept outside the repo): WSL-side suite
`run_validation.sh` plus a Python preparation step that writes the ASCII
twin (`%.16e`) and the ascending/lon-first twins from the same crop.
ASCII twins must use `%.16e` for bit-exact comparisons: `%.8e` decimal
rounding can flip borderline PCT assignments (observed), which reflects
rounding of the *text* representation, not a reader difference.
