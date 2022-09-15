"""
TulipIndicators.jl Base Candle Interface.
"""

"""
$(TYPEDSIGNATURES)
Return information about a candle as a `tc_candle_info` struct.
"""
@inline function tc_find_candle(name::Symbol)
	info = @ccall libindicators.tc_find_candle(name::Cstring)::Ptr{tc_candle_info}
	info == C_NULL && throw(ArgumentError("Invalid candle identififer"))
	unsafe_load(info)
end

"""
$(TYPEDSIGNATURES)
Return global information about the Tulip Candles install.
"""
function tc_info()::Dict{Symbol, Union{String, Clong, Cint}}
	Dict{Symbol, Union{String, Clong, Cint}}(
		:version => (@ccall libindicators.tc_version()::Cstring) |> unsafe_string,
		:build => (@ccall libindicators.tc_build()::Clong),
		:indicator_count => (@ccall libindicators.tc_candle_count()::Cint)
	)
end

"""
$(TYPEDSIGNATURES)
Return information about a candle.
"""
function tc_info(name::Symbol)::Dict{Symbol, Union{String, tc_set}}
	info = tc_find_candle(name)
	Dict{Symbol, Union{String, tc_set}}(
		:full_name => unsafe_string(info.full_name),
		:pattern => info.pattern
	)
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

"""
$(TYPEDSIGNATURES)
`tc` call that takes and returns matrices.
"""
@inline function tc(name::Symbol, Pₜ::AbstractMatrix{TC_REAL}, opt::AbstractVector{TC_REAL}=TC_REAL[]; validate::Bool=true)
	tc(name, tovectors(Pₜ), opt; validate=validate) |> tomatrix
end

