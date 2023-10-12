"""
$(TYPEDSIGNATURES)
Convert indicator type int to a symbol.
"""
function ti_type(t::Integer)
	t == TI_TYPE_OVERLAY && return :overlay
	t == TI_TYPE_INDICATOR && return :indicator
	t == TI_TYPE_MATH && return :math
	t == TI_TYPE_SIMPLE && return :simple
	t == TI_TYPE_COMPARATIVE && return :comparitive
	return :unknown
end

"""
$(TYPEDSIGNATURES)
Input validation for `ti` calls.
"""
function ti_validate_inputs(Pₜ::AbstractVector{<:AbstractVector{TI_REAL}}, opt::AbstractVector{TI_REAL}, info::ti_indicator_info)
	@assert length(Pₜ) == info.inputs "indicator requires exactly $(info.inputs) input vector(s)"
	@assert length(opt) == info.options "indicator requires exactly $(info.options) option(s)"
end

"""
$(TYPEDSIGNATURES)
Return information about an indicator as a `ti_indicator_info` struct.
"""
@inline function ti_find_indicator(name::Symbol)
	info = @ccall libindicators.ti_find_indicator(name::Cstring)::Ptr{ti_indicator_info}
	info == C_NULL && throw(ArgumentError("Invalid indicator identififer"))
	unsafe_load(info)
end

"""
$(TYPEDSIGNATURES)
Return global information about the Tulip Indicators install.
"""
function ti_show()::NamedTuple
	(
		version = (@ccall libindicators.ti_version()::Cstring) |> unsafe_string,
		build = (@ccall libindicators.ti_build()::Clong),
		indicator_count = (@ccall libindicators.ti_indicator_count()::Cint)
	)
end

"""
$(TYPEDSIGNATURES)
Return information about an indicator.
"""
function ti_show(name::Symbol)::NamedTuple
	ti_show(ti_find_indicator(name))
end

"""
$(TYPEDSIGNATURES)
Return information about an indicator.
"""
function ti_show(info::ti_indicator_info)::NamedTuple
	(
		type = ti_type(info.type),
		full_name = unsafe_string(info.full_name),
		inputs = [Symbol(unsafe_string(info.input_names[i])) for i in 1:info.inputs],
		options = [Symbol(unsafe_string(info.option_names[i])) for i in 1:info.options],
		outputs = [Symbol(unsafe_string(info.output_names[i])) for i in 1:info.outputs]
	)
end

