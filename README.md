# Autotuning the LLVM IR for Rust Programs

LLVM autotuning experiments using matrix multiplication in Rust.

## Study phases

### Phase 1

- [ERAD 2020](https://eradsp2020.ncc.unesp.br/)
- [Article](Articles/ERAD_2020.pdf)

Small experiment with 4 flags that demonstrated the impact that LLVM IR flag selection can have on the performance of Rust code.  
Won the 2nd place on the scientific initiation track of the conference.  

### Phase 2

#### Work in Progress

- [Expansion of the search space](Scripts/Which_Flags/which_flags.csv)
- [Screening and Random Sampling experiments](Experiments/Phase2/experiments.jl)
- Statistical analysis of the results

## Interesting links

- [Rustc Codegen](https://doc.rust-lang.org/rustc/codegen-options/index.html)
- [LLVM Passes](http://llvm.org/docs/Passes.html)
- [Rustc Book](https://rustc-dev-guide.rust-lang.org/)

## Interesting commands

### List of rustc codegen options:

```bash
rustc -C help
```

## Financed by

- [Hewlett Packard Enterprise](www.hpe.com)
