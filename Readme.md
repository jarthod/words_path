# Words path

Words path in a simple programming excercise consisting in writing a program able to find a path between two english words of the same length, changing only one letter a time and only using valid english words as intermediaries.

Ex: `cat -> cot -> dot -> dog` or `jina -> dina -> dins -> bins -> bias -> bras -> bray -> pray`

This repository holds a few versions of my solution to this problem I wrote in different languages (see below).

You can compile and run them all by using: `make test`
You'll need the `crystal`, `clang`, `rustc`, `elixirc` compilers, and the `node`, `ruby` and `mruby` interpreters. mruby will need to be compiled in the `mruby-1.2.0` folder without the `enable_debug` option and with the following gems:
```
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
Node.js 5  |   114 ms |     116 ms |
Ruby 2.3   |   132 ms |     160 ms | Interpreted, slower of course
Elixir 1.2 |   640 ms |     650 ms | My code is probably pretty bad but I expected better.
mruby 1.2  |   666 ms |     666 ms | mruby is quite slow here, not sure why.

And here is a more detailed benchmark about Ruby interpreters:

 VM            |  bootup | file load | graph search |   total |
---------------|---------|-----------|--------------|---------|
 MRI 2.3.0     |   73 ms |     27 ms |        70 ms |  170 ms |
 mruby 1.2     |    2 ms |    220 ms |       470 ms |  692 ms |
 Rubinius 2.9  |  350 ms |    900 ms |       800 ms | 2050 ms |
 JRuby 9.0.4.0 | 1750 ms |    280 ms |       320 ms | 2350 ms |
 JRuby + Graal | 1380 ms |    140 ms |       180 ms | 1700 ms |
 InfraRuby 4.0 |  430 ms |    125 ms |        42 ms |  600 ms |

Here is the raw benchmark-ips output:

```
                rust     50.635  (± 2.0%) i/s -    256.000
             crystal     45.121  (± 2.2%) i/s -    228.000
                  go     31.266  (± 3.2%) i/s -    159.000
                 c++     31.806  (± 3.1%) i/s -    159.000
             node.js      8.611  (± 0.0%) i/s -     44.000
                ruby      7.095  (± 0.0%) i/s -     36.000
              elixir      1.503  (± 0.0%) i/s -      8.000  in   5.326484s
               mruby      1.477  (± 0.0%) i/s -      8.000  in   5.417883s

Comparison:
                rust:       50.6 i/s
             crystal:       45.1 i/s - 1.12x slower
                 c++:       31.8 i/s - 1.59x slower
                  go:       31.3 i/s - 1.62x slower
             node.js:        8.6 i/s - 5.88x slower
                ruby:        7.1 i/s - 7.14x slower
              elixir:        1.5 i/s - 33.69x slower
               mruby:        1.5 i/s - 34.29x slower
```