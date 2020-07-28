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
columns = vcat(flags, ["dummy 1", "dummy 2", "dummy 3"])

rename!(design.matrix, columns)

# Screening
Random.seed!(192938)

for i = 1:15
    design.matrix[!, :response] = y.(eachrow(design.matrix[:, collect(design.factors)]))
end

design.matrix[!, :mean] = mean.(eachrow(design.matrix[:, 20:35]))

CSV.write("screening_matrix.csv", design.matrix)

# Random design
Random.seed!(8418172)
random_design_generator = RandomDesign(DiscreteNonParametric([-1, 1], [0.5, 0.5]), 6)
random_design = rand(random_design_generator, 8)

for i = 1:15
    random_design[!, :response] = y.(eachrow(random_design[:, :]))
end

CSV.write("random_matrix.csv", random_design)
