"""
TulipIndicators.jl Candle Array Interface.
"""

"""
$(TYPEDSIGNATURES)
`tc` call that takes and returns matrices.
"""
@inline function tc(name::Symbol, Pₜ::AbstractMatrix{TC_REAL}, opt::AbstractVector{TC_REAL}=TC_REAL[]; validate::Bool=true)
	tc(name, tovectors(Pₜ), opt; validate=validate) |> tomatrix
end

"""
$(TYPEDSIGNATURES)
Compute Tulip candle.
"""
function tc(name::Symbol, Pₜ::AbstractVector{Vector{TC_REAL}}, opt::AbstractVector{TC_REAL}=TC_REAL[]; validate::Bool=true)
	info = tc_find_candle(name)
	n = length(Pₜ[1])
	Xₜ = [zeros(n) for i in 1:length(Pₜ)]
	code = @ccall $(info.candle)(n::Cint, Pₜ::Ref{Ptr{TC_REAL}}, opt::Ref{TC_REAL}, Xₜ::Ref{Ptr{TC_REAL}})::Cint
	validate && checkexit(code)
	Xₜ
end

