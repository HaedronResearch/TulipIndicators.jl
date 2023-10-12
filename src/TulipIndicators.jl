module TulipIndicators

using TulipIndicators_jll
using PaddedViews
using DocStringExtensions: TYPEDSIGNATURES

export ti, tip, ti_info
export tc, tc_info

const VALIDATE = true # globally toggles ti input validation and exit code checks

include("base/base.jl")
include("base/util.jl")

include("tc/util.jl")
include("tc/array.jl")

include("ti/util.jl")
include("ti/array.jl")
# include("ti/table.jl")

end
