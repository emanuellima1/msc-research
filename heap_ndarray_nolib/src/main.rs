use ndarray::Array;
use ndarray::Dim;
use ndarray_rand::RandomExt;
use ndarray_rand::rand_distr::Uniform;

const N: usize = 1024;

fn matrix_multiply(a: &Array<f64, Dim<[usize; 2]>>,
                   b: &Array<f64, Dim<[usize; 2]>>,
                   c: &mut Array<f64, Dim<[usize; 2]>>) {
    for i in 0..N {
        for j in 0..N {
            for k in 0..N {
                c[[i, j]] += a[[i, k]] * b[[k, j]];
            }
        }
    }
}

fn main() {
    let a = Array::random((N, N), Uniform::new(0.0, 1.0));
    let b = Array::random((N, N), Uniform::new(0.0, 1.0));
    let mut c = Array::random((N, N), Uniform::new(0.0, 1.0));

    matrix_multiply(&a, &b, &mut c);

    // println!("{:8.4}", a.dot(&b));
}
