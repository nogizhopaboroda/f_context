(function() {
  this.f_context(function() {
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
      Accum.push(Iterator);
      return f_range(I, Iterator + 1, Accum);
    });
    f_range_guard(I)(function() {
      return f_range_guard(I, 0, []);
    });
    f_range_guard(I, Iterator, Accum)(where(I === Iterator)(function() {
      return Accum;
    }));
    f_range_guard(I, Iterator, Accum)(function() {
      Accum.push(Iterator);
      return f_range_guard(I, Iterator + 1, Accum);
    });
    f_all(List, F)(function() {
      var X;
      X = List[0];
      return f_all(tl(List), F, F(X));
    });
    f_all(List, F, false)(function() {
      return false;
    });
    f_all([], F, Memo)(function() {
      return true;
    });
    return f_all(List, F, Memo)(function() {
      var X;
      X = List[0];
      return f_all(tl(List), F, F(X));
    });
  });

}).call(this);
