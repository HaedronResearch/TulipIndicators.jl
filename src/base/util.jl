"""
$(TYPEDSIGNATURES)
Check the exit code of `ti` and `tc` calls.
"""
function checkexit(code::Cint)
	code == TI_OKAY && return
	code == TI_INVALID_OPTION && throw(ArgumentError("Invalid Tulip Option"))
	code == TI_OUT_OF_MEMORY && throw(OutOfMemoryError())
	throw(ErrorException("Error of Unknown Cause"))
end

"""
$(TYPEDSIGNATURES)
Return view of matrix/vector as vector of vectors, using the method described here:
https://discourse.julialang.org/t/converting-a-matrix-into-an-array-of-arrays/17038
"""
@inline nestedvector(Pₜ::AbstractVecOrMat) = collect(eachcol(Pₜ))

"""
$(TYPEDSIGNATURES)
Convert vector of vectors to matrix.
"""
@inline matrix(Pₜ::AbstractVector{<:AbstractVector}) = stack(Pₜ)

