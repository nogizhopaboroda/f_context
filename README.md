f_context
=========

Pattern matching and easy recursion library for CoffeeScript.


1. [Overview](#overview)

2. [Installation](#installation)

3. [Pattern matching](#pattern-matching)

4. [Destructuring](#destructuring)

5. [Guards](#guards)

6. [Modules](#modules)

7. [Real life examples](#real-life-examples)

8. [How it works](#how-it-works)

9. [Testing](#testing)

10. [Benchmark](#benchmark)



##### OVERVIEW:
Тем, кто сталкивался с [функциональными языками программирования](https://ru.wikipedia.org/wiki/Функциональное_программирование) наверняка знакома такая конструкция:
  ```erlang
  fact(0) -> 1
  fact(N) -> N * fact(N - 1)
  ```
Это один и классических примеров ФП - вычисление факториала. Теперь это можно делать и на coffeescript'е с библиотекой f_context, просто добавляя "f_context ->" и немного табов, например:
  ```erlang
  f_context ->
    fact(0) -> 1
    fact(N) -> N * fact(N - 1)
  ```
Посмотреть больше примеров можно [тут](https://github.com/nogizhopaboroda/f_context/blob/master/example/example.coffee) и [тут](https://github.com/nogizhopaboroda/f_context/tree/master/tests)

А попробовать в действии вот таким образом:
  ```shell
  git clone git@github.com:nogizhopaboroda/f_context.git
  cd f_context/example
  open example.html
  ```

###### Библиотека не меняет никаких прототипов, ничего не eval'ит и никак не мешает нормальному исполнению другого кода в приложении

###### В большинстве примеров ниже функции начинаются с префикса f_. Это просто вкусовщина и писать его не обязательно.

##### INSTALLATION:
  ```html
  <script src="https://raw.githubusercontent.com/nogizhopaboroda/f_context/master/dist/f_context.js"></script>
  ```

  или

  ```shell
  git clone git@github.com:nogizhopaboroda/f_context.git
  ```

dist/f_context.js - текущий релиз

Библиотечка сейчас написана непойми-как и нуждается в жестком рефакторинге чтобы можно было легко понять как она работает. Но работает и проходит тесты :)

### ЧТО УМЕЕТ БИБЛИОТЕКА:

##### PATTERN MATCHING:

[что это и зачем оно нужно](https://en.wikipedia.org/wiki/Pattern_matching)

Пример паттерн матчинга для одного аргумента:
  ```erlang
  matching_example_1("foo") -> "foo matches"
  matching_example_1("bar") -> "bar matches"
  matching_example_1(Str) -> "nothing matches, argument: #{Str}"
  ```

Пример паттерн матчинга для двух аргументов:
  ```erlang
  matching_example_1_1("foo", "bar") -> "foo and bar matches"
  matching_example_1_1("bar", "bla") -> "bar and bla matches"
  matching_example_1_1("bar", "bar") -> "bar and bar matches"
  matching_example_1_1(Str, Str2) -> "nothing matches, arguments: #{Str}, #{Str2}"
  ```

Результат:
  ```js
  matching_example_1("foo") //returns "foo matches"
  matching_example_1("bar") //returns "bar matches"
  matching_example_1("baz") //returns "nothing matches, argument: baz"

  matching_example_1_1("foo", "bar") //returns "foo and bar matches"
  matching_example_1_1("bar", "bla") //returns "bar and bla matches"
  matching_example_1_1("bar", "bar") //returns "bar and bar matches"
  matching_example_1_1("baz", "bla") //returns "nothing matches, arguments: baz, bla"
  ```

##### DESTRUCTURING:
[что это и зачем оно нужно](http://en.wikipedia.org/wiki/Assignment_(computer_science)#Parallel_assignment)

[и еще](http://coffeescript.org/#destructuring)

  ```erlang
  test_destruct_1([Head, Tail...]) -> {Head, Tail}
  test_destruct_1_1([Head, Head1, Tail...]) -> {Head, Head1, Tail}
  ```

  ```erlang
  test_destruct_2([Head..., Last]) -> {Head, Last}
  test_destruct_2_1([Head..., Last, Last1]) -> {Head, Last, Last1}
  ```

  ```erlang
  test_destruct_3([Head, Middle..., Last]) -> {Head, Middle, Last}
  test_destruct_3_1([Head, Head2, Middle..., Last, Last2]) -> {Head, Head2, Middle, Last, Last2}
  ```

##### GUARDS:
[что это и зачем оно нужно](http://en.wikipedia.org/wiki/Guard_(computer_science))

Гварды задаются через директиву where(%condition%).

В гвардах можно задавать более гибкое сравнение. Пример вычисления ряда Фибоначчи:

  без гвардов

  ```erlang
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

  с гвардами

  ```erlang
  fibonacci_range(Count) ->
    fibonacci_range(Count, 0, [])

  fibonacci_range(Count, Count, Accum) -> Accum

  fibonacci_range(Count, Iterator, Accum) where(Iterator is 0 or Iterator is 1) ->
    fibonacci_range(Count, Iterator + 1, [Accum..., Iterator])

  fibonacci_range(Count, Iterator, [AccumHead..., A, B]) ->
    fibonacci_range(Count, Iterator + 1, [AccumHead..., A, B, A + B])
  ```

##### MODULES:

По умолчанию все сгенерированные библиотекой функции находятся в window.
Директива module задает модуль, в котором они будут находиться

  ```erlang
  f_context ->
    module("examples")

    f_range(I) ->
      f_range(I, 0, [])

    f_range(I, I, Accum) -> Accum
    f_range(I, Iterator, Accum) ->
      f_range(I, Iterator + 1, [Accum..., Iterator])
  ```

Теперь функция f_range доступна в модуле examples, и вызывается вот так:
  ```js
  examples.f_range(10)
  ```

##### REAL LIFE EXAMPLES:
Примеры реализаций функций reduce и quick sort:
  ```erlang
  f_reduce(List, F) ->
    f_reduce(List, F, 0)

  f_reduce([], _, Memo) -> Memo

  f_reduce([X, List...], F, Memo) ->
    f_reduce(List, F, F(X, Memo))
  ```

  ```erlang
  f_qsort([]) -> []
  f_qsort([Pivot, Rest...]) ->
    [f_qsort((X for X in Rest when X < Pivot))..., Pivot, f_qsort((Y for Y in Rest when Y >= Pivot))...]
  ```

##### HOW IT WORKS:
Лучше не читать.

  ```erlang
  fact(0) -> 1
  fact(N) -> N * fact(N - 1)
  ```
Если скомпилировать приведенный выше кусок кода в coffeescript, получим вот такой js код:
  ```js
  fact(0)(function() {
    return 1;
  });

  fact(N)(function() {
    return N * fact(N - 1);
  });
  ```

Как видно, это абсолютно валидный js, а значит его можно выполнить, правда с ошибками.

Но если написать вот такое:
  ```erlang
  function_wrapper ->
    fact(0) -> 1
    fact(N) -> N * fact(N - 1)
  ```

то получим на выходе:

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

Это значит что fact будет исполняться в контексте function_wrapper, которая может проанализировать приходящую ей параметром функцию перед исполнением на предмет недостающих функций и переменных и передать их в контекст исполнения. А значит у нас есть все данные чтобы сконструировать новый fact с нужными проверками и положить его в какой-то контейнер, например window.

##### TESTING:
  ```shell
  gulp test
  ```

##### BENCHMARK:
  ```shell
  coffee bench/bench.coffee
  ```
