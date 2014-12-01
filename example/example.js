(function() {
  this.f_context(function() {
    matching_example_1("foo")(function() {
      return "foo matches";
    });
    matching_example_1("bar")(function() {
      return "bar matches";
    });
    return matching_example_1(Str)(function() {
      return "nothing matches";
    });
  });

}).call(this);
