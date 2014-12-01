(function() {
  var __slice = [].slice;

  this.f_context(function() {
    module("examples");
    arguments_test_1()(function() {
      return "nothing";
    });
    arguments_test_1(A)(function() {
      return "one argument: " + A;
    });
    arguments_test_1(A, B)(function() {
      return "two arguments: " + A + ", " + B;
    });
    arguments_test_1(A, A)(function() {
      return "two arguments and it is the same: " + A;
    });
    f_fact(0)(function() {
      return 1;
    });
    f_fact(N)(function() {
      return N * f_fact(N - 1);
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
    f_count(List, Iterator)(function() {
      return f_count(tl(List), Iterator + 1);
    });
    f_range(I)(function() {
      return f_range(I, 0, []);
    });
    f_range(I, I, Accum)(function() {
      return Accum;
    });
    f_range(I, Iterator, Accum)(function() {
      return f_range(I, Iterator + 1, Accum.concat(Iterator));
    });
    f_range_guard(I)(function() {
      return f_range_guard(I, 0, []);
    });
    f_range_guard(I, Iterator, Accum)(where(I === Iterator)(function() {
      return Accum;
    }));
    f_range_guard(I, Iterator, Accum)(function() {
      return f_range_guard(I, Iterator + 1, Accum.concat(Iterator));
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
    return f_flatten([Head].concat(__slice.call(List)), Acc)(function() {
      return f_flatten(List, Acc.concat(Head));
    });
  });

}).call(this);
