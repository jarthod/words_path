# Words path

Words path in a simple programming excercise consisting in writing a program able to find a path between two english words of the same length, changing only one letter a time and only using valid english words as intermediaries.

Ex: `cat -> cot -> dot -> dog` or `jina -> dina -> dins -> bins -> bias -> bras -> bray -> pray`

This repository holds a few versions of my solution to this problem I wrote in different languages (see below).

You can compile and run them all by using: `make test`
You'll need the `crystal`, `clang`, `rustc`, `elixirc` compilers, `ruby` and `mruby`. mruby will need to be compiled in the `mruby-1.2.0` folder without the `enable_debug` option and with the following gems:
```
  conf.gem github: 'yui-knk/mruby-set'
  conf.gem github: 'iij/mruby-io'
```
You'll also need the `benchmark-ips` ruby gem to run the test: `gem install benchmark-ips`

This runs all version against the same example (`jina pray`) to compare their speed, they are all compiled in release mode with standard optimizations (see Makefile). Here are the results on my machine:

Language   | CPU time | Clock time | Comment
-----------|----------|------------|-------------------------------------------
Rust 1.5   |    16 ms |      20 ms | Best performance, not sure why yet ☺
Crystal    |    23 ms |      22 ms | Crystal is a Ruby-like statically compiled language, very promising.
Go         |    29 ms |      32 ms | Like C++
C++        |    30 ms |      32 ms |
Ruby 2.3   |   132 ms |     160 ms | Interpreted, slower of course
Elixir 1.2 |   640 ms |     650 ms | My code is probably pretty bad but I expected better.
mruby 1.2  |   666 ms |     666 ms | mruby is quite slow here, not sure why.

Here is the raw benchmark-ips output:

```
                rust     50.352  (± 2.0%) i/s -    255.000
             crystal     44.992  (± 4.4%) i/s -    228.000
                  go     31.963  (± 0.0%) i/s -    162.000
                 c++     32.173  (± 3.1%) i/s -    162.000
                ruby      7.131  (± 0.0%) i/s -     36.000
              elixir      1.538  (± 0.0%) i/s -      8.000
               mruby      1.451  (± 0.0%) i/s -      8.000  in   5.514237s

Comparison:
                rust:       50.4 i/s
             crystal:       45.0 i/s - 1.12x slower
                 c++:       32.2 i/s - 1.57x slower
                  go:       32.0 i/s - 1.58x slower
                ruby:        7.1 i/s - 7.06x slower
              elixir:        1.5 i/s - 32.75x slower
               mruby:        1.5 i/s - 34.71x slower
```