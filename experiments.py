import pandas as pd
import subprocess
import os

N_EXPERIMENTS = 30

# Dictionary to initialize the DataFrame
df_init_dict = {"Execution Time": [0.0 for i in range(N_EXPERIMENTS)],
                "Flag 1": [0.0 for i in range(N_EXPERIMENTS)],
                "Flag 2": [0.0 for i in range(N_EXPERIMENTS)],
                "Flag 3": [0.0 for i in range(N_EXPERIMENTS)],
                "Flag 4": [0.0 for i in range(N_EXPERIMENTS)]}

# DataFrame that will store the result of the experiments
heap_vec_nolib_results = pd.DataFrame(data=df_init_dict)

# Dictionary of compilation times
compilation_dict = {"Flag 1": 0.0, "Flag 2": 0.0, "Flag 3": 0.0, "Flag 4": 0.0}

# Dictionary of flags
flags_dict = {"Flag 1": "-C lto=off -C no-prepopulate-passes",
              "Flag 2": "",
              "Flag 3": "",
              "Flag 4": ""}

# print(heap_vec_nolib_results)

# Set the RUSTFLAGS env variable with the flags for the experiment
os.environ["RUSTFLAGS"] = flags_dict["Flag 1"]

compile = subprocess.Popen(["cargo build"], cwd="./heap_vec_nolib/", shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, universal_newlines=True)
output, errors = compile.communicate()
print(output)
print(errors)
