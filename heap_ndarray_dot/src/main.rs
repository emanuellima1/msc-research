use ndarray::Array;
use ndarray_rand::RandomExt;
use ndarray_rand::rand_distr::Uniform;

const N: usize = 1024;

fn main() {
    let a = Array::random((N, N), Uniform::new(0.0, 1.0));
    let b = Array::random((N, N), Uniform::new(0.0, 1.0));

    //println!("{:8.4}", a.dot(&b));
}
