extern crate rand;

use rand::random;

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
    print!("N = {}\n", N);
    let mut a: [[f64; N]; N] = [[0.0; N]; N];
    let mut b: [[f64; N]; N] = [[0.0; N]; N];
    let mut c: [[f64; N]; N] = [[0.0; N]; N];

    for i in 0..N {
        for j in 0..N {
            a[i][j] = random();
            b[i][j] = random();
        }
    }

    matrix_multiply(&a, &b, &mut c);
}
