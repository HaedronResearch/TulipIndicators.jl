"""
Materialized Tulip Indicator info tuple
"""
const TI_INFO_NT = @NamedTuple begin
	type::Symbol
	# full_name::String
	inputs::Cint
	options::Cint
	outputs::Cint
	input_names::Vector{Symbol}
	option_names::Vector{Symbol}
	output_names::Vector{Symbol}
	start::ti_indicator_start_function
	indicator::ti_indicator_function
	indicator_ref::ti_indicator_function
end

const TI_INFO = Union{ti_indicator_info, TI_INFO_NT}

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
function ti_validate_inputs(Pₜ::AbstractVector{<:AbstractVector{T}}, opt::AbstractVector{T}, info::TI_INFO) where {T<:TI_REAL}
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
function ti_show(name::Symbol)::TI_INFO_NT
	ti_show(ti_find_indicator(name))
end

"""
$(TYPEDSIGNATURES)
Parse `ti_indicator_info` into a readable format.
"""
function ti_show(info::ti_indicator_info)::TI_INFO_NT
	(
		type = ti_type(info.type),
		# full_name = unsafe_string(info.full_name),
		inputs = info.inputs,
		options = info.options,
		outputs = info.outputs,
		input_names = [Symbol(unsafe_string(info.input_names[i])) for i in 1:info.inputs],
		option_names = [Symbol(unsafe_string(info.option_names[i])) for i in 1:info.options],
		output_names = [Symbol(unsafe_string(info.output_names[i])) for i in 1:info.outputs],
		start = info.start,
		indicator = info.indicator,
		indicator_ref = info.indicator_ref
	)
end
