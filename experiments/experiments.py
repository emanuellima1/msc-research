#!/usr/bin/env python3

import pandas as pd
import numpy as np
import subprocess
import os

N_EXPERIMENTS = 1
N_FLAGS = 4

# Dictionary to initialize the DataFrame
results_dict = {"Flag 1": [0.0 for i in range(N_EXPERIMENTS)],
                "Flag 2": [0.0 for i in range(N_EXPERIMENTS)],
                "Flag 3": [0.0 for i in range(N_EXPERIMENTS)],
                "Flag 4": [0.0 for i in range(N_EXPERIMENTS)]}

# Dictionary of compilation times
compilation_dict = {"Flag 1": 0.0, "Flag 2": 0.0, "Flag 3": 0.0, "Flag 4": 0.0}

# Dictionary of flags
flags_dict = {"Flag 1": "-C lto=off -C no-prepopulate-passes -C passes=name-anon-globals",
              "Flag 2": "-C lto=off -C no-prepopulate-passes -C passes=name-anon-globals -C opt-level=3",
              "Flag 3": "-C lto=off -C no-prepopulate-passes -C passes=name-anon-globals -C passes=loop-simplify -C passes=mem2reg",
              "Flag 4": "-C lto=off -C no-prepopulate-passes -C passes=name-anon-globals -C passes=instcombine -C passes=memcpyopt"}

names_dict = {"Flag 1": "No Flags",
              "Flag 2": "Baseline",
              "Flag 3": "loop-implify + mem2reg",
              "Flag 4": "instcombine + memcpyopt"}

target_program = "./heap_vec_nolib/"

results_df = pd.DataFrame({"flags": [],
                           "algorithm": [],
                           "compile_time": [],
                           "execution_time": [],
                           "id": []})

# For each set of flags
for flag in flags_dict.keys():
    # Set the RUSTFLAGS env variable with the flags for the experiment
    os.environ["RUSTFLAGS"] = flags_dict[flag]

    print(f"Set RUSTFLAGS to {os.environ.get('RUSTFLAGS')}")

    # Run experiments
    print("Starting the experiments...")
    for i in range(N_EXPERIMENTS):
        # Compile with RUSTFLAGS
        print("Compiling...")
        compile = subprocess.Popen(["cargo build"],
                                cwd=target_program,
                                shell=True,
                                stdout=subprocess.PIPE,
                                stderr=subprocess.PIPE,
                                universal_newlines=True)

        # Compile everytime, so we get a sense of the variance of compilation time
        # Store the compilation time
        compilation_dict[flag] = compile.communicate()[1].split()[-1]
        print(f"Done. It took {compilation_dict[flag]}s to compile.")

        print(f"Performing experiment {i}...")
        run = subprocess.Popen(["/usr/bin/time -f '%e' ./matrix-multiply-raw"],
                               cwd="{}/target/debug/".format(target_program),
                               shell=True,
                               stdout=subprocess.PIPE,
                               stderr=subprocess.PIPE,
                               universal_newlines=True)

        results_dict[flag][i] = float(run.communicate()[1])

        # Append new row to dataframe
        results_df = results_df.append(pd.DataFrame({"flags": [flags_dict[flag]],
                                                     "algorithm": [target_program],
                                                     "compile_time": [compilation_dict[flag]],
                                                     "execution_time": [results_dict[flag][i]],
                                                     "id": [names_dict[flag]]}))

        # Store intermediate results, prevent losing all data in a crash
        results_df.to_csv("results.csv", index = False, header = True)

    print("Done")


# DataFrame that will store the result of the experiments
heap_vec_nolib_results = pd.DataFrame(data=results_dict)
#heap_vec_nolib_results.to_csv("results.csv", index=False, header=True)
results_df.to_csv("results.csv", index = False, header = True)

# Statistics
print("\nThe mean execution time of each set of flags are: ")
mean_time = heap_vec_nolib_results.mean(axis=0).to_frame().rename(columns={0: 'Mean'})
print(mean_time)

print("\nThe standard deviations of the measurements are: ")
std_time = heap_vec_nolib_results.std(axis=0).to_frame().rename(columns={0: 'Std. Dev.'})
print(std_time)

print("\nThe standard deviation of the mean (standart error) is: ")
std_error = std_time.applymap(lambda x: x/np.sqrt(N_EXPERIMENTS)).rename(columns={'Std. Dev.': 'Std. Error'})
print(std_error)

# Writing to file
with open("summary.txt", "w") as file:
    file.write("The mean execution time of each set of flags are: \n")
    file.write(str(mean_time))
    file.write("\n\nThe standard deviations of the measurements are: \n")
    file.write(str(std_time))
    file.write("\n\nThe standard deviations of the mean (standart errors) are: \n")
    file.write(str(std_error))
    file.write("\n\nThe compilation times are: \n")
    file.write(str(compilation_dict))
