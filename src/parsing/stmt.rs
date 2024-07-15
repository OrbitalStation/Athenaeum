use crate::*;
use super::*;

#[derive(Debug, Clone)]
pub struct Stmt {
    pub name: Ident,
    pub args: Vec <Ident>,
    pub body: Box <Expr>
}
