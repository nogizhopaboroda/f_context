(function() {
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
    return arguments_test_1(A, A)(function() {
      return "two arguments and it is the same: " + A;
    });
  });

}).call(this);
