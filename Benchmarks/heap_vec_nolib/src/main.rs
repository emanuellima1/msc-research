extern crate rand;

use rand::{Rng, SeedableRng, rngs::StdRng};

use std::fs::File;
use std::io::Write;

const N: usize = 512;

fn matrix_multiply(a: &Vec<Vec<f64>>,
                   b: &Vec<Vec<f64>>,
                   c: &mut Vec<Vec<f64>>) {
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
    let seed = 42;

    let mut rng = StdRng::seed_from_u64(seed);

    let mut m_a = Vec::<Vec<f64>>::with_capacity(N);
    for _ in 0..N {
        m_a.push((0..N).map(|_| {rng.gen_range(0.0, 1.0)}).collect());
    }

    let mut m_b = Vec::<Vec<f64>>::with_capacity(N);
    for _ in 0..N {
        m_b.push((0..N).map(|_| {rng.gen_range(0.0, 1.0)}).collect());
    }

    let mut m_c = Vec::<Vec<f64>>::with_capacity(N);
    for _ in 0..N {
        m_c.push(vec![0.0; N]);
    }

    matrix_multiply(&m_a, &m_b, &mut m_c);

    let mut rng_file_id = rand::thread_rng();

    let filename = format!("output-{}.txt", rng_file_id.gen_range(0, 100));

    let mut output = File::create(filename).expect("Unable to create file");

    for line in &m_a {
        write!(&mut output, "{:?}", line).expect("Unable to write line");
        write!(&mut output, "\n").expect("Unable to write newline");
    }
}
