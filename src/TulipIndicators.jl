module TulipIndicators

using TulipIndicators_jll
using DocStringExtensions: TYPEDSIGNATURES

export ti, ti_info
export tc, tc_info

include("base.jl")
include("util.jl")
include("ti.jl")
include("tc.jl")

end
