"""
$(TYPEDSIGNATURES)
"""
function ti(name::Symbol, Pₜ::AbstractVecOrMat{T}, opt::AbstractVector{T}=T[]; validate::Bool=VALIDATE) where {T<:TI_REAL}
	ti(ti_find_indicator(name), Pₜ, opt; validate=validate)
end

"""
$(TYPEDSIGNATURES)
"""
function ti(name::Symbol, Pₜ::AbstractVector{<:AbstractVector{T}}, opt::AbstractVector{T}=T[]; validate::Bool=VALIDATE) where {T<:TI_REAL}
	ti(ti_find_indicator(name), Pₜ, opt; validate=validate)
end

"""
$(TYPEDSIGNATURES)
"""
function ti(info::TI_INFO, Pₜ::AbstractVecOrMat{T}, opt::AbstractVector{T}=T[]; validate::Bool=VALIDATE) where {T<:TI_REAL}
	ti(info, nestedvector(Pₜ), opt; validate=validate)
end

"""
$(TYPEDSIGNATURES)
Compute TI indicators
"""
function ti(info::TI_INFO, Pₜ::AbstractVector{<:AbstractVector{T}}, opt::AbstractVector{T}=T[]; validate::Bool=VALIDATE) where {T<:TI_REAL}
	validate && ti_validate_inputs(Pₜ, opt, info)
	n = length(first(Pₜ))
	τ = @ccall $(info.start)(opt::Ref{TI_REAL})::Cint
	Xₜ = [Vector{T}(undef, n - τ) for _ in 1:info.outputs]
	code = @ccall $(info.indicator)(n::Cint, Pₜ::Ref{Ptr{TI_REAL}}, opt::Ref{TI_REAL}, Xₜ::Ref{Ptr{TI_REAL}})::Cint
	validate && checkexit(code)
	Xₜ |> matrix
end

"""
$(TYPEDSIGNATURES)
"""
function tip(name::Symbol, Pₜ::AbstractVecOrMat{T}, opt::AbstractVector{T}=T[], val::M=missing; validate::Bool=VALIDATE) where {T<:TI_REAL, M}
	tip(ti_find_indicator(name), Pₜ, opt, val; validate=validate)
end

"""
$(TYPEDSIGNATURES)
"""
function tip(name::Symbol, Pₜ::AbstractVector{<:AbstractVector{T}}, opt::AbstractVector{T}=T[], val::M=missing; validate::Bool=VALIDATE) where {T<:TI_REAL, M}
	tip(ti_find_indicator(name), Pₜ, opt, val; validate=validate)
end

"""
$(TYPEDSIGNATURES)
"""
function tip(info::TI_INFO, Pₜ::AbstractVecOrMat{T}, opt::AbstractVector{T}=T[], val::M=missing; validate::Bool=VALIDATE) where {T<:TI_REAL, M}
	tip(info, nestedvector(Pₜ), opt, val; validate=validate)
end

"""
$(TYPEDSIGNATURES)
Compute TI indicators (padded)
"""
function tip(info::TI_INFO, Pₜ::AbstractVector{<:AbstractVector{T}}, opt::AbstractVector{T}=T[], val::M=missing; validate::Bool=VALIDATE) where {T<:TI_REAL, M}
	Xₜ = ti(info, Pₜ, opt; validate=validate)
	pad = size(Xₜ, 1) - length(first(Pₜ)) + 1
	PaddedView(val, Xₜ, (pad:size(Xₜ, 1), 1:size(Xₜ, 2)))
end
