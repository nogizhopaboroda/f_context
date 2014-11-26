pkg    = require('./package.json');
gulp   = require('gulp');
coffee = require('gulp-coffee');
util   = require('gulp-util');
watch = require('gulp-watch');
karma = require("karma").server;

source = [
  'src/f_context.coffee'
];

example_source = [
	'example/example.coffee'
];

gulp.task('build', function() {
  gulp.src(source)
    .pipe(coffee().on('error', util.log))
    .pipe(gulp.dest('dist'))
});

gulp.task('build_example', function() {
	gulp.src(example_source)
		.pipe(coffee().on('error', util.log))
		.pipe(gulp.dest('example'))
});


gulp.task("watch", function() {
	gulp.watch(source, ["build"]);
	gulp.watch(example_source, ["build_example"]);
});

gulp.task("test", function(done) {
	karma.start({
		configFile: __dirname + '/karma.conf.js'
	}, done);
});

gulp.task('default', ['build', 'build_example', 'watch']);
