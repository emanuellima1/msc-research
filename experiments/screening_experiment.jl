using ExperimentalDesign, StatsModels, GLM, DataFrames, Distributions, Random, CSV

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
columns = vcat(flags, ["Dummy 1", "Dummy 2", "Dummy 3", "Response"])

repetitions = 15

# Screening
Random.seed!(192938)
design.matrix[!, :response] = y.(eachrow(design.matrix[:, collect(design.factors)]))
screening_results = copy(design.matrix)

for i = 1:repetitions
    design.matrix[!, :response] = y.(eachrow(design.matrix[:, collect(design.factors)]))
    append!(screening_results, copy(design.matrix))
end

rename!(screening_results, columns)

CSV.write("screening_matrix.csv", screening_results)

# Random design
Random.seed!(8418172)
design_distribution = DesignDistribution(DiscreteNonParametric([-1, 1], [0.5, 0.5]), 16)
random_design = rand(design_distribution, 10)

random_design.matrix[!, :response] = y.(eachrow(random_design.matrix[:, :]))
random_results = copy(random_design.matrix)

for i = 1:repetitions
    random_design.matrix[!, :response] = y.(eachrow(random_design.matrix[:, :]))
    append!(random_results, copy(random_design.matrix))
end

columns_random = vcat(flags, ["Response"])

rename!(random_results, columns_random)

CSV.write("random_matrix.csv", random_results)
