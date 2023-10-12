using TulipIndicators
using Test
# The tests are to test the julia interface, not correctness of the C computations

@testset "array,multi_input,no_options" begin
	let n = 10
		soln = fill(2., n)[:, :]

		ohlc_nvec = [zeros(n), ones(n), -ones(n), zeros(n)]
		@test ti(:tr, ohlc_nvec[2:end]) == soln    # nested vector interface

		ohlc_mat = ohlc_nvec |> TulipIndicators.matrix
		@test ti(:tr, ohlc_mat[:, 2:end]) == soln # matrix interface
	end
end

# using Tables
# coleq(t1, t2, col) = Tables.getcolumn(Tables.columns(t1), col) == Tables.getcolumn(Tables.columns(t2), col)
# @testset "table,multi_input,no_options" begin
# 	let n = 10
# 		soln = fill(2., n)[:, :]
# 		ohlc_nvec = [zeros(n), ones(n), -ones(n), zeros(n)]
# 		ohlc_mat = ohlc_nvec |> TulipIndicators.matrix

# 		ohlc_mtable = Tables.table(ohlc_mat; header=[:open, :high, :low, :close])
# 		@test coleq(ti(:tr, ohlc_mtable; index=nothing), Tables.table(soln; header=[:tr]), :tr) # no index

# 		ohlc_imat = hcat(collect(1:n), ohlc_mat)
# 		ohlc_imtable = Tables.table(ohlc_imat; header=[:index, :open, :high, :low, :close])
# 		outtable = ti(:tr, ohlc_imtable)
# 		solntable = Tables.table(hcat(collect(1:n), soln); header=[:index, :tr])
# 		@test coleq(outtable, solntable, :index) && coleq(outtable, solntable, :tr) # with index
# 	end
# end

@testset "array,single_input,options" begin
	let n = 10, τ = 5
		close_vec = cumsum(ones(n))
		soln = vcat(ones(τ), close_vec[1:5])
		opt = [float(τ)]
		@test ti(:lag, close_vec, opt)[:, 1] == soln[τ+1:end] # vector no padding
		@test parent(tip(:lag, close_vec, opt, 1.0)[:, 1]) == soln    # vector with padding
	end
end
