```
* Consensus: do it how it is and then will fix it later
* Need to firstly check it in its current state









* FIXME: OVERHAUL TYPECLASSES + USER-CREATED TYPES










* Why not merge separate-line type decl and the function decl?
* I.e. `add = fn x: T, y: T, z: T -> ...`
* Because that would be ugly, since it pollutes the space and is difficult to read,
*   but most importantly it would hide the return type from the end user,
*   since there is no place for it to be placed
* It would also introduce inconsistency between type decl for functions and for scalars,
*   since the latter would be typed on a separate line or inline(i.e. `someConst : SomeType = ...`)
* So no
* But we could do fn decl *also* inline, like so: `add : Add a a => a -> a = fn a b -> a + b`
* This approach does not have such drawbacks, but it is just a simplification of the separate-line form,
*   so the latter way of writing is preferred because of increased readability

* Tab-indented lines are concatenated to the main line as-is

* Rust's `()` type is Athenaeum's `Unit`
* To obtain value of `Unit` one may use `pass`

add : Add a a => a -> a -> a -> a
add : Add T 
add = fn x y z -> x + y + z

* FIXME: finish
WrappedIf = fn a -> .inner : a *
ifFn = fn cond _thenKeyword then _elseKeyword else -> case cond
    Yes => new WrappedIf 

* Deprecated, not like this
* Should be a function on lists and other collections
* Sort.sortA = Sort.quicksort Sort.Ascending
* Sort.sortD = Sort.quicksort Sort.Descensing

* After operator unpacking, `:fnName` calls fn with that name from
*   the module from which the type of the last provided argument originates from
errHandlingExample : IO Unit
errHandlingExample = Err "someError"
    :or { Err 10 }
    :err { x + 17 }
    :unwrapErr { println "{x}" }

* Why not `let` or `var` instead of `val`?
* `var` is no good since it is used commonly in other languages to define mutable variables
*     (hence the name - *var*iables)
* `let` is less obvious but the main reason is that "let" is a verb and not a noun,
*     and a common convention in programming is that verbs are functions
* Because of that it also reads strangely: `let name be... er, no, equals some value...`
* Instead of `name equals value`
* That's a minor point, but it's at least something
* `val` is used in languages like Kotlin and Scala so it won't be new to people
* (Also some fellow Haskellers may confuse `let` with Haskell's `let ... in`,
*     which is incorrect since it is actually Haskell's `... <- ...` in `do`-blocks)
greet : IO !Unit
greet = do
    println "Hello, what's your name?"
    name = scanln?
    println "Hello, {name}!"

`:map` wouldn't have required `:` if `Iterator`'s members were in scope
forFn : Iterator i => Monad m => i -> ((Iterator i).Elem -> m Unit) -> m Unit
forFn = fn iterator fun -> iterator :map fun |> monadicJoin

* Does not work like this, it is instead a cunning little mechanism built-in to `do` (kinda)
* Make it work like this
* An asterisk(`*`) is an operator that when applied to a monad
*   demonadifies the expression by reading it in the line above using `val`(kinda)
* `a, b := *b, *a + *b` below translates to:
* `__b = b` (Haskell's `__b <- b`)
* `__a = a`
* `a, b := __b, __a + __b`
fibonacci : Positive Int a => a -> a
fibonacci = fn n -> do
    a = state 1
    b = state 1
    for 1..n fn _ -> do
        a, b := b, a + b
    return b

factorial : Positive Int a => a -> a
factorial = fn n -> do
    result = state 1
    for 1..n fn i -> do
        result :*= i
    return result

factorial' = fn n -> do
    result = state 1
    i = state 1
    while { i <= n } do
        result :*= i
        i :+= 1
    return result

factorial'' = rec factorial'' -> fn n -> if n < 2 then 1 else n * factorial'' (n - 1)

double : Num a => [av == bv] => (av : a) -> (bv : a) -> a
double = fn a b -> a + b

createObj = fn p -> new Pokemon (p :id) (p :name) (p :abilities)

* Custom from-literal conversion

`A * B * C` == `Tup A <| Tup B <| Tup C Unit`

* Comments start with `*` followed by ` `, `{tab}` or `{newline}` (i.e. by a whitespace), not just an asterisk

* Combination of pipes to achieve Haskell's backticks
* if (isAuthor |>and<| isRecent) |>or<| isAdmin then ...

* The old Athenaeum's code(uses `& |` instead of `&& ||` or `and or`):
* if (isAuthor & isRecent) | isAdmin) then ...

* The actual Athenaeum's code:
* if (isAuthor and isRecent) or isAdmin then ...


* Explicit is better than implicit, even if it leads to some minor ugliness
* Also it's better to not add extra syntactic sugar for it is a mental burden
* BAD IDEA, especially now that we have `{ ... }` vvv
* `fn -> ...`, i.e. `fn` without the arg name is syntactic sugar for `fn _ -> ...`

* println "{xcode '1B'}[32mHello, world!{xcode '1B'}[0m"
* println "{Terminal :Out :ANSIEC :color 'green'}Hello, world!{Terminal :Out :ANSIEC :reset}"
* println "{color 'green'}Hello, world!{reset}"
* where
*   * ANSIEC = American National Standards Institute Escape Code
*   in Terminal :Out :ANSIEC *

* Good idea, already in the language vvv
* Maybe do `a :b :c` instead of `a |> :b |> :c`, i.e. make `:` do two jobs simultaneously

* When a class is defined *OR* instantiated it imports all its members into the scope
* Example:
Wrapper = .inner : Int32 *
instance MyDisplay Wrapper
    display = fn self fmt -> ...
    display2 = out fn self fmt -> ...
* `display` and `display2` are available in this scope
* `display` is not public and `display2` is

* [x, x * x for x in range(0, 100)]
0..<100 :map { x, x * x } :to List

* Fun fact - `:len` with Russian keyboard layout is `Ждут`

* 100 doors
main : IO Unit
main = do
    * Indexing starts at 1 btw
    * Why? Because it is natural
    * 0-based languages treat indexes as if they are offsets, which is incorrect
    *     since that logic applies to pointers and not to arrays and other collections
    doors = state <| [No] :repeat 100
    for 1..100 fn i -> do
        for (i<..100 :stepBy i) fn j -> do
           doors[j] := not doors[j]

    for (doors :iter :enumerate) fn i, door -> do
        * `'` symbols can be used to denote string literal inside of a string template
        println "Door {i} is {if door then 'open' else 'closed'}"

MyBool =
    .Yes : Unit +
    .No  : Unit +

main : IO !Unit
main = do
    * String concatenation uses `++` instead of `+` for `s1 ++ s2` != `s2 ++ s1`
    code = AA.FileSystem.readFile "code.aa" ++ newline
        |> Athenaeum.Parsing.removeComments
        |> Athenaeum.Parsing.parse?
    println "{debug code}"
    return Ok pass

for (dict :items) fn k, v -> println "{k}={v}"

* Python's `open("code.aa").read()`
open? "code.aa" :readAll?
readFile? "code.aa"

somethings
    :filter { x :count > 10 }
    :quicksortBy { x :count }
    :map { x :name }

add = fn a b c ->
    a + b + c

```
