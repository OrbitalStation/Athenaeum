use crate::*;
use super::*;

#[derive(Debug, Clone)]
pub struct TypeDefinition {
    pub either: TypeEither
}

#[derive(Debug, Clone)]
pub enum TypeEither {
    Sum(TypeSum),
    Product(TypeProduct)
}

#[derive(Debug, Clone)]
pub struct TypeSum {
    pub variants: Vec <TypeSumVariant>
}

#[derive(Debug, Clone)]
pub struct TypeProduct {
    pub fields: Vec <TypeProductField>
}

#[derive(Debug, Clone)]
pub struct TypeSumVariant {
    pub name: Ident,
    pub attached_ty: Option <Type>
}

#[derive(Debug, Clone)]
pub struct TypeProductField {
    pub name: Ident,
    pub ty: Type
}

#[derive(Debug, Clone)]
pub struct Type {
    pub ty_ref: TypeDefRef,

    /// [] for `i32`, [`Bool`] for `Vec Bool`
    pub generic_args: Vec <Expr>
}

#[derive(Debug, Copy, Clone)]
pub struct TypeDefRef {
    pub type_list_index: usize
}

static mut TYPE_LIST: Vec <TypeDefinition> = Vec::new();
