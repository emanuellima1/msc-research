use ndarray::Array;
use ndarray_rand::RandomExt;
use ndarray_rand::rand_distr::Uniform;

fn main() {
    let a = Array::random((2000, 2000), Uniform::new(0., 10.));
    let b = Array::random((2000, 2000), Uniform::new(0., 10.));

    println!("{:8.4}", a.dot(&b));
}
