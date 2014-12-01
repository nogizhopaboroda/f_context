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
    arguments_test_1(A, A)(function() {
      return "two arguments and it is the same: " + A;
    });
    f_fact(0)(function() {
      return 1;
    });
    return f_fact(N)(function() {
      return N * f_fact(N - 1);
    });
  });

}).call(this);
