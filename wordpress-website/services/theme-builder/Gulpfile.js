
var gulp = require('gulp');
var less = require('gulp-less');

var targetRoot = process.env.BUILD_TARGET || './build';

gulp.task('php', function () {
    return gulp.src('src/php/**/*')
		.pipe(gulp.dest(targetRoot));
});

gulp.task('less', function(){
	return gulp.src('src/less/style.less')
		.pipe(less())
		.pipe(gulp.dest(targetRoot));
});

gulp.task('watch', function(){
	gulp.watch('src/php/**/*', ['php']);
    gulp.watch('src/less/**/*.less', ['less']);
    gulp.watch('src/js/**/*.js', ['js']);
});

gulp.task('js', function(){
	return gulp.src('src/js/**/*.js')
		.pipe(gulp.dest(targetRoot))
        .pipe(gulp.dest(targetRoot))
});

gulp.task('default', [
    'php',
    'less',
    'js',
    'watch',
]);
