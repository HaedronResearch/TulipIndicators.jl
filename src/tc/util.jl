"""
TulipIndicators.jl Candle Utilities.
"""

"""
$(TYPEDSIGNATURES)
Return information about a candle as a `tc_candle_info` struct.
"""
@inline function tc_find_candle(name::Symbol)
	info = @ccall libindicators.tc_find_candle(name::Cstring)::Ptr{tc_candle_info}
	info == C_NULL && throw(ArgumentError("Invalid candle identififer"))
	unsafe_load(info)
end

"""
$(TYPEDSIGNATURES)
Return global information about the Tulip Candles install.
"""
function tc_info()::NamedTuple
	(
		version = (@ccall libindicators.tc_version()::Cstring) |> unsafe_string,
		build = (@ccall libindicators.tc_build()::Clong),
		indicator_count = (@ccall libindicators.tc_candle_count()::Cint)
	)
end

"""
$(TYPEDSIGNATURES)
Return information about a candle.
"""
function tc_info(name::Symbol)::NamedTuple
	info = tc_find_candle(name)
	(
		full_name = unsafe_string(info.full_name),
		pattern = info.pattern
	)
end

