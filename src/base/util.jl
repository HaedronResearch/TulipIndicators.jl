"""
Common Utilities
"""

"""
$(TYPEDSIGNATURES)
Check the exit code of `ti` and `tc` calls.
"""
function checkexit(code::Cint)
	code == TI_OKAY && return
	code == TI_INVALID_OPTION && throw(ArgumentError("Invalid Option Error"))
	code == TI_OUT_OF_MEMORY && throw(OutOfMemoryError("Out of Memory Error"))
	throw(ErrorException("Error of Unknown Cause"))
end

"""
$(TYPEDSIGNATURES)
Prepend padding to each vector in an array of vectors.
"""
function prependpadding!(Pₜ::AbstractVector{T}, τ::Integer, val) where T<:AbstractVector
	padding = fill(val, τ)
	for i in 1:length(Pₜ)
		prepend!(Pₜ[i], padding)
	end
end

"""
$(TYPEDSIGNATURES)
Convert matrix to vector of vectors, using the method described here:
https://discourse.julialang.org/t/converting-a-matrix-into-an-array-of-arrays/17038
"""
@inline tovectors(Pₜ::AbstractMatrix) = [pₜ[:] for pₜ in eachcol(Pₜ)]

"""
$(TYPEDSIGNATURES)
Convert vector of vectors to matrix.
"""
@inline tomatrix(Pₜ::AbstractVector{T}) where T<:AbstractVector = reduce(hcat, Pₜ)

