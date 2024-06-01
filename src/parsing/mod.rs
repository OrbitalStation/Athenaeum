modules! { stmt expr comment }

peg::parser! {
    grammar parse() for str {

        // ****************** GENERIC ******************
        rule __whitespace() = [' ' | '\t' | '\n']
        rule _ = quiet!{__whitespace()*}
        rule __ = quiet!{__whitespace()+}

        rule __unbox <T> (e: rule <Box <T>>) -> T
            = x:e() { *x }

        rule __letter() = ['a'..='z' | 'A'..='Z']
        rule __digit() = ['0'..='9']
        rule ident() -> String
            = x:$(__letter() (__letter() / __digit())*)
        {?
            if ["type"].contains(&x) {
                Err("expected an identifier, not a keyword")
            } else {
                Ok(x.to_string())
            }
        }

        // ****************** Type ******************
        rule expr_type() -> Box <Expr>
            = "type" __ expr:(__ty_product() / __ty_sum())
        {
            Box::new(Expr::Type(expr))
        }

        rule __ty_product() -> TypeExpr
            = fields:(__ty_product_field() ++ (_ "*" _)) (_ "*" _)?
        {
            TypeExpr::ShortProduct(fields)
        }

        rule __ty_product_field() -> TypeProductField
            = name:ident() _ "::" _ ty:ty()
        {
            TypeProductField {
                name,
                ty
            }
        }

        rule __ty_sum() -> TypeExpr
            = variants:(__ty_sum_variant() ++ (_ "+" _)) (_ "+" _)?
        {
            TypeExpr::FullSum(variants)
        }

        rule __ty_sum_variant() -> TypeSumVariant
            = name:ident() attached:__ty_sum_variant_attached()?
        {
            TypeSumVariant {
                name,
                attached
            }
        }

        rule __ty_sum_variant_attached() -> Type
            = __ ty:ty() { ty }

        rule ty() -> Type
            = expr()

        // ****************** Expr ******************
        rule __expr_ident() -> Box <Expr>
            = ident:ident()
        {
            Box::new(Expr::Ident(Ident {
                ident
            }))
        }

        rule __expr_parenthesised() -> Box <Expr>
            = "(" _ e:expr() _ ")"
        {
            Box::new(Expr::Parenthesised(e))
        }

        rule __expr_call() -> Box <Expr>
            = seq:(__unbox(<__expr()>) ++ __) _
        {
            Box::new(if seq.len() == 1 {
                seq.into_iter().next().unwrap()
            } else {
                Expr::Call(Call {
                    seq
                })
            })
        }

        rule __expr() -> Box <Expr>
            = __expr_ident()
            / __expr_parenthesised()
            / expr_type()

        pub rule expr() -> Box <Expr>
            = __expr_call()

        // ****************** Stmt ******************
        rule __stmt_tab_lines()
            = (("\t" / "    ") [^ '\n']* "\n") / __

        rule stmt() -> Stmt
            = name:ident() _ "=" _ body:$([^ '\n']* "\n" __stmt_tab_lines()*)
        {?
            Ok(Stmt {
                name,
                body: expr(body).map_err(|_| "err parsing body")?
            })
        }

        pub rule stmts() -> Vec <Stmt>
            = _ stmts:(stmt() ** _) _
        {
            stmts
        }

    }
}

pub fn parse(code: &str) -> Result <Vec <Stmt>, peg::error::ParseError <peg::str::LineCol>> {
    parse::stmts(code)
}
