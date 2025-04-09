module TulipIndicators

using TulipIndicators_jll
using PaddedViews
using DocStringExtensions: TYPEDSIGNATURES
using DispatchDoctor

export ti, tip, ti_show
export tc, tc_show

const VALIDATE = true # globally toggles ti input validation and exit code checks

@stable default_mode="warn" begin

include("base/base.jl")
include("base/util.jl")

include("tc/util.jl")
include("tc/array.jl")

include("ti/util.jl")
include("ti/array.jl")
# include("ti/table.jl")

end

end
