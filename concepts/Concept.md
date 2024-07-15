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
*   since the latter would be typed on a separate line or inline(i.e. `someConst :: SomeType = ...`)
* So no
* But we could do fn decl *also* inline, like so: `add :: Add a a => a -> a = fn a b -> a + b`
* This approach does not have such drawbacks, but it is just a simplification of the separate-line form,
*   so the latter way of writing is preferred because of increased readability

* Tab-indented lines are wrapped in parentheses in all cases except for
*     `:` and `:?` built-in sugar plus operators whose precedence is low enough (e.g. `_,_`)
* Then they are concatenated to the main line

* Rust's `()` type is Athenaeum's `Unit`
* To obtain value of `Unit` one may use `empty`

add :: Add a a => a -> a -> a -> a
add :: Add T 
add = fn x y z -> x + y + z

* FIXME: finish
WrappedIf = fn T -> type .inner :: T
ifFn = fn cond _thenKeyword then _elseKeyword else -> cond |> fn
    Yes -> new WrappedIf 

* Deprecated, not like this
* Should be a function on lists and other collections
* Sort.sortA = Sort.quicksort Sort.Ascending
* Sort.sortD = Sort.quicksort Sort.Descensing

* After operator unpacking, `:fnName` calls fn with that name from
*   the module from which the type of the last provided argument originates from
errHandlingExample :: F_IO Unit
errHandlingExample = Err "someError"
    :or (fn -> Err 10)
    :mapErr (fn x -> x + 17)
    :unwrapErr (fn x -> println "{x}")

* Why not `let` or `var` instead of `val`?
* `var` is no good since it is used commonly in other languages to define mutable variables
*     (hence the name - *var*iables)
* `let` is less obvious but the main reason is that "let" is a verb and not a noun,
*     and a common convention in programming is that verbs are functions
* Because of that it also reads strangely: `let name be... er, no, equals some value...`
* Instead of `val name equals value`
* That's a minor point, but it's at least something
* `val` is used in languages like Kotlin and Scala so it won't be new to people
* (Also some fellow Haskellers may confuse `let` with Haskell's `let ... in`,
*     which is incorrect since it is actually Haskell's `... <- ...` in `do`-blocks)
greet :: F_IO !Unit
greet = do
    println "Hello, what's your name?"
    val name = ?getLine
    println "Hello, {name}!"

`:map` wouldn't have required `:` if `Iterator`'s members were in scope
forFn :: Iterator i => Monad m => i -> ((Iterator i).Elem -> m Unit) -> m Unit
forFn iterator fun = iterator :map fun |> monadicJoin

* Does not work like this, it is instead a cunning little mechanism built-in to `do` (kinda)
* Make it work like this
* An asterisk(`*`) is an operator that when applied to a monad
*   demonadifies the expression by reading it in the line above using `val`(kinda)
* `a, b := *b, *a + *b` below translates to:
* `val __b = b` (Haskell's `__b <- b`)
* `val __a = a`
* `a, b := __b, __a + __b`
fibonacci :: Positive Int a => a -> a
fibonacci = fn n -> stateful do
    val a = state 1
    val b = state 1
    for 1..n fn -> do
        a, b := b, a + b
    return b

factorial :: Positive Int a => a -> a
factorial = fn n -> stateful do
    val result = state 1
    for 1..n fn i -> do
        result :*= i
    return result

factorial' = fn n -> stateful do
    val result = state 1
    val i = state 1
    while (fn -> i <= n) do
        result :*= i
        i :+= 1
    return result

rec factorial'' = fn n -> if n < 2 then 1 else n * factorial'' (n - 1)

double :: Num a => array[av == bv] => (av :: a) -> (bv :: a) -> a
double = fn a b -> a + b

createObj = fn p -> new Pokemon p.id p.name p.abilities

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
* BAD IDEA vvv
* `fn -> ...`, i.e. `fn` without the arg name is syntactic sugar for `fn _ -> ...`

* println "{xcode.1B}[32mHello, world!{xcode.1B}[0m"
* println "{Terminal.Out.ANSIEC.color Terminal.Out.ANSIEC.green}Hello, world!{Terminal.Out.ANSIEC.reset}"
* println "{color green}Hello, world!{reset}"
* where
*   * ANSIEC = American National Standards Institute Escape Code
*   in Terminal.Out.ANSIEC *

* Maybe do `a :b :c` instead of `a |> :b |> :c`, i.e. make `:` do two jobs simultaneously

* When a class is defined *OR* instantiated it imports all its members into the scope
* Example:
Wrapper = type .inner :: Int32
instance MyDisplay Wrapper
    display = fn self fmt -> ...
    out display2 = fn self fmt -> ...
* `display` and `display2` are available in this scope
* `display` is not public and `display2` is

* [x, x * x for x in range(0, 100)]
0..<100 :map (fn x -> x, x * x) :collect List

* Fun fact - `:len` with Russian keyboard layout is `Ждут`

* 100 doors
main :: F_IO Unit
out main = stateful do
    * Indexing starts at 1 btw
    val doors = state <| array No :repeat 100
    for 1..100 fn i -> do
        for (i..100 :stepBy (i + 1)) fn j -> do
            * We can write like that because `State` monad implements `Index`
            *   if the underlying type does
            doors[j] := not doors[j]

    for (doors :iter :enumerate) fn i, door -> do
        * `'` symbols can be used to denote string literal inside of a string template
        println "Door {i} is {if door then 'open' else 'closed'}"

MyBool = type .Yes + .No

main :: F_IO !Unit
out main = do
    * String concatenation uses `++` instead of `+` for `s1 ++ s2` != `s2 ++ s1`
    val code = ?(?AA.FileSystem.readFile "code.aa" ++ newline
        |> Athenaeum.Parsing.removeComments
        |> Athenaeum.Parsing.parse)
    println "{debug code}"
    return Ok empty

for (dict :items) fn k, v -> println "{k}={v}"

* Python's `open("code.aa").read()`
?open "code.aa" :?readAll
?readFile "code.aa"

somethings
    :filter (fn x -> x :count > 10)
    :quicksortBy (fn a, b -> a :count > b :count)
    :map (fn x -> x :name)

add = fn a b c ->
    a + b + c

```
