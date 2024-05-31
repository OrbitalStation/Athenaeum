fn main() -> Result <(), Box <dyn std::error::Error>> {
    let code = std::fs::read_to_string("code.aa")? + "\n";
    let parsed_stmts = athenaeum::parsing::parse(&code)?;
    println!("{parsed_stmts:#?}");
    Ok(())
}
