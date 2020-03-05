// https://play.rust-lang.org/?version=stable&mode=debug&edition=2018&gist=e62972d1ada878cfda92ca2d6173a519

extern crate rand;
use rand::Rng;

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
    println!("N = {}", N);

    let mut rng = rand::thread_rng();

    let mut m_a = Vec::<Vec<f64>>::with_capacity(N);
    for _ in 0..N {
        m_a.push((0..N).map(|_| {rng.gen_range(0.0, 10.0)}).collect());
    }

    let mut m_b = Vec::<Vec<f64>>::with_capacity(N);
    for _ in 0..N {
        m_b.push((0..N).map(|_| {rng.gen_range(0.0, 10.0)}).collect());
    }

    let mut m_c = Vec::<Vec<f64>>::with_capacity(N);
    for _ in 0..N {
        m_c.push(vec![0.0; N]);
    }

    matrix_multiply(&m_a, &m_b, &mut m_c);

    // println!("m_c = {:?}", m_c);
}
