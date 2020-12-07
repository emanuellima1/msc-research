using ExperimentalDesign, StatsModels, GLM, DataFrames, Distributions, Random, CSV

const seed = 42

function y(x)
    env_flags = ""
    seed_str = string(seed)

    for i in 1:length(x)
        if x[i] > 0
            env_flags = "-C passes=" * replace(names(x)[i], "_" => "-") * " " * env_flags
        end
    end

    env_flags = "-C lto=off -C no-prepopulate-passes -C passes=name-anon-globals " * env_flags

    # cmd = `timeout -s9 30s cargo build --manifest-path ../../Benchmarks/heap_vec_nolib/Cargo.toml`
    cmd = `timeout -s9 30s cargo build --manifest-path ../../Benchmarks/stack_nolib/Cargo.toml`
    # cmd = `timeout -s9 30s cargo build --manifest-path ../../Benchmarks/heap_ndarray_nolib/Cargo.toml`
    # cmd = `timeout -s9 30s cargo build --manifest-path ../../Benchmarks/heap_ndarray_dot/Cargo.toml`

    println(env_flags)
    println(cmd)

    ENV["RUSTFLAGS"] = env_flags

    try
        run(cmd)
    catch error
        println(error)
        return -1.0
    end

    exec_time = @elapsed run(`../../Benchmarks/heap_vec_nolib/target/debug/matrix-multiply-raw $seed_str`)

    return exec_time
end

model = @formula(0 ~ adce + always_inline + argpromotion + break_crit_edges + constmerge + 
dce + deadargelim + die + dse + globaldce + globalopt + gvn + indvars + inline + instcombine + 
ipsccp + jump_threading + lcssa + licm + loop_deletion + loop_extract + loop_extract_single + 
loop_reduce + loop_rotate + loop_simplify + loop_unroll + loop_unroll_and_jam + loop_unswitch + 
loweratomic + lowerinvoke + lowerswitch + mem2reg + memcpyopt + mergefunc + mergereturn + 
partial_inliner + prune_eh + reassociate + reg2mem + sroa + sccp + simplifycfg + sink + strip + 
strip_dead_debug_info + strip_dead_prototypes + strip_debug_declare + strip_nondebug + tailcallelim)

design = PlackettBurman(model)

repetitions = 15

# Screening
Random.seed!(192938)
design.matrix[!, :response] = y.(eachrow(design.matrix[:, collect(design.factors)]))
screening_results = copy(design.matrix)

for i = 1:repetitions
    design.matrix[!, :response] = y.(eachrow(design.matrix[:, collect(design.factors)]))
    append!(screening_results, copy(design.matrix))
end

CSV.write("screening_experiment.csv", screening_results)

# Random design
Random.seed!(8418172)

design_distribution = DesignDistribution(NamedTuple{getfield.(model.rhs, :sym)}(
    repeat([DiscreteNonParametric([-1, 1],
                                  [0.5, 0.5])], 49)))

random_design = rand(design_distribution, 40)

random_design.matrix[!, :response] = y.(eachrow(random_design.matrix[:, collect(keys(random_design.factors))]))
random_results = copy(random_design.matrix)

for i = 1:repetitions
    random_design.matrix[!, :response] = y.(eachrow(random_design.matrix[:, collect(keys(random_design.factors))]))
    append!(random_results, copy(random_design.matrix))
end

CSV.write("random_experiment.csv", random_results)
