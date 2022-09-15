module TulipIndicators

using TulipIndicators_jll
using Tables
using DocStringExtensions: TYPEDSIGNATURES

export ti, ti_info
export tc, tc_info

include("base.jl")
include("util.jl")
include("ti.jl")
include("ti_table.jl")
include("tc.jl")

end
