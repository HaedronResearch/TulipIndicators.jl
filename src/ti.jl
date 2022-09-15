"""
TulipIndicators.jl Indicator Interface.
"""

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
function ti_info()::Dict{Symbol, Union{String, Clong, Cint}}
	Dict{Symbol, Union{String, Clong, Cint}}(
		:version => (@ccall libindicators.ti_version()::Cstring) |> unsafe_string,
		:build => (@ccall libindicators.ti_build()::Clong),
		:indicator_count => (@ccall libindicators.ti_indicator_count()::Cint)
	)
end

"""
$(TYPEDSIGNATURES)
Return information about an indicator.
"""
function ti_info(name::Symbol)::Dict{Symbol, Union{String, Vector{Symbol}}}
	ti_info(ti_find_indicator(name))
end

"""
$(TYPEDSIGNATURES)
Return information about an indicator.
"""
function ti_info(info::ti_indicator_info)::Dict{Symbol, Union{String, Vector{Symbol}}}
	Dict{Symbol, Union{String, Vector{Symbol}}}(
		:type => ti_type(info.type),
		:full_name => unsafe_string(info.full_name),
		:inputs => [Symbol(unsafe_string(info.input_names[i])) for i in 1:info.inputs],
		:options => [Symbol(unsafe_string(info.option_names[i])) for i in 1:info.options],
		:outputs => [Symbol(unsafe_string(info.output_names[i])) for i in 1:info.outputs]
	)
end

"""
$(TYPEDSIGNATURES)
Compute Tulip indicator from indicator `name`.
"""
function ti(name::Symbol, Pₜ::AbstractVector{Vector{TI_REAL}}, opt::AbstractVector{TI_REAL}=TI_REAL[]; validate::Bool=true, pad::Bool=true, padval::Union{Missing, TI_REAL}=missing)
	info = ti_find_indicator(name)
	ti(info, Pₜ, opt; validate=validate, pad=pad, padval=padval)
end

"""
$(TYPEDSIGNATURES)
Compute Tulip indicator from indicator `info`.
"""
function ti(info::ti_indicator_info, Pₜ::AbstractVector{Vector{TI_REAL}}, opt::AbstractVector{TI_REAL}=TI_REAL[]; validate::Bool=true, pad::Bool=true, padval::Union{Missing, TI_REAL}=missing)
	validate && ti_validate_inputs(name, Pₜ, opt, info)

	n = length(Pₜ[1])
	τ = @ccall $(info.start)(opt::Ref{TI_REAL})::Cint
	Xₜ = [zeros(n - τ) for i in 1:info.outputs]
	code = @ccall $(info.indicator)(n::Cint, Pₜ::Ref{Ptr{TI_REAL}}, opt::Ref{TI_REAL}, Xₜ::Ref{Ptr{TI_REAL}})::Cint
	validate && checkexit(code)

	if pad && τ > 0
		if ismissing(padval)
			Xₜ = convert(Vector{Vector{Union{Missing, TI_REAL}}}, Xₜ)
		end
		prependpadding!(Xₜ, τ, padval)
	end
	Xₜ
end

"""
$(TYPEDSIGNATURES)
`ti` call that takes and returns matrices.
"""
@inline function ti(name::Symbol, Pₜ::AbstractMatrix{TI_REAL}, opt::AbstractVector{TI_REAL}=TI_REAL[]; validate::Bool=true, pad::Bool=true, padval::Union{Missing, TI_REAL}=missing)
	ti(name, tovectors(Pₜ), opt; validate=validate, pad=pad, padval=padval) |> tomatrix
end

