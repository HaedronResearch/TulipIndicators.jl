module TulipIndicators

using TulipIndicators_jll
using DocStringExtensions

export ti, tc
export ti_info, tc_info

include("base.jl")
include("util.jl")
include("ti.jl")
include("tc.jl")

end
