use crate::*;

modules! { ty call }

#[derive(Debug, Clone)]
pub enum Expr {
    Type(TypeExpr),
    Parenthesised(Box <Expr>),
    Ident(Ident),
    Call(Call)
}
