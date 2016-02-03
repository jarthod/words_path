# Words path

Words path in a simple programming excercise consisting in writing a program able to find a path between two english words of the same length, changing only one letter a time and only using valid english words as intermediaries.

Ex: `cat -> cot -> dot -> dog`

This repository holds a few versions of my solution to this problem I wrote in different languages (see below).

You can compile and run them all by using: `make test`
You'll need the `crystal`, `clang`, `rustc`, `elixirc` compilers and `ruby`.
You'll also need the `benchmark-ips` ruby gem to run the test: `gem install benchmark-ips`

This runs all version against the same example (`jina pray`) to compare their speed, they are all compiled in release mode with standard optimizations (see Makefile). Here are the results on my machine:

Language | CPU time | Clock time | Comment
---------|----------|------------|-------------------------------------------
Rust     |    16 ms |      20 ms | Best performance, not sure why yet ☺
Crystal  |    23 ms |      22 ms | Crystal is a Ruby-like statically compiled language, very promising.
Go       |    29 ms |      32 ms | Like C++
C++      |    30 ms |      32 ms |
Ruby     |   146 ms |     170 ms | Interpreted, slower of course
Elixir   |   640 ms |     650 ms | My code is probably pretty bad but I expected better.
mruby    | 2,000 ms |   2,000 ms | Even compiled into binary, mruby is quite slow here, not mature enough I guess.

Here is the raw benchmark-ips output:

```
                rust     50.937  (± 0.0%) i/s -    256.000
             crystal     45.508  (± 2.2%) i/s -    228.000
                  go     31.762  (± 0.0%) i/s -    159.000
                 c++     32.082  (± 0.0%) i/s -    162.000
                ruby      6.537  (± 0.0%) i/s -     33.000
              elixir      1.536  (± 0.0%) i/s -      8.000
               mruby      0.497  (± 0.0%) i/s -      3.000  in   6.032254s

Comparison:
                rust:       50.9 i/s
             crystal:       45.5 i/s - 1.12x slower
                 c++:       32.1 i/s - 1.59x slower
                  go:       31.8 i/s - 1.60x slower
                ruby:        6.5 i/s - 7.79x slower
              elixir:        1.5 i/s - 33.16x slower
               mruby:        0.5 i/s - 102.42x slower

```