using TulipIndicators
using Test
# The tests are to test the julia interface, not correctness of the C computations

# no options
let
	n = 10
	ohlc_arr = [zeros(n), ones(n), -ones(n), zeros(n)]
	ohlc_mat = hcat(ohlc_arr...)
	sol = fill(2., n)
	@test ti(:tr, ohlc_arr[2:end])[1] == sol       # array interface
	@test ti(:tr, ohlc_mat[:, 2:end]) == sol[:, :] # matrix interface
end

# options
let
	n = 10
	τ = 5
	close_arr = [cumsum(ones(n))]
	sol = vcat(ones(τ), close_arr[1][1:5])

	@test ti(:lag, close_arr, [float(τ)]; pad=true, padval=1.0)[1] == sol # with padding
	@test ti(:lag, close_arr, [float(τ)]; pad=false)[1] == sol[τ+1:end]   # no padding
end

