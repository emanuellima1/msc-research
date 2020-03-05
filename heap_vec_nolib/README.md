# Matrix Multiply Raw
Random matrix multiply in Rust without linear algebra crates. It uses arbitrarily sized random matrixes allocated on the heap.

To compile and run without optimization, do the following on the root of the repository:
(It's very slow!)

```bash
cargo run
```

Optimized:

```bash
cargo run --release
```

This assumes you have Rust installed. If not, do it [here](https://rustup.rs/).
