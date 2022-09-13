using Clang.Generators
using TulipIndicators_jll

cd(@__DIR__)

include_dir = normpath(TulipIndicators_jll.artifact_dir, "include")
options = load_options(joinpath(@__DIR__, "generator.toml"))

args = get_default_args()
push!(args, "-I$include_dir")

headers = [joinpath(include_dir, f) for f in readdir(include_dir) if endswith(f, ".h")]
ctx = create_context(headers, args, options)
build!(ctx)
