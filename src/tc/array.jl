"""
$(TYPEDSIGNATURES)
"""
@inline function tc(name::Symbol, Pₜ::AbstractVecOrMat{T}, opt::AbstractVector{T}=T[]; validate::Bool=VALIDATE) where {T<:TC_REAL}
	tc(tc_find_candle(name), Pₜ, opt; validate=validate)
end

"""
$(TYPEDSIGNATURES)
"""
@inline function tc(name::Symbol, Pₜ::AbstractVector{<:AbstractVector{T}}, opt::AbstractVector{T}=T[]; validate::Bool=VALIDATE) where {T<:TC_REAL}
	tc(tc_find_candle(name), Pₜ, opt; validate=validate)
end

"""
$(TYPEDSIGNATURES)
"""
@inline function tc(info::TC_INFO, Pₜ::AbstractVecOrMat{T}, opt::AbstractVector{T}=T[]; validate::Bool=VALIDATE) where {T<:TC_REAL}
	tc(info, nestedvector(Pₜ), opt; validate=validate)
end

"""
$(TYPEDSIGNATURES)
Compute TC candles
"""
function tc(info::TC_INFO, Pₜ::AbstractVector{<:AbstractVector{T}}, opt::AbstractVector{T}=T[]; validate::Bool=VALIDATE) where {T<:TC_REAL}
	n = length(Pₜ[1])
	Xₜ = [Vector{T}(undef, n) for i in 1:length(Pₜ)]
	code = @ccall $(info.candle)(n::Cint, Pₜ::Ref{Ptr{TC_REAL}}, opt::Ref{TC_REAL}, Xₜ::Ref{Ptr{TC_REAL}})::Cint
	validate && checkexit(code)
	Xₜ |> matrix
end

