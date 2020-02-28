# Matrix Multiply Test  

Simple matrix multiply in Rust to serve as an experiment to LLVM autotuning.

## Interesting flags

```bash
rustc --edition=2018 --crate-name matrix_multiply_test main.rs --crate-type bin --emit=llvm-ir,link -C debuginfo=0 -L dependency=/home/emanuel/Documentos/mm/target/debug/deps --extern ndarray=/home/emanuel/Documentos/mm/target/debug/deps/libndarray-30276bc906ea8492.rlib --extern ndarray_rand=/home/emanuel/Documentos/mm/target/debug/deps/libndarray_rand-7489760779d5a8e9.rlib
```

## Interesting links

- [Rustc Codegen](https://doc.rust-lang.org/rustc/codegen-options/index.html)
- [LLVM Passes](http://llvm.org/docs/Passes.html)

## Interesting commands

### List of rustc codegen options:

```bash
rustc -C help
```
