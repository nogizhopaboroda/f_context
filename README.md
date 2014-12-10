f_context
=========

Simple functional programming library for CoffeeScript.

1. [Overview](#overview)
2. [Installation](#installation)
3. [Modules](#modules)
4. [Pattern matching](#pattern-matching)
5. [Destructuring](#destructuring)
6. [Guards](#guards)
7. [Real life examples](#real-life-examples)
8. [How it works](#how-it-works)
9. [Testing](#testing)
10. [Benchmark](#benchmark)

Overview
--------

Those who had some experience with functional programming languages such as
[Erlang](http://erlang.org) did notice its excessive pattern matching abilities:

```erlang
fact(0) -> 1
fact(N) -> N * fact(N - 1)
```

This is a classical implementation of factorial compilation using patter matching.
Now you can use code it exactly the same style, but in CoffeeScript using **f_context** wrapper function. For example:

```erlang
f_context ->
    fact(0) -> 1
    fact(N) -> N * fact(N - 1)
```

[See more examples](https://github.com/nogizhopaboroda/f_context/blob/master/example/example.coffee).

Try it yourself:

```shell
git clone git@github.com:nogizhopaboroda/f_context.git
cd f_context/example
open example.html
```

If you still think there's incompliance or don't understand why it should work, you can read [how it works](#how-it-works) before.

Disclaimer
----------

This doesn't contain any hacks and evals whatsoever.

Functions in examples are prefixed with `f_` so it is easy to distinguish
between functional and imperative counterparts, i.e. `f_` prefix is not enforced.


Installation
------------

You can link directly to this repo:

```html
<script src="https://raw.githubusercontent.com/nogizhopaboroda/f_context/master/dist/f_context.js"></script>
```

Or you can clone the repo instead: the release resides in `dist/f_context.js` file.

```shell
git clone git@github.com:nogizhopaboroda/f_context.git
```

Using npm:
```shell
npm install f_context
```
Then
```coffee
f_context = require('f_context')
```

### Modules

`f_context` returns object with generated functions by default, so you can use it
like this:

```erlang
examples = f_context ->

  f_range(I) ->
    f_range(I, 0, [])

  f_range(I, I, Accum) -> Accum
  f_range(I, Iterator, Accum) ->
    f_range(I, Iterator + 1, [Accum..., Iterator])

examples.f_range(10) #=> [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
```

Using `module` directive you can specify the name of the object module
that will contain your functions. As a result module will be available in global
scope (`window` or `global`):

```erlang
f_context ->
  module("examples")

  f_range(I) ->
    f_range(I, 0, [])

  f_range(I, I, Accum) -> Accum
  f_range(I, Iterator, Accum) ->
    f_range(I, Iterator + 1, [Accum..., Iterator])

examples.f_range(10) #=> [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
```

Features
--------

### Pattern matching

[Wikipedia](https://en.wikipedia.org/wiki/Pattern_matching)

Example with one argument being pattern matched:

```erlang
f_context ->
    matching_example_1("foo") -> "foo matches"
    matching_example_1("bar") -> "bar matches"
    matching_example_1(Str)   -> "nothing matches, argument: #{Str}"
```

The same, but with two arguments:

```erlang
f_context ->
    matching_example_2("foo", "bar") -> "foo and bar matches"
    matching_example_2("bar", "bla") -> "bar and bla matches"
    matching_example_2("bar", "bar") -> "bar and bar matches"
    matching_example_2(Str, Str2)    -> "no matching pairs, arguments: #{Str}, #{Str2}"
```


### Destructuring

[Wikipedia](http://en.wikipedia.org/wiki/Assignment_(computer_science)#Parallel_assignment)

```erlang
f_context ->
    test_destruct_1([Head, Tail...]) -> {Head, Tail}
    test_destruct_1_1([Head, Head1, Tail...]) -> {Head, Head1, Tail}
```

```erlang
f_context ->
    test_destruct_2([Head..., Last]) -> {Head, Last}
    test_destruct_2_1([Head..., Last, Last1]) -> {Head, Last, Last1}
```

```erlang
f_context ->
    test_destruct_3([Head, Middle..., Last]) -> {Head, Middle, Last}
    test_destruct_3_1([Head, Head2, Middle..., Last, Last2]) -> {Head, Head2, Middle, Last, Last2}
```

### Guards

[Wikipedia](http://en.wikipedia.org/wiki/Guard_(computer_science))

Use `where(%condition%)` syntax to define a guard.
For example: here is a function that produces fibonacci sequence, implemented without guards:

```erlang
f_context ->
  fibonacci_range(Count) ->
    fibonacci_range(Count, 0, [])

  fibonacci_range(Count, Count, Accum) -> Accum

  fibonacci_range(Count, 0, Accum) ->
    fibonacci_range(Count, 1, [Accum..., 0])

  fibonacci_range(Count, 1, Accum) ->
    fibonacci_range(Count, 2, [Accum..., 1])

  fibonacci_range(Count, Iterator, [AccumHead..., A, B]) ->
    fibonacci_range(Count, Iterator + 1, [AccumHead..., A, B, A + B])
  ```

Using guards you can make it considerably shorter:

```erlang
f_context ->
    fibonacci_range(Count) ->
      fibonacci_range(Count, 0, [])

    fibonacci_range(Count, Count, Accum) -> Accum

    fibonacci_range(Count, Iterator, Accum) where(Iterator is 0 or Iterator is 1) ->
      fibonacci_range(Count, Iterator + 1, [Accum..., Iterator])

    fibonacci_range(Count, Iterator, [AccumHead..., A, B]) ->
      fibonacci_range(Count, Iterator + 1, [AccumHead..., A, B, A + B])
```


Real life examples
------------------

Here are reduce and qsort functions implemented using *f_context*:

```erlang
f_context ->
  f_reduce(List, F) ->
    f_reduce(List, F, 0)

  f_reduce([], _, Memo) -> Memo

  f_reduce([X, List...], F, Memo) ->
    f_reduce(List, F, F(X, Memo))
```

```erlang
f_context ->
  f_qsort([]) -> []
  f_qsort([Pivot, Rest...]) ->
    [f_qsort((X for X in Rest when X < Pivot))..., Pivot, f_qsort((Y for Y in Rest when Y >= Pivot))...]
```

How it works
------------


```erlang
fact(0) -> 1
fact(N) -> N * fact(N - 1)
```

If you compile this from CoffeeScript to JS, you'll get this:

```js
fact(0)(function() {
    return 1;
});

fact(N)(function() {
    return N * fact(N - 1);
});
```

As you can see this is absolutely valid, and that means you can evaluate it.
Though now it probably will throw an error.

But if you wrap it in a function, like that:

```erlang
function_wrapper ->
    fact(0) -> 1
    fact(N) -> N * fact(N - 1)
```

You'll get:

```js
function_wrapper(function() {
    fact(0)(function() {
      return 1;
    });
    fact(N)(function() {
      return N * fact(N - 1);
    });
});
```

Now `fact` evaluates inside `function_wrapper` that can analyse the argument function, then modify and extend it before execution. Like this:

```js
var fact_stub = function(){ return function(){}; },
    N_stub;
(function(fact, N) {
    fact(0)(function() {
      return 1;
    });
    fact(N)(function() {
      return N * fact(N - 1);
    });
})(fact_stub, N_stub);
```

Ok, now argument function executes without an errors. What's next?

We can mark `N_stub` as a "variable" and design `fact_stub` so it looks at itself arguments and generate a part of future wanted `fact`.

```js
var N_stub = function(){};
N_stub.type = "variable";
N_stub.name = "N";

var fact_stub = function(argument){
    return function(fact_computing_function){
        if(typeof argument === "function" && argument.type === "variable"){
            var generated_part = "var " + argument.name + " = arguments[0];" +
                + "return (" + fact_computing_function + ")()";
            return generated_part;
        } else {
            var generated_part = "if(arguments[0] === " + argument + "){" +
                + "return (" + fact_computing_function + ")()" +
                + "}";
            return generated_part;
        }
    };
}
```

So, generated `fact` will look like this:
```js
if(arguments[0] === 0){
  return (function () {
    return 1;
  })();

var N = arguments[0];
return (function () {
    return N * f_fact(N - 1);
})();
```


Ok, now `function_wrapper` has all data to build up new `fact` function with required checks and assign it to a key of an object (`window` for example). That's how it works it a few words.

And if you still don't understand how it works, you can read [the sources](https://github.com/nogizhopaboroda/f_context/blob/master/src/f_context.coffee)

Testing
-------

```shell
gulp test
```

Benchmarking
------------

```shell
gulp bench
```

Other
-----

Thanks a lot to [yegortimoschenko](https://github.com/yegortimoschenko) for translation and correction of this document.
