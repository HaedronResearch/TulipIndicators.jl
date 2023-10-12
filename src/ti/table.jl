using Tables

"""
$(TYPEDSIGNATURES)
Tables.jl compatible `ti` call.

After applying `mapping` to tulip's input name list for the selected indicator,
columns are selected as inputs by name.

After computing the indicator, the output is converted to the input Table type `T` with the column names set to the tulip's output list.
"""
function ti(name::Symbol, tableₜ::T, opt::AbstractVector{TI_REAL}=TI_REAL[]; validate::Bool=VALIDATE, mapping::AbstractVector=[:real=>:close], index::Union{Integer,Symbol,Nothing}=1) where {T}
	validate && ((Tables.istable(T) && Tables.columnaccess(T)) || throw("input must be a Tables.jl column accessible table"))
	info = ti_find_indicator(name)
	infoj = ti_info(info)
	inputs = replace(infoj[:inputs], mapping...)
	outputs = infoj[:outputs]

	cols = Tables.columns(tableₜ)
	names = Tables.columnnames(cols)
	Pₜ = [Tables.getcolumn(cols, name) for name in names if name in inputs]
	validate && length(Pₜ) == length(inputs) || throw("input must have columns names that match the expected input names: $inputs")

	Xₜ = ti(info, Pₜ, opt; validate=validate)
	tbl = Tables.table(Xₜ; header=outputs)

	if index |> !isnothing
		if index isa Integer
			index = names[index]
		end
		idx = Tables.getcolumn(cols, index)[end - size(Xₜ, 1) + 1: end]
		itbl = Tables.table(idx[:, :]; header=[index])
		tbl = hcat(itbl, tbl)
	end
	tbl |> Tables.materializer(T)
end

# """
# $(TYPEDSIGNATURES)
# Tables.jl compatible `tip` call.
# """
# function tip(name::Symbol, tableₜ::T, opt::AbstractVector{TI_REAL}=TI_REAL[], val::M=missing; validate::Bool=VALIDATE, mapping::AbstractVector=[:real=>:close], index::Union{Integer,Symbol}=1) where {M, T}
# 	validate && ((Tables.istable(T) && Tables.columnaccess(T)) || throw("input must be a Tables.jl column accessible table"))

# 	info = ti_find_indicator(name)
# 	d = ti_info(info)
# 	inputs = replace(d[:inputs], mapping...)
# 	outputs = d[:outputs]

# 	cols = Tables.columns(tableₜ)
# 	names = Tables.columnnames(cols)
# 	Pₜ = [Tables.getcolumn(cols, name) for name in names if name in inputs]
# 	Xₜ = tip(info, Pₜ, opt, val; validate=validate)

# 	if !isa(index, Symbol)
# 		index = names[index]
# 	end
# 	it = Tables.table(Tables.getcolumn(cols, index);
# 		header=[index isa Symbol ? index : names[index]]
# 	)
# 	id = Tables.table(Xₜ; header=outputs)

# 	reduce(hcat, Tables.materializer(T).([it, id]))
# end
