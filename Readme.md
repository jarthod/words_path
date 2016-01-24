# Words path

Words path in a simple programming excercise consisting in writing a program able to find a path between two english words of the same length, changing only one letter a time and only using valid english words as intermediaries.

Ex: `cat -> cot -> dot -> dog`

This repository holds a few versions of my solution to this problem I wrote in Ruby, Crystal, C++ and Rust.

You can compile and run them all by using: `make test`
You'll need the `crystal`, `clang`, `rustc`, `elixirc` compilers and `ruby`.

This runs all version against the same example (`jina pray`) to compare their speed, they are all compiled in release mode with standard optimizations (see Makefile). Here are the results on my machine:

Language | CPU time | Clock time | Comment
---------|----------|------------|-------------------------------------------
Ruby     | 160 ms   | 180 ms     | The difference between CPU time and Clock is caused by ruby VM file loading (IO)
Crystal  | 54 ms    | 40 ms      | Crystal is a Ruby-like statically compiled language.
C++      | 39 ms    | 39 ms      | The C++ version is very fast and stable, as expected from a statically compiled language.
Rust     | 23 ms    | 23 ms      | Even better then C++, not sure why yet, maybe the file read.
Elixir   | 730 ms   | 750 ms     | My code is probably pretty bad but that doesn't look good
