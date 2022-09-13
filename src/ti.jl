"""
TulipIndicators.jl Indicator Interface.
"""

ti_version() = (@ccall libindicators.ti_version()::Ptr{Cchar}) |> unsafe_load
ti_build() = @ccall libindicators.ti_build()::Clong
ti_indicator_count() = @ccall libindicators.ti_indicator_count()::Cint

"""
$(TYPEDSIGNATURES)
Return information about the indicator as a `ti_indicator_info` struct.
"""
@inline function ti_find_indicator(name::Symbol)
	(@ccall libindicators.ti_find_indicator(name::Ptr{Cchar})::Ptr{ti_indicator_info}) |> unsafe_load
end

"""
$(TYPEDSIGNATURES)
Compute Tulip indicator with name ti_`name`.
"""
function ti(name::Symbol, Pₜ::AbstractVector{Vector{Cdouble}}, opt::AbstractVector{Cdouble}=Cdouble[]; validate::Bool=true, pad::Bool=true, padval::Union{Missing, Cdouble}=missing)
	info = ti_find_indicator(name)
	validate && ti_validate_inputs(name, Pₜ, opt, info)

	n = length(Pₜ[1])
	τ = @ccall $(info.start)(opt::Ptr{Cdouble})::Cint
	Xₜ = [zeros(n - τ) for i in 1:info.outputs]
	code = @ccall $(info.indicator)(n::Cint, Pₜ::Ptr{Ptr{Cdouble}}, opt::Ptr{Cdouble}, Xₜ::Ptr{Ptr{Cdouble}})::Cint
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

