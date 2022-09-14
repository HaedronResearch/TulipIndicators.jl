"""
TulipIndicators.jl Candle Interface.
"""

tc_version() = (@ccall libindicators.tc_version()::Ptr{Cchar}) |> unsafe_string
tc_build() = @ccall libindicators.tc_build()::Clong
tc_candle_count() = @ccall libindicators.tc_candle_count()::Cint

"""
$(TYPEDSIGNATURES)
Return information about the indicator as a `tc_candle_info` struct.
"""
@inline function tc_find_candle(name::Symbol)
	(@ccall libindicators.tc_find_candle(name::Ptr{Cchar})::Ptr{tc_candle_info}) |> unsafe_load
end

"""
$(TYPEDSIGNATURES)
Compute Tulip candle with name tc_`name`.
"""
function tc(name::Symbol, Pₜ::AbstractVector{Vector{Cdouble}}, opt::AbstractVector{Cdouble}=Cdouble[]; validate::Bool=true)
	info = tc_find_candle(name)
	n = length(Pₜ[1])
	Xₜ = [zeros(n) for i in 1:length(Pₜ)]
	code = @ccall $(info.candle)(n::Cint, Pₜ::Ptr{Ptr{Cdouble}}, opt::Ptr{Cdouble}, Xₜ::Ptr{Ptr{Cdouble}})::Cint
	validate && checkexit(code)
	Xₜ
end

"""
$(TYPEDSIGNATURES)
`tc` call that takes and returns matrices.
"""
@inline function tc(name::Symbol, Pₜ::AbstractMatrix{Cdouble}, opt::AbstractVector{Cdouble}=Cdouble[]; validate::Bool=true)
	tc(name, tovectors(Pₜ), opt; validate=validate) |> tomatrix
end

