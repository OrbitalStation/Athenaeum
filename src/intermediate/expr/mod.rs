modules! { ty }

#[derive(Debug, Clone)]
pub struct Expr {
    pub kind: ExprKind
}

#[derive(Debug, Clone)]
pub enum ExprKind {
    TypeDefinition(TypeDefRef)
}
