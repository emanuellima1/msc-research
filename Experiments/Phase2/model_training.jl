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

    cmd = `timeout -s9 30s cargo build --manifest-path ../../Benchmarks/heap_vec_nolib/Cargo.toml`

    println(env_flags)
    println(cmd)

    ENV["RUSTFLAGS"] = env_flags

    try
        run(cmd)
    catch error
        println(error)
        return -1.0
    end

    exec_time = @elapsed run(`../../Benchmarks/heap_vec_nolib/target/debug/matrix-multiply-test $seed_str`)

    return exec_time
end

results = CSV.read("Results/screening_experiment_new_space.csv", DataFrame)

rename!(results, replace.(names(results), "-" => "_"))
rename!(results, replace.(names(results), "R" => "r"))
rename!(results, replace.(names(results), "Dummy " => "dummy_"))

screening_model = @formula(response ~ adce + always_inline + argpromotion + break_crit_edges + constmerge + 
dce + deadargelim + die + dse + globaldce + globalopt + gvn + indvars + inline + instcombine + 
ipsccp + jump_threading + lcssa + licm + loop_deletion + loop_extract + loop_extract_single + 
loop_reduce + loop_rotate + loop_simplify + loop_unroll + loop_unroll_and_jam + loop_unswitch + 
loweratomic + lowerinvoke + lowerswitch + mem2reg + memcpyopt + mergefunc + mergereturn + 
partial_inliner + prune_eh + reassociate + reg2mem + sroa + sccp + simplifycfg + sink + strip + 
strip_dead_debug_info + strip_dead_prototypes + strip_debug_declare + strip_nondebug + 
tailcallelim + dummy1 + dummy2 + dummy3 + dummy4 + dummy5 + dummy6 + dummy7 + dummy8 + dummy9 + dummy10)

model = @formula(response ~ adce + always_inline + argpromotion + break_crit_edges + constmerge + 
dce + deadargelim + die + dse + globaldce + globalopt + gvn + indvars + inline + instcombine + 
ipsccp + jump_threading + lcssa + licm + loop_deletion + loop_extract + loop_extract_single + 
loop_reduce + loop_rotate + loop_simplify + loop_unroll + loop_unroll_and_jam + loop_unswitch + 
loweratomic + lowerinvoke + lowerswitch + mem2reg + memcpyopt + mergefunc + mergereturn + 
partial_inliner + prune_eh + reassociate + reg2mem + sroa + sccp + simplifycfg + sink + strip + 
strip_dead_debug_info + strip_dead_prototypes + strip_debug_declare + strip_nondebug + tailcallelim)

screening_fit = lm(screening_model, results)
println(screening_fit)

fit = lm(model, results)
println(fit)

design_distribution = DesignDistribution(NamedTuple{getfield.(model.rhs, :sym)}(
    repeat([DiscreteNonParametric([-1, 1],
                                  [0.5, 0.5])], 49)))

random_design = rand(design_distribution, 500_000)
random_design.matrix[!, :prediction] = predict(fit, random_design.matrix)

best_index = findmin(random_design.matrix[!, :prediction])
best_prediction = DataFrame(select(random_design.matrix, Not(:prediction))[best_index[2], :])
println(best_prediction)
println(best_index)

best_prediction[!, :response] = y.(eachrow(best_prediction))
CSV.write("best_prediction.csv", best_prediction)
