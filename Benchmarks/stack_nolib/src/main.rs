extern crate rand;

use rand::{Rng, SeedableRng, rngs::StdRng};

use std::fs::File;
use std::io::Write;
use std::env;

const N: usize = 512;

fn matrix_multiply(a: &[[f64; N]; N],
                   b: &[[f64; N]; N],
                   c: &mut[[f64; N]; N]) {
    for i in 0..N {
        for j in 0..N {
            for k in 0..N {
                c[i][j] += a[i][k] * b[k][j];
            }
        }
    }
}

fn main()
{
    let args: Vec<String> = env::args().collect();

    let seed: u64 = args[1].trim()
                      .parse()
                      .expect("Wanted a number");

    let mut rng = StdRng::seed_from_u64(seed);

    let mut a: [[f64; N]; N] = [[0.0; N]; N];
    let mut b: [[f64; N]; N] = [[0.0; N]; N];
    let mut c: [[f64; N]; N] = [[0.0; N]; N];

    for i in 0..N {
        for j in 0..N {
            a[i][j] = rng.gen_range(0.0, 1.0);
            b[i][j] = rng.gen_range(0.0, 1.0);
        }
    }

    matrix_multiply(&a, &b, &mut c);

    let mut rng_file_id = rand::thread_rng();

    let filename = format!("output-{}.txt", rng_file_id.gen_range(0, 1000000));

    let mut output = File::create(filename).expect("Unable to create file");

    for line in &c {
        write!(&mut output, "{:?}", line).expect("Unable to write line");
        write!(&mut output, "\n").expect("Unable to write newline");
    }
}
