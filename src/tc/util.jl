"""
Materialized Tulip Candle info tuple
"""
const TC_INFO_NT = @NamedTuple begin
	# full_name::String
	pattern::tc_set
	candle::tc_candle_function
end

const TC_INFO = Union{tc_candle_info, TC_INFO_NT}

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
function tc_show()::NamedTuple
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
function tc_show(name::Symbol)::TC_INFO_NT
	info = tc_find_candle(name)
	(
		# full_name = unsafe_string(info.full_name),
		pattern = info.pattern,
		candle = info.candle
	)
end

