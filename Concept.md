```
in AAA
in AAA.BBB
in AAA.BBB as CCC
in AAA *
in AAA * except bbb
in AAA only bbb, ccc
in :BBB *

fizzbuzz :: F_Out ()
fizzbuzz = 1..100 |> :map genFB
where
    genFB n = choose n mod 3, n mod 5
        Yes, Yes => println "FizzBuzz"
        Yes, No  => println "Fizz"
        No, Yes  => println "Buzz"
        No, No   => println "{x}"

greet :: F_Out
greet = println "Hello, what's your name?"
    >> mlet name = getLine
    >> println "Hello, {name}!"

* 1 or 2 arguments only
operator("l10") _+_ = add

html htmlElem =
    <div class="flex">
        ...
    </div>

double :: Num a => [av == bv] => a -> a -> a
double a b = a + b

Either a b = type Left a + Right b
in :Either only Left, Right

createObj = new Pokemon p.id p.name p.abilities

* Custom from-literal conversion and literal suffixes

`A * B * C` == `Tup A <| Tup B <| Tup C ()`

* Comments start with `* `, not just an asterisk

```
