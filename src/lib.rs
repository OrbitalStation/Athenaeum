#[macro_export]
macro_rules! modules {
    ($( $mod:ident )*) => {$(
        mod $mod;
        pub use $mod::*;
    )*};
}

modules! { ident }

pub mod parsing;
pub mod intermediate;
