use ndarray::Array;
use ndarray_rand::RandomExt;
use ndarray_rand::rand_distr::Uniform;

use std::fs::File;
use std::io::Write;
use std::env;

use rand::{Rng, SeedableRng, rngs::StdRng};

const N: usize = 512;

fn main() {
    let args: Vec<String> = env::args().collect();

    let seed: u64 = args[1].trim()
                      .parse()
                      .expect("Wanted a number");

    let mut rng = StdRng::seed_from_u64(seed);

    let a = Array::random_using((N, N), Uniform::new(0.0, 1.0), &mut rng);
    let b = Array::random_using((N, N), Uniform::new(0.0, 1.0), &mut rng);

    let c = a.dot(&b);

    let mut rng_file_id = rand::thread_rng();

    let filename = format!("output-{}.txt", rng_file_id.gen_range(0, 1000000));

    let mut output = File::create(filename).expect("Unable to create file");

    for line in &c {
        write!(&mut output, "{:?}", line).expect("Unable to write line");
        write!(&mut output, "\n").expect("Unable to write newline");
    }
}
