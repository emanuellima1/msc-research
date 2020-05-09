using Pkg
Pkg.add("StatsModels")
Pkg.add("Distributions")
Pkg.add("Random")
Pkg.add("GLM")
Pkg.add(PackageSpec(url = "https://github.com/phrb/ExperimentalDesign.jl/"))
Pkg.status()
Pkg.update()

using ExperimentalDesign, StatsModels, GLM, DataFrames, Distributions, Random

function y(x)
    env_flags = ""
    
    for i in 1:length(x)
        if x[i] > 0
            env_flags = "-C passes=" * flags[i] * " " * env_flags
        end
    end
    
    env_flags = "-C lto=off -C no-prepopulate-passes -C passes=name-anon-globals " * env_flags
    
    cmd = `cargo build --manifest-path ../heap_vec_nolib/Cargo.toml`
    
    println(env_flags)
    println(cmd)

    ENV["RUSTFLAGS"] = env_flags

    run(cmd)
    
    exec_time = @elapsed run(`../heap_vec_nolib/target/debug/matrix-multiply-raw`)
    
    return exec_time
end

design = PlackettBurman(16)

flags = ["constprop", "instcombine", "argpromotion", "jump-threading", "lcssa", "licm", "loop-deletion", "loop-extract", "loop-reduce", "loop-rotate", "loop-simplify", "loop-unroll", "loop-unroll-and-jam", "loop-unswitch", "mem2reg", "memcpyopt"]

# Random.seed!(192938)
# design.matrix[!, :response] = y.(eachrow(design.matrix[:, collect(design.factors)]))
# show(design.matrix, allrows = true, allcols = true)

# lm(design.formula, design.matrix)

# lm(term(:response) ~ sum(term.(design.factors)), design.matrix)

# Random.seed!(8418172)

# random_design_generator = RandomDesign(DiscreteNonParametric([-1, 1], [0.5, 0.5]), 6)
# random_design = rand(random_design_generator, 8)

# random_design[!, :response] = y.(eachrow(random_design[:, :]))
# random_design

# lm(random_design_generator.formula, random_design)

Random.seed!(2989476)

factorial_design = FullFactorial(fill([-1, 1], 6), explicit = true)
factorial_design.matrix[!, :response] = y.(eachrow(factorial_design.matrix[:, :]))

show(factorial_design.matrix, allrows = true, allcols = true)

println(lm(factorial_design.formula, factorial_design.matrix))
