"""
$(TYPEDSIGNATURES)
Vector or Matrix `tc`.
"""
@inline function tc(name::Symbol, Pₜ::AbstractVecOrMat{TC_REAL}, opt::AbstractVector{TC_REAL}=TC_REAL[]; validate::Bool=VALIDATE)
	tc(tc_find_candle(name), Pₜ, opt; validate=validate)
end

"""
$(TYPEDSIGNATURES)
Vector or Matrix `tc`.
"""
@inline function tc(info::tc_candle_info, Pₜ::AbstractVecOrMat{TC_REAL}, opt::AbstractVector{TC_REAL}=TC_REAL[]; validate::Bool=VALIDATE)
	tc(info, nestedvector(Pₜ), opt; validate=validate)
end

"""
$(TYPEDSIGNATURES)
Nested Vector `tc`.
"""
@inline function tc(name::Symbol, Pₜ::AbstractVector{<:AbstractVector{TC_REAL}}, opt::AbstractVector{TC_REAL}=TC_REAL[]; validate::Bool=VALIDATE)
	tc(tc_find_candle(name), Pₜ, opt; validate=validate)
end

"""
$(TYPEDSIGNATURES)
Nested Vector `tc`.
This is the only method that calls libindicators code.
"""
function tc(info::tc_candle_info, Pₜ::AbstractVector{<:AbstractVector{TC_REAL}}, opt::AbstractVector{TC_REAL}=TC_REAL[]; validate::Bool=VALIDATE)
	n = length(Pₜ[1])
	Xₜ = [zeros(n) for i in 1:length(Pₜ)]
	code = @ccall $(info.candle)(n::Cint, Pₜ::Ref{Ptr{TC_REAL}}, opt::Ref{TC_REAL}, Xₜ::Ref{Ptr{TC_REAL}})::Cint
	validate && checkexit(code)
	Xₜ |> matrix
end

