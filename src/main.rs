fn main() -> Result <(), Box <dyn std::error::Error>> {
    let code = std::fs::read_to_string("code.aa")? + "\n";
    let without_comments = athenaeum::parsing::remove_comments(code);
    let parsed_stmts = athenaeum::parsing::parse(&without_comments)?;
    println!("{parsed_stmts:#?}");
    Ok(())
}
