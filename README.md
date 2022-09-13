# TulipIndicators.jl

Julia bindings for [Tulip Indicators](https://github.com/TulipCharts/tulipindicators).

Dispatches on basic container types only (`AbstractArray`, `AbstractMatrix`, etc), but `Tables.jl` compatible wrappers will be considered for the future.

This package is a work in progress.

## Getting Started
Download and install the package from the REPL with `] add <this_repo_url>`.

## Overview
The only functions this package exports are `ti` and `tc`.

Use `ti` to compute an indicator based on a `Symbol` identifier, valid identifiers can be found [here](https://tulipindicators.org/list). Because of how the upstream C library is written, this function takes in a vector of vectors although a matrix wrapper exists that will convert the input and output for you.

Aside from the input vectors/matrix, the indicator may require options to be supplied. The correct number of options and their meanings can be found from the previous link to Tulip Indicators website. Also keeping `validate==true` (default) will assert check that you are using the correct number of options/inputs.

By default `ti` will pad the output with `Missing` values for indicators that introduce a lag. Set `pad=false` if you want to disable padding or `padval=<any>` for another pad value. I decided on this default to keep alignment with datetime arrays (to use DataFrames, etc).

The `tc` function provides an interface to Tulip Candles. This is not a priority for me, but the interface exists if you want to play with it. I couldn't find documentation on the candle patterns, but they are part of the upstream C library so I included this interface.

## Toy Example
```julia-repl
julia> using TulipIndicators
julia> n=10
julia> hlc1 = [ones(n), -ones(n), zeros(n)]
julia> ti(:atr, hlc1, [5.])
Vector{Union{Missing, Float64}}[[missing, missing, missing, missing, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0]]

julia> hlc2 = hcat(ones(n), -ones(n), zeros(n)) # matrix works too
julia> ti(:atr, hlc2, [5.])
Union{Missing, Float64}[missing; missing; missing; missing; 2.0; 2.0; 2.0; 2.0; 2.0; 2.0;;]
```

## Details
* `src/base.jl` was autogenerated by Clang.jl from TulipIndicators_jll packaged header files, this file contains all common types and constants.
* `TulipIndicators.jl` calls `libindicators` C functions via [`@ccall`](https://docs.julialang.org/en/v1/base/c/)
* When a symbol is passed to `ti`, `ti_find_indicator` is `@ccall`ed, the resulting struct contains function pointers which can be `@ccall`ed to initialize and compute the indicator. A similar process occurs for `tc`.
* This avoids a whole bunch of unnecessary function definitions because `@ccall`/`ccall` [cannot be efficiently `@eval`ed over](https://docs.julialang.org/en/v1/manual/calling-c-and-fortran-code/#Non-constant-Function-Specifications).

## TODO
* A wrapper around `ti_find_indicator` to return indicator info in a readable format
* Publish unit tests

