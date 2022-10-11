"""
TulipIndicators.jl Indicator Tables.jl Interface.
"""

"""
Tables.jl compatible `ti` call.

After applying `mapping` to tulip's input name list for the selected indicator, columns are selected as inputs by name.

If the input names to be selected don't exist in the table or contain duplicates, inputs are selected
sequentially starting from `col`.

After computing the indicator, the output is converted to the input Table type `T` with the column names set to the tulip's output list.
"""
function ti(name::Symbol, tableₜ::T, opt::AbstractVector{TI_REAL}=TI_REAL[]; validate::Bool=true, pad::Bool=true, padval::Union{Missing, TI_REAL}=missing, mapping::AbstractVector=[:real=>:close], indexcol::Integer=1, col::Integer=indexcol+1) where T
	info = ti_find_indicator(name)
	d = ti_info(info)
	inputs = replace(d[:inputs], mapping...)
	outputs = d[:outputs]

	cols = Tables.columns(tableₜ)
	names = collect(Symbol, Tables.columnnames(cols))

	if issubset(inputs, names) && unique(inputs) == length(inputs)
		sel = indexin(inputs, names)
	else
		sel = col:length(inputs)+1
	end

	Pₜ = [Tables.getcolumn(cols, i) for i in sel]
	Xₜ = ti(info, Pₜ, opt; validate=validate, pad=pad, padval=padval) |> tomatrix
	indextable = T(names[indexcol] => Tables.getcolumn(cols, indexcol))
	hcat(indextable, T(Tables.table(Xₜ; header=outputs)))
end

