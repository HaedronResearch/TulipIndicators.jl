# TulipIndicators.jl

Julia bindings for [Tulip Indicators](https://github.com/TulipCharts/tulipindicators).

This package is a work in progress.

## Getting Started
Download and install the package from the REPL with `] add <this_repo_url>`.

## Overview
The only functions this package exports are: `ti`, `tc`, and `{ti, tc}_info`.

Use `ti` to compute an indicator based on a `Symbol` identifier, valid identifiers can be found [here](https://tulipindicators.org/list). Because of how the upstream C lib is written, the lowest level wrapper method takes in a vector of vectors. Higher level wrappers exist for matrices and Tables.jl compatible sources, although the latter has only been tested with `DataFrames` so far.

The indicator may require options (parameters) to be supplied. The meaning and valid number of options can be found at the [upstream Tulip Indicators website](https://tulipindicators.org/list) or by calling `ti_info` with the identifier.

By default `ti` will pad the output with `Missing` values for indicators that introduce a lag. Set `pad=false` if you want to disable padding or `padval=<Cfloat>` for another pad value. I decided on this default to maintain alignment with index arrays.

The `tc` function provides an interface to Tulip Candles. This is not a priority for me, but the interface exists if you want to play with it. I couldn't find documentation on the candle patterns, but they are part of the upstream C library so I included this interface.

## Toy Example
```julia
julia> using TulipIndicators

julia> ti_info()
Dict{Symbol, Union{Int32, Int64, String}} with 3 entries:
  :version         => "0.9.2"
  :indicator_count => 104
  :build           => 1660687722

julia> ti_info(:atr)
Dict{Symbol, Union{String, Vector{String}}} with 5 entries:
  :type      => "indicator"
  :full_name => "Average True Range"
  :inputs    => ["high", "low", "close"]
  :outputs   => ["atr"]
  :options   => ["period"]

julia> n=10
julia> hlc = [cumsum(ones(n)), -cumsum(ones(n)), zeros(n)]
julia> ti(:atr, hlc, [3.])
1-element Vector{Vector{Union{Missing, Float64}}}:
 [missing, missing, 4.0, 5.333333333333333, 6.888888888888888, 8.592592592592592, 10.395061728395062, 12.263374485596708, 14.175582990397805, 16.11705532693187]

julia> ti(:atr, hcat(hlc...), [3.]) # Matrix works too; Matrix inputs return Matrix outputs
10×1 Matrix{Union{Missing, Float64}}:
   missing
   missing
  4.0
  5.333333333333333
  6.888888888888888
  8.592592592592592
 10.395061728395062
 12.263374485596708
 14.175582990397805
 16.11705532693187

julia> ti(:atr, hcat(hlc...), [3.]; pad=false) # No padding
8×1 Matrix{Float64}:
  4.0
  5.333333333333333
  6.888888888888888
  8.592592592592592
 10.395061728395062
 12.263374485596708
 14.175582990397805
 16.11705532693187
```

## Tables.jl Toy Example
```julia
julia> using TulipIndicators
julia> using Random, Dates, DateTimeDataFrames
julia> Random.setseed!(1)
julia> df = randdf(DateTime(2020):Hour(1):DateTime(2021))
8785×5 DataFrame
  Row │ datetime             open      high      low       close
      │ DateTime             Float64   Float64   Float64   Float64
──────┼─────────────────────────────────────────────────────────────
    1 │ 2020-01-01T00:00:00  100.0     100.877    97.5515   97.5515
    2 │ 2020-01-01T01:00:00   95.6595   96.5572   91.7056   91.7056
    3 │ 2020-01-01T02:00:00   91.8678   91.9781   87.5985   90.6398
    4 │ 2020-01-01T03:00:00   91.1292   91.338    87.0751   87.3035
    5 │ 2020-01-01T04:00:00   87.5135   89.8497   87.0547   89.8497
    6 │ 2020-01-01T05:00:00   89.7479   90.14     87.5039   89.0138
    7 │ 2020-01-01T06:00:00   88.2186   94.1354   87.9055   90.9608
    8 │ 2020-01-01T07:00:00   91.2758   93.3164   91.2758   92.5838
    9 │ 2020-01-01T08:00:00   93.3273   98.3331   93.3273   98.045
   10 │ 2020-01-01T09:00:00   96.5964  102.11     96.5964  102.11
   11 │ 2020-01-01T10:00:00  101.808   103.343   100.313   103.343
   12 │ 2020-01-01T11:00:00  103.062   105.433   102.789   104.37
   13 │ 2020-01-01T12:00:00  103.025   103.025    99.6285  100.432
   14 │ 2020-01-01T13:00:00   99.0724  101.274    94.4314   94.4314
   15 │ 2020-01-01T14:00:00   96.2815  100.929    96.2815   98.7329
   16 │ 2020-01-01T15:00:00   99.3179  100.869    96.5954   96.5954
   17 │ 2020-01-01T16:00:00   96.2179   98.6127   96.2179   98.5858
   18 │ 2020-01-01T17:00:00   98.7711  105.86     98.6949  105.86
   19 │ 2020-01-01T18:00:00  106.289   106.289   100.21    100.21
   20 │ 2020-01-01T19:00:00   97.2592   97.2592   93.8097   95.2037
   21 │ 2020-01-01T20:00:00   94.2801   94.9575   92.5562   94.4946
   22 │ 2020-01-01T21:00:00   95.7396   96.4816   91.2825   91.2825
   23 │ 2020-01-01T22:00:00   92.6712   98.74     92.6712   98.74
   24 │ 2020-01-01T23:00:00   98.1483  101.163    98.1483  101.163
  ⋮   │          ⋮              ⋮         ⋮         ⋮         ⋮
 8762 │ 2020-12-31T01:00:00  466.527   470.199   466.527   468.262
 8763 │ 2020-12-31T02:00:00  466.388   468.587   463.048   463.048
 8764 │ 2020-12-31T03:00:00  463.294   463.294   457.891   457.891
 8765 │ 2020-12-31T04:00:00  457.146   461.959   457.146   460.404
 8766 │ 2020-12-31T05:00:00  460.522   465.384   460.522   465.303
 8767 │ 2020-12-31T06:00:00  464.632   465.413   461.389   462.048
 8768 │ 2020-12-31T07:00:00  462.043   463.481   460.871   462.525
 8769 │ 2020-12-31T08:00:00  463.101   465.654   461.981   462.926
 8770 │ 2020-12-31T09:00:00  463.595   464.387   462.957   464.254
 8771 │ 2020-12-31T10:00:00  464.353   467.8     464.217   466.497
 8772 │ 2020-12-31T11:00:00  466.311   468.018   464.63    467.142
 8773 │ 2020-12-31T12:00:00  467.061   471.342   465.51    465.51
 8774 │ 2020-12-31T13:00:00  465.046   465.046   462.118   463.305
 8775 │ 2020-12-31T14:00:00  465.18    465.18    459.864   461.872
 8776 │ 2020-12-31T15:00:00  462.562   465.747   461.891   465.036
 8777 │ 2020-12-31T16:00:00  465.32    468.022   464.382   467.397
 8778 │ 2020-12-31T17:00:00  467.239   467.239   463.8     463.8
 8779 │ 2020-12-31T18:00:00  463.772   463.772   461.086   461.689
 8780 │ 2020-12-31T19:00:00  460.274   462.498   459.554   459.985
 8781 │ 2020-12-31T20:00:00  459.102   460.728   457.043   457.371
 8782 │ 2020-12-31T21:00:00  457.749   457.749   452.585   452.585
 8783 │ 2020-12-31T22:00:00  452.924   454.454   450.092   454.454
 8784 │ 2020-12-31T23:00:00  454.128   454.554   452.178   454.438
 8785 │ 2021-01-01T00:00:00  454.435   455.738   453.862   455.738
                                                   8737 rows omitted

julia> ti(:sma, df, [5.])
8785×2 DataFrame
  Row │ datetime             sma
      │ DateTime             Float64?
──────┼───────────────────────────────────
    1 │ 2020-01-01T00:00:00  missing
    2 │ 2020-01-01T01:00:00  missing
    3 │ 2020-01-01T02:00:00  missing
    4 │ 2020-01-01T03:00:00  missing
    5 │ 2020-01-01T04:00:00       93.234
    6 │ 2020-01-01T05:00:00       91.1836
    7 │ 2020-01-01T06:00:00       89.6954
    8 │ 2020-01-01T07:00:00       89.577
    9 │ 2020-01-01T08:00:00       90.0166
   10 │ 2020-01-01T09:00:00       91.8332
   11 │ 2020-01-01T10:00:00       94.2453
   12 │ 2020-01-01T11:00:00       97.214
   13 │ 2020-01-01T12:00:00       99.5638
   14 │ 2020-01-01T13:00:00      100.713
   15 │ 2020-01-01T14:00:00      100.65
   16 │ 2020-01-01T15:00:00      100.152
   17 │ 2020-01-01T16:00:00       98.7829
   18 │ 2020-01-01T17:00:00       97.9322
   19 │ 2020-01-01T18:00:00       99.3754
   20 │ 2020-01-01T19:00:00       99.5709
   21 │ 2020-01-01T20:00:00       98.5634
   22 │ 2020-01-01T21:00:00       98.4677
   23 │ 2020-01-01T22:00:00       97.2477
   24 │ 2020-01-01T23:00:00       95.6197
  ⋮   │          ⋮                ⋮
 8762 │ 2020-12-31T01:00:00      463.519
 8763 │ 2020-12-31T02:00:00      463.365
 8764 │ 2020-12-31T03:00:00      463.22
 8765 │ 2020-12-31T04:00:00      462.957
 8766 │ 2020-12-31T05:00:00      462.775
 8767 │ 2020-12-31T06:00:00      462.396
 8768 │ 2020-12-31T07:00:00      461.528
 8769 │ 2020-12-31T08:00:00      461.489
 8770 │ 2020-12-31T09:00:00      462.779
 8771 │ 2020-12-31T10:00:00      463.545
 8772 │ 2020-12-31T11:00:00      463.881
 8773 │ 2020-12-31T12:00:00      464.884
 8774 │ 2020-12-31T13:00:00      465.273
 8775 │ 2020-12-31T14:00:00      465.59
 8776 │ 2020-12-31T15:00:00      465.232
 8777 │ 2020-12-31T16:00:00      465.034
 8778 │ 2020-12-31T17:00:00      465.069
 8779 │ 2020-12-31T18:00:00      464.814
 8780 │ 2020-12-31T19:00:00      463.833
 8781 │ 2020-12-31T20:00:00      463.141
 8782 │ 2020-12-31T21:00:00      461.627
 8783 │ 2020-12-31T22:00:00      458.764
 8784 │ 2020-12-31T23:00:00      456.836
 8785 │ 2021-01-01T00:00:00      455.668
```

## Details
* `src/base.jl` was autogenerated by Clang.jl from TulipIndicators_jll packaged header files, this file contains all common types and constants.
* `TulipIndicators.jl` calls `libindicators` C functions via [`@ccall`](https://docs.julialang.org/en/v1/base/c/)
* When a symbol is passed to `ti`, `ti_find_indicator` is `@ccall`ed, the resulting struct contains function pointers which can be `@ccall`ed to initialize and compute the indicator. A similar process occurs for `tc`.
* This avoids a whole bunch of unnecessary function definitions because `@ccall`/`ccall` [cannot be efficiently `@eval`ed over](https://docs.julialang.org/en/v1/manual/calling-c-and-fortran-code/#Non-constant-Function-Specifications).

## TODO
* An interface for `NamedTuple` and/or `Dict` option arguments instead of `AbstractVector`. This way option names can be included in `ti` calls.
* Publish unit tests
* `Tables.jl` compatibility for `tc` for completeness

