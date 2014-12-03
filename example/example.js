(function() {
  var __slice = [].slice;

  f_context(function() {
    module("examples");
    f_fact(0)(function() {
      return 1;
    });
    f_fact(N)(function() {
      return N * f_fact(N - 1);
    });
    fibonacci_range(Count)(function() {
      return fibonacci_range(Count, 0, []);
    });
    fibonacci_range(Count, Count, Accum)(function() {
      return Accum;
    });
    fibonacci_range(Count, Iterator, Accum)(where(Iterator === 0 || Iterator === 1)(function() {
      return fibonacci_range(Count, Iterator + 1, __slice.call(Accum).concat([Iterator]));
    }));
    fibonacci_range(Count, Iterator, __slice.call(AccumHead).concat([A], [B]))(function() {
      return fibonacci_range(Count, Iterator + 1, __slice.call(AccumHead).concat([A], [B], [A + B]));
    });
    f_format(Str)(function() {
      return f_format(Str, "");
    });
    f_format(Str, Accum)(where(Str.length <= 3)(function() {
      return Str.concat(" " + Accum);
    }));
    f_format(Str, Accum)(function() {
      return f_format(Str.slice(0, Str.length - 3), Str.slice(Str.length - 3)).concat(" " + Accum);
    });
    f_count(List)(function() {
      return f_count(List, 0);
    });
    f_count([], Iterator)(function() {
      return Iterator;
    });
    f_count([Head].concat(__slice.call(List)), Iterator)(function() {
      return f_count(List, Iterator + 1);
    });
    f_range(I)(function() {
      return f_range(I, 0, []);
    });
    f_range(I, I, Accum)(function() {
      return Accum;
    });
    f_range(I, Iterator, Accum)(function() {
      return f_range(I, Iterator + 1, __slice.call(Accum).concat([Iterator]));
    });
    f_range_guard(I)(function() {
      return f_range_guard(I, 0, []);
    });
    f_range_guard(I, Iterator, Accum)(where(I === Iterator)(function() {
      return Accum;
    }));
    f_range_guard(I, Iterator, Accum)(function() {
      return f_range_guard(I, Iterator + 1, __slice.call(Accum).concat([Iterator]));
    });
    f_all([Head].concat(__slice.call(List)), F)(function() {
      return f_all(List, F, F(Head));
    });
    f_all(_, _, false)(function() {
      return false;
    });
    f_all([], _, _)(function() {
      return true;
    });
    f_all([Head].concat(__slice.call(List)), F, Memo)(function() {
      return f_all(List, F, F(Head));
    });
    f_flatten(List)(function() {
      return f_flatten(List, []);
    });
    f_flatten([], Acc)(function() {
      return Acc;
    });
    f_flatten([Head].concat(__slice.call(List)), Acc)(where(Head instanceof Array)(function() {
      return f_flatten(List, f_flatten(Head, Acc));
    }));
    f_flatten([Head].concat(__slice.call(List)), Acc)(function() {
      return f_flatten(List, __slice.call(Acc).concat([Head]));
    });
    f_reduce(List, F)(function() {
      return f_reduce(List, F, 0);
    });
    f_reduce([], _, Memo)(function() {
      return Memo;
    });
    f_reduce([X].concat(__slice.call(List)), F, Memo)(function() {
      return f_reduce(List, F, F(X, Memo));
    });
    f_qsort([])(function() {
      return [];
    });
    return f_qsort([Pivot].concat(__slice.call(Rest)))(function() {
      var X, Y;
      return __slice.call(f_qsort((function() {
          var _i, _len, _results;
          _results = [];
          for (_i = 0, _len = Rest.length; _i < _len; _i++) {
            X = Rest[_i];
            if (X < Pivot) {
              _results.push(X);
            }
          }
          return _results;
        })())).concat([Pivot], __slice.call(f_qsort((function() {
          var _i, _len, _results;
          _results = [];
          for (_i = 0, _len = Rest.length; _i < _len; _i++) {
            Y = Rest[_i];
            if (Y >= Pivot) {
              _results.push(Y);
            }
          }
          return _results;
        })())));
    });
  }, (this.debug_container = {}));

}).call(this);
