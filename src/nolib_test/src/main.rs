extern crate rand;

use rand::random;

const N: usize = 100;

fn matrix_multiply(a: [[f64; N]; N],
                   b: [[f64; N]; N],
                   mut c: [[f64; N]; N]) -> [[f64; N]; N] {
    for i in 0..N {
        for j in 0..N {
            for k in 0..N {
                c[i][j] += a[i][k] * b[k][j];
            }
        }
    }

    c
}

fn main()
{
    print!("N = {}\n", N);
    let mut m_a: [[f64; N]; N] = [[0.0; N]; N];
    let mut m_b: [[f64; N]; N] = [[0.0; N]; N];
    let mut c: [[f64; N]; N] = [[0.0; N]; N];

    for i in 0..N {
        for j in 0..N {
            m_a[i][j] = random();
            m_b[i][j] = random();
        }
    }

    let a = m_a;
    let b = m_b;

    matrix_multiply(a, b, c);
}
