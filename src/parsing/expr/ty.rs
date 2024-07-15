use super::*;

#[derive(Debug, Clone)]
pub enum TypeExpr {
    ShortProduct(Vec <TypeProductField>),
    FullSum(Vec <TypeSumVariant>)
}

#[derive(Debug, Clone)]
pub struct TypeProductField {
    pub name: Ident,
    pub ty: Type
}

#[derive(Debug, Clone)]
pub struct TypeSumVariant {
    pub name: Ident,
    pub attached: Option <Type>
}

pub type Type = Box <Expr>;
