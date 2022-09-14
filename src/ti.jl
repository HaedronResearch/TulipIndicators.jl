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
function ti_info(name::Symbol)::Dict{Symbol, Union{String, Vector{String}}}
	info = ti_find_indicator(name)
	Dict{Symbol, Union{String, Vector{String}}}(
		:type => ti_type(info.type),
		:full_name => unsafe_string(info.full_name),
		:inputs => [unsafe_string(info.input_names[i]) for i in 1:info.inputs],
		:options => [unsafe_string(info.option_names[i]) for i in 1:info.options],
		:outputs => [unsafe_string(info.output_names[i]) for i in 1:info.outputs]
	)
end

"""
$(TYPEDSIGNATURES)
Compute Tulip indicator.
"""
function ti(name::Symbol, Pₜ::AbstractVector{Vector{Cdouble}}, opt::AbstractVector{Cdouble}=Cdouble[]; validate::Bool=true, pad::Bool=true, padval::Union{Missing, Cdouble}=missing)
	info = ti_find_indicator(name)
	validate && ti_validate_inputs(name, Pₜ, opt, info)

	n = length(Pₜ[1])
	τ = @ccall $(info.start)(opt::Ref{Cdouble})::Cint
	Xₜ = [zeros(n - τ) for i in 1:info.outputs]
	code = @ccall $(info.indicator)(n::Cint, Pₜ::Ref{Ptr{Cdouble}}, opt::Ref{Cdouble}, Xₜ::Ref{Ptr{Cdouble}})::Cint
	validate && checkexit(code)

	if pad && τ > 0
		if ismissing(padval)
			Xₜ = convert(Vector{Vector{Union{Missing, Cdouble}}}, Xₜ)
		end
		prependpadding!(Xₜ, τ, padval)
	end
	Xₜ
end

"""
$(TYPEDSIGNATURES)
`ti` call that takes and returns matrices.
"""
@inline function ti(name::Symbol, Pₜ::AbstractMatrix{Cdouble}, opt::AbstractVector{Cdouble}=Cdouble[]; validate::Bool=true, pad::Bool=true, padval::Union{Missing, Cdouble}=missing)
	ti(name, tovectors(Pₜ), opt; validate=validate, pad=pad, padval=padval) |> tomatrix
end

