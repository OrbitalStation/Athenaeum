use super::*;

#[derive(Debug, Clone)]
pub struct Stmt {
    pub name: String,
    pub body: Box <Expr>
}
