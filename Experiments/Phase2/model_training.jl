using ExperimentalDesign, StatsModels, GLM, DataFrames, Distributions, Random, CSV

function y(x)
    env_flags = ""

    for i in 1:length(x)
        if x[i] > 0
            env_flags = "-C passes=" * replace(names(x)[i], "_" => "-") * " " * env_flags
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

results = CSV.read("screening_matrix.csv", DataFrame)

rename!(results, replace.(names(results), "-" => "_"))
rename!(results, replace.(names(results), "R" => "r"))
rename!(results, replace.(names(results), "Dummy " => "dummy_"))

screening_model = @formula(response ~ constprop + instcombine + argpromotion + jump_threading +
                           lcssa + licm + loop_deletion + loop_extract + loop_reduce +
                           loop_rotate + loop_simplify + loop_unroll + loop_unroll_and_jam +
                           loop_unswitch + mem2reg + memcpyopt + dummy_1 + dummy_2 + dummy_3)

model = @formula(response ~ constprop + instcombine + argpromotion + jump_threading +
                 lcssa + licm + loop_deletion + loop_extract + loop_reduce +
                 loop_rotate + loop_simplify + loop_unroll + loop_unroll_and_jam +
                 loop_unswitch + mem2reg + memcpyopt)

screening_fit = lm(screening_model, results)
println(screening_fit)

fit = lm(model, results)
println(fit)

design_distribution = DesignDistribution(NamedTuple{getfield.(model.rhs, :sym)}(
    repeat([DiscreteNonParametric([-1, 1],
                                  [0.5, 0.5])], 16)))

random_design = rand(design_distribution, 500_000)
random_design.matrix[!, :prediction] = predict(fit, random_design.matrix)

best_index = findmin(random_design.matrix[!, :prediction])
best_prediction = DataFrame(select(random_design.matrix, Not(:prediction))[best_index[2], :])
println(best_prediction)
println(best_index)

best_prediction[!, :response] = y.(eachrow(best_prediction))
CSV.write("best_prediction.csv", best_prediction)
