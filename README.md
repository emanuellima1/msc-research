# Autotuning the LLVM IR for Rust Programs

LLVM autotuning experiments using matrix multiplication in Rust.

## Study phases

### Phase 1

- [ERAD 2020](https://eradsp2020.ncc.unesp.br/)
- [Paper](Papers/ERAD_2020.pdf)

Small experiment with 4 flags that demonstrated the impact that LLVM IR flag selection can have on the performance of Rust code.
Won 2nd place on the undergraduate research track of the conference.

### Phase 2

- [Expansion of the search space](Scripts/Which_Flags/which_flags.csv)
- [Screening and Random Sampling experiments](Experiments/Phase2/experiments.jl)
- Statistical analysis of the results

### Phase 3

- [Qualification Exam Text](Text/quali.pdf)

## Interesting links

- [Rustc Codegen](https://doc.rust-lang.org/rustc/codegen-options/index.html)
- [LLVM Passes](http://llvm.org/docs/Passes.html)
- [Rustc Book](https://rustc-dev-guide.rust-lang.org/)

## Interesting commands

### List of rustc codegen options:

```bash
rustc -C help
```
