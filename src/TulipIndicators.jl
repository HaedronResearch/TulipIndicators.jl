module TulipIndicators

using TulipIndicators_jll
using Tables
using DocStringExtensions: TYPEDSIGNATURES

export ti, ti_info
export tc, tc_info

include("base/base.jl")
include("base/util.jl")
include("ti/base.jl")
include("ti/table.jl")
include("tc/base.jl")

end
