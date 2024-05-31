#[macro_export]
macro_rules! modules {
    ($( $mod:ident )*) => {$(
        mod $mod;
        pub use $mod::*;
    )*};
}

pub mod parsing;
