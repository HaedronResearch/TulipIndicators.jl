"""
Definitions file autogenerated by Clang.jl
"""

const TC_REAL = Cdouble

mutable struct tc_result end

const tc_set = UInt64

struct tc_config
	period::Cint
	body_none::TC_REAL
	body_short::TC_REAL
	body_long::TC_REAL
	wick_none::TC_REAL
	wick_long::TC_REAL
	near::TC_REAL
end

struct tc_hit
	index::Cint
	patterns::tc_set
end

# typedef int ( * tc_candle_function ) ( int size , TC_REAL const * const * inputs , tc_config const * options , tc_result * output )
const tc_candle_function = Ptr{Cvoid}

struct tc_candle_info
	name::Ptr{Cchar}
	full_name::Ptr{Cchar}
	pattern::tc_set
	candle::tc_candle_function
end

# typedef int ( * ti_indicator_start_function ) ( TI_REAL const * options )
const ti_indicator_start_function = Ptr{Cvoid}

# typedef int ( * ti_indicator_function ) ( int size , TI_REAL const * const * inputs , TI_REAL const * options , TI_REAL * const * outputs )
const ti_indicator_function = Ptr{Cvoid}

mutable struct ti_stream end

# typedef int ( * ti_indicator_stream_new ) ( TI_REAL const * options , ti_stream * * stream )
const ti_indicator_stream_new = Ptr{Cvoid}

# typedef int ( * ti_indicator_stream_run ) ( ti_stream * stream , int size , TI_REAL const * const * inputs , TI_REAL * const * outputs )
const ti_indicator_stream_run = Ptr{Cvoid}

# typedef void ( * ti_indicator_stream_free ) ( ti_stream * stream )
const ti_indicator_stream_free = Ptr{Cvoid}

struct ti_indicator_info
	name::Ptr{Cchar}
	full_name::Ptr{Cchar}
	start::ti_indicator_start_function
	indicator::ti_indicator_function
	indicator_ref::ti_indicator_function
	type::Cint
	inputs::Cint
	options::Cint
	outputs::Cint
	input_names::NTuple{16, Ptr{Cchar}}
	option_names::NTuple{16, Ptr{Cchar}}
	output_names::NTuple{16, Ptr{Cchar}}
	stream_new::ti_indicator_stream_new
	stream_run::ti_indicator_stream_run
	stream_free::ti_indicator_stream_free
end

const TC_VERSION = "0.9.2"

const TC_BUILD = 1660687722

const TC_OKAY = 0

const TC_INVALID_OPTION = 1

const TC_OUT_OF_MEMORY = 2

const TC_CANDLE_COUNT = 26

const TI_VERSION = "0.9.2"

const TI_BUILD = 1660687722

const TI_REAL = Float64

const TI_INDICATOR_COUNT = 104

const TI_OKAY = 0

const TI_INVALID_OPTION = 1

const TI_OUT_OF_MEMORY = 2

const TI_TYPE_OVERLAY = 1

const TI_TYPE_INDICATOR = 2

const TI_TYPE_MATH = 3

const TI_TYPE_SIMPLE = 4

const TI_TYPE_COMPARATIVE = 5

const TI_MAXINDPARAMS = 16
