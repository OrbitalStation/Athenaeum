use crate::*;

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
        rule ident() -> Ident
            = x:$(__letter() (__letter() / __digit())*)
        {
            Ident {
                ident: x.to_string()
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

        /* FIXME:
        * First-pass collecting statements
        * Processing `in` statements
        * Collecting operator statements(`operator` is not a macro even though looks like one)
        * Building AST
        * Unfolding operators everywhere
        * Unfolding all the macros in each of the remaining statements
        * Processing AST
        */

        /* FIXME
        Read about the monads, use them(try Haskell) and understand them
        Read about parallel programming, use it(in Rust, Go, Haskell) and understand them
        ^ This all is necessary to improve language design
        */

        // ****************** Expr ******************
        rule __expr_ident() -> Box <Expr>
            = ident:ident()
        {
            Box::new(Expr::Ident(ident))
        }

        rule __expr_parenthesised() -> Box <Expr>
            = "(" _ e:expr() _ ")"
        {
            Box::new(Expr::Parenthesised(e))
        }

        rule __expr_call() -> Box <Expr>
            = seq:(__unbox(<__expr()>) ++ __)
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
            = __expr_parenthesised()
            / expr_type()
            / __expr_ident()

        pub rule expr() -> Box <Expr>
            = x:__expr_call() _ { x }

        // ****************** Stmt ******************
        rule __stmt_tab_lines()
            = (("\t" / "    ") [^ '\n']* "\n") / __

        rule __stmt_arg() -> Ident
            = __ name:ident() { name }

        rule stmt() -> Stmt
            = name:ident() args:__stmt_arg()* _ "=" _ body:$([^ '\n']* "\n" __stmt_tab_lines()*)
        {
            Stmt {
                name,
                args,
                body: expr(body).unwrap()
            }
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
