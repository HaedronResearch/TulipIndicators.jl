"""
$(TYPEDSIGNATURES)
Vector or Matrix `ti`.
"""
@inline function ti(name::Symbol, Pₜ::AbstractVecOrMat{TI_REAL}, opt::AbstractVector{TI_REAL}=TI_REAL[]; validate::Bool=VALIDATE)
	ti(ti_find_indicator(name), Pₜ, opt; validate=validate)
end

"""
$(TYPEDSIGNATURES)
Vector or Matrix `ti`.
"""
@inline function ti(info::ti_indicator_info, Pₜ::AbstractVecOrMat{TI_REAL}, opt::AbstractVector{TI_REAL}=TI_REAL[]; validate::Bool=VALIDATE)
	ti(info, nestedvector(Pₜ), opt; validate=validate)
end

"""
$(TYPEDSIGNATURES)
Nested Vector `ti`.
"""
@inline function ti(name::Symbol, Pₜ::AbstractVector{<:AbstractVector{TI_REAL}}, opt::AbstractVector{TI_REAL}=TI_REAL[]; validate::Bool=VALIDATE)
	ti(ti_find_indicator(name), Pₜ, opt; validate=validate)
end

"""
$(TYPEDSIGNATURES)
Nested Vector `ti`.
This is the only method that calls libindicators code.
"""
function ti(info::ti_indicator_info, Pₜ::AbstractVector{<:AbstractVector{TI_REAL}}, opt::AbstractVector{TI_REAL}=TI_REAL[]; validate::Bool=VALIDATE)
	validate && ti_validate_inputs(Pₜ, opt, info)
	n = length(Pₜ[1])
	τ = @ccall $(info.start)(opt::Ref{TI_REAL})::Cint
	Xₜ = [zeros(n - τ) for i in 1:info.outputs]
	code = @ccall $(info.indicator)(n::Cint, Pₜ::Ref{Ptr{TI_REAL}}, opt::Ref{TI_REAL}, Xₜ::Ref{Ptr{TI_REAL}})::Cint
	validate && checkexit(code)
	Xₜ |> matrix
end

"""
$(TYPEDSIGNATURES)
Vector or Matrix `tip` (padded `ti`).
"""
@inline function tip(name::Symbol, Pₜ::AbstractVecOrMat{TI_REAL}, opt::AbstractVector{TI_REAL}=TI_REAL[], val::M=missing; validate::Bool=VALIDATE) where {M}
	tip(ti_find_indicator(name), Pₜ, opt, val; validate=validate)
end

"""
$(TYPEDSIGNATURES)
Vector or Matrix `tip` (padded `ti`).
"""
@inline function tip(info::ti_indicator_info, Pₜ::AbstractVecOrMat{TI_REAL}, opt::AbstractVector{TI_REAL}=TI_REAL[], val::M=missing; validate::Bool=VALIDATE) where {M}
	tip(info, nestedvector(Pₜ), opt, val; validate=validate)
end

"""
$(TYPEDSIGNATURES)
Nested Vector `tip` (padded `ti`).
"""
@inline function tip(name::Symbol, Pₜ::AbstractVector{<:AbstractVector{TI_REAL}}, opt::AbstractVector{TI_REAL}=TI_REAL[], val::M=missing; validate::Bool=VALIDATE) where {M}
	tip(ti_find_indicator(name), Pₜ, opt, val; validate=validate)
end

# """
# $(TYPEDSIGNATURES)
# Nested Vector `tip` (padded `ti`).
# """
# function tip(info::ti_indicator_info, Pₜ::AbstractVector{<:AbstractVector{TI_REAL}}, opt::AbstractVector{TI_REAL}=TI_REAL[], val::M=missing; validate::Bool=VALIDATE) where {M}
# 	Xₜ = ti(info, Pₜ, opt; validate=validate)
# 	padding = fill(val, length(Pₜ[1]) - size(Xₜ, 1), size(Xₜ, 2))
# 	vcat(padding, Xₜ)
# end

"""
$(TYPEDSIGNATURES)
Nested Vector `tip` (padded `ti`).
"""
function tip(info::ti_indicator_info, Pₜ::AbstractVector{<:AbstractVector{TI_REAL}}, opt::AbstractVector{TI_REAL}=TI_REAL[], val::M=missing; validate::Bool=VALIDATE) where {M}
	Xₜ = ti(info, Pₜ, opt; validate=validate)
	pad = size(Xₜ, 1) - length(Pₜ[1]) + 1
	PaddedView(val, Xₜ, (pad:size(Xₜ, 1), 1:size(Xₜ, 2)))
end
