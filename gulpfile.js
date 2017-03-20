var coffee = require('gulp-coffee'),
    browserify = require('browserify'),
    browserSync = require('browser-sync'),
    buffer = require('vinyl-buffer'),
    gulp = require('gulp'),
    gutil = require('gulp-util'),
    gulpif = require('gulp-if'),
    cssnano = require('gulp-cssnano'),
    handlebars = require('gulp-compile-handlebars'),
    sass = require('gulp-sass'),
    rename = require('gulp-rename'),
    source = require('vinyl-source-stream'),
    sourcemaps = require('gulp-sourcemaps'),
    stringify = require('stringify'),
    uglify = require('gulp-uglify'),
    runSeq = require('run-sequence'),
    jshint = require('gulp-jshint'),
    fs = require('fs');

// Copy assets (fonts, images, videos, sounds, etc)
gulp.task('assets', function() {
  gulp.src('src/index.html').pipe(gulp.dest('dist')).pipe(browserSync.stream());
  return gulp.src('src/assets/**')
    .pipe(gulp.dest('dist/assets'))
    .pipe(browserSync.stream());
});

gulp.task('scripts', function(cb) {
  runSeq('coffee', 'browserify', cb);
});

// Compile Coffeescript
gulp.task('coffee', function(){
  return gulp.src('./src/coffee/**/*.coffee')
    .pipe(coffee({ bare: true }).on('error', gutil.log ))
    .pipe(gulp.dest('./src/scripts/'));
});

// Compile Javascript
gulp.task('browserify', function() {
  return browserify({
      'debug': false
    })
    .transform(stringify({
      extensions: ['.html'],
      minify: true
    }))
    .add('src/scripts/main.js')
    .bundle()
    .on('error', gutil.log.bind(gutil, 'Browserify Error'))
    .pipe(source('main.js'))
    .pipe(gulp.dest('dist/scripts/'))
    .pipe(browserSync.stream());
});

// Compile Sass
gulp.task('styles', function() {
  return gulp.src('src/sass/*.sass')
    .pipe(sass())
    .pipe(cssnano({
      autoprefixer: {
        add: true,
        browsers: [
          '> 5%',
          'Explorer >= 11',
          'Chrome >= 48',
          'Safari >= 8',
          'Firefox >= 44',
          'iOS >= 9',
          'Android >= 4.4'
        ]
      }
    }))
    .pipe(gulp.dest('dist/styles'))
    .pipe(browserSync.stream());
});

gulp.task('templates', function () {
  
  var pages = [ 
        "index",
        "about",
        "resume",
        "contact"
      ],
      projects = [ 
        "mr-legs", 
        "bar-sans",
        "css-a-z",
        "peanuts",
        "trolls",
        "8mba",
        "shinola",
        "bandwidth",
        "games",
        "print"
      ],
      data = {},
      options = {
        batch: [ './src/handlebars' ]
      },

  meta = fs.readFileSync("src/json/meta.json");
  data.meta = JSON.parse( meta );

  for( var i = 0; i < pages.length; i++){

    var route = pages[i],
        page = fs.readFileSync("src/json/" + route + ".json");
        pageData = JSON.parse( page );

    if ( route === "index" ){
      pageData.slug = "#/";
    } else {
      pageData.slug = "#/" + route;
    }

    data[route] = pageData;
  }

  data.projects = [];
  for( var i = 0; i < projects.length; i++){
    var route = projects[i],
        page = fs.readFileSync("src/json/" + route + ".json"),
        pageData = JSON.parse( page );

    pageData.slug = "#/" + route;
    data.projects.push( pageData );
  }

  gulp.src("src/handlebars/main.handlebars")
    .pipe(handlebars( data, options ))
    .pipe(rename("index.html"))
    .pipe(gulp.dest( "dist" ));
});

// Run server and watch for changes
gulp.task('serve', ['default'], function() {
  browserSync.init({
    server: 'dist',
    ghostMode: false
  });
  gulp.watch('src/sass/**/*.sass', ['styles']);
  gulp.watch('src/coffee/**/*.coffee', ['scripts']);
  gulp.watch('src/handlebars/**/*.handlebars', ['templates']);
  gulp.watch('src/json/**/*.json', ['templates']);
  gulp.watch('dist/main.js' ).on('change', browserSync.reload);
  gulp.watch('dist/assets/**').on('change', browserSync.reload);
  gulp.watch('dist/**/*.html').on('change', browserSync.reload);
});

gulp.task('default', [
  'templates',
  'scripts',
  'styles',
  'assets'
]);