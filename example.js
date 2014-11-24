(function() {
  var test_container;

  this.functional_context(function() {
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
    return f_range_guard(I, Iterator, Accum)(function() {
      Accum.push(Iterator);
      return f_range_guard(I, Iterator + 1, Accum);
    });
  });

  test_container = {};

  this.functional_context(function() {
    return fizbaz(5)(function() {
      return 'pyat';
    });
  }, test_container);

}).call(this);
