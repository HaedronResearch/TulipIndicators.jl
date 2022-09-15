"""
TulipIndicators.jl Indicator Array Interface.
"""

"""
$(TYPEDSIGNATURES)
`ti` call that takes and returns matrices.
"""
@inline function ti(name::Symbol, Pₜ::AbstractMatrix{TI_REAL}, opt::AbstractVector{TI_REAL}=TI_REAL[]; validate::Bool=true, pad::Bool=true, padval::Union{Missing, TI_REAL}=missing)
	ti(name, tovectors(Pₜ), opt; validate=validate, pad=pad, padval=padval) |> tomatrix
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
	validate && ti_validate_inputs(Pₜ, opt, info)

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

