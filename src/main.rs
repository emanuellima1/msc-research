use ndarray::Array;
use ndarray_rand::RandomExt;
use ndarray_rand::rand_distr::Uniform;

fn main() {
    let dim = 1000;
    
    let a = Array::random((dim, dim), Uniform::new(0., 10.));
    let b = Array::random((dim, dim), Uniform::new(0., 10.));

    println!("{:8.4}", a.dot(&b));
}
