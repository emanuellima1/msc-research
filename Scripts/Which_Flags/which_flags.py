#!/usr/bin/env python3

import subprocess
import pandas as pd
import os

# List of transformation passes
transform = ["adce", "always-inline", "argpromotion", "bb-vectorize", "block-placement",
             "break-crit-edges", "codegenprepare", "constmerge", "dce", "deadargelim",
             "deadtypeelim", "die", "dse", "function-attrs", "globaldce", "globalopt",
             "gvn", "indvars", "inline", "instcombine", "aggressive-instcombine",
             "internalize", "ipsccp", "jump-threading", "lcssa", "licm", "loop-deletion",
             "loop-extract", "loop-extract-single", "loop-reduce", "loop-rotate",
             "loop-simplify", "loop-unroll", "loop-unroll-and-jam", "loop-unswitch",
             "loweratomic", "lowerinvoke", "lowerswitch", "mem2reg", "memcpyopt", "mergefunc",
             "mergereturn", "partial-inliner", "prune-eh", "reassociate", "reg2mem", "sroa",
             "sccp", "simplifycfg", "sink", "strip", "strip-dead-debug-info", "strip-dead-prototypes",
             "strip-debug-declare", "strip-nondebug", "tailcallelim"]

results_dict = {}

target_program = "../heap_vec_nolib/"

# For each set of flags
for flag in transform:
    os.environ["RUSTFLAGS"] = f"-C lto=off -C no-prepopulate-passes -C passes=name-anon-globals -C passes={flag}"

    print(f"Set RUSTFLAGS to {os.environ.get('RUSTFLAGS')}")

    print("Starting the compilation...")
    compile = subprocess.Popen(["cargo build"],
                                cwd=target_program,
                                shell=True,
                                stdout=subprocess.PIPE,
                                stderr=subprocess.PIPE,
                                universal_newlines=True)

    if "unknown pass" in compile.communicate()[1] or compile.returncode != 0:
        print("Unknown pass")
        results_dict[flag] = "False"
    else:
        print(f"Done. It took {compile.communicate()[1].split()[-1]} to compile.")
        results_dict[flag] = f"True: {compile.communicate()[1].split()[-1]}"

    print("Removing binary...")
    compile = subprocess.Popen(["cargo clean"],
                                cwd=target_program,
                                shell=True,
                                stdout=subprocess.PIPE,
                                stderr=subprocess.PIPE,
                                universal_newlines=True)

    print("Done\n")

pd.DataFrame.from_dict(data=results_dict, orient='index').to_csv('which_flags.csv', header=False)
