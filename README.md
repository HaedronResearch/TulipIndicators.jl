# TulipIndicators.jl

A simple Julia wrapper for [Tulip Indicators](https://github.com/TulipCharts/tulipindicators).

## Getting Started
Download and install the package from the REPL with `] add <this_repo_url>`.

## Overview
The only functions this package exports are: `ti{p}`, `tc`, and `{ti, tc}_show`. Use `ti` to compute an indicator based on a `Symbol` identifier, valid identifiers can be found [here](https://tulipindicators.org/list).

The indicator may require options (parameters) to be supplied. The meaning and valid number of options can be found at the [upstream Tulip Indicators website](https://tulipindicators.org/list) or by calling `ti_show(:<identifier>)`.

The lowest level wrapper method takes in a vector of vectors. There are higher level methods dispatching on `AbstractMatrix`. All methods output a `Matrix` result. Use `tip` if you want a `PaddedView` output (pad element is `missing` by default).

The `tc` function provides an interface to Tulip Candles. This is not a priority for me, but the interface exists if you want to play with it. I couldn't find documentation on the candle patterns.

## Toy Example
```julia
julia> using TulipIndicators

julia> ti_show()
(version = "0.9.2", build = 1660687722, indicator_count = 104)

julia> ti_show(:atr)
(type = :indicator, inputs = 3, options = 1, outputs = 1, input_names = [:high, :low, :close], option_names = [:period], output_names = [:atr], start = Ptr{Nothing} ..., indicator = Ptr{Nothing} ..., indicator_ref = Ptr{Nothing} ...)

julia> n=10
julia> hlc = [cumsum(ones(n)), -cumsum(ones(n)), zeros(n)]
julia> ti(:atr, hlc, [3.]) # vec of vecs
8×1 Matrix{Float64}:
  4.0
  5.333333333333333
  6.888888888888888
  8.592592592592592
 10.395061728395062
 12.263374485596708
 14.175582990397805
 16.11705532693187

julia> ti(:atr, hcat(hlc...), [3.]) # matrix
8×1 Matrix{Float64}:
  4.0
  5.333333333333333
  6.888888888888888
  8.592592592592592
 10.395061728395062
 12.263374485596708
 14.175582990397805
 16.11705532693187

julia> tip(:atr, hcat(hlc...), [3.]) # matrix, padded output
10×1 PaddedView(missing, ::Matrix{Float64}, (-1:8, 1:1)) with eltype Union{Missing, Float64} with indices -1:8×1:1:
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
```

## Implementation Details
* The C lib is packaged via a [BinaryBuilder.jl](https://github.com/JuliaPackaging/BinaryBuilder.jl) [jll package](https://github.com/JuliaBinaryWrappers/TulipIndicators_jll.jl) dependency.
* `src/base/base.jl` was autogenerated by `Clang.jl` from the header files, this file contains all common types and constants.
* `TulipIndicators.jl` calls `libindicators` C functions via [`@ccall`](https://docs.julialang.org/en/v1/base/c/)
* When a symbol is passed to `ti{p}`, `ti_find_indicator` is `@ccall`ed, the resulting struct contains function pointers which can be `@ccall`ed to initialize and compute the indicator. A similar process occurs for `tc`.
* This avoids a whole bunch of unnecessary function definitions because `@ccall`/`ccall` [cannot be efficiently `@eval`ed over](https://docs.julialang.org/en/v1/manual/calling-c-and-fortran-code/#Non-constant-Function-Specifications).

## TODO
* Put all the indicator information into a constant table deserialized from disk when the package is loaded.
* An interface for `NamedTuple` instead of `AbstractVector` option arguments, so option names can be included in `ti{p}` calls.
* Add [tindicators](https://github.com/3jane/tindicators) Tulip Indicators fork library

