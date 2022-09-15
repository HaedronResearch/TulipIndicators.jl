module TulipIndicators

using TulipIndicators_jll
using Tables
using DocStringExtensions: TYPEDSIGNATURES

export ti, ti_info
export tc, tc_info

include("base/base.jl")
include("base/util.jl")

include("tc/util.jl")
include("tc/array.jl")

include("ti/util.jl")
include("ti/array.jl")
include("ti/table.jl")

end
