# Words path

Words path in a simple programming excercise consisting in writing a program able to find a path between two english words of the same length, changing only one letter a time and only using valid english words as intermediaries.

Ex: `cat -> cot -> dot -> dog`

This repository holds 3 version of my solution to this problem I wrote in Ruby, Crystal and C++.

You can compile and run them all by using: `make test`
You'll need the `crystal` compiler, `clang`, `rustc` and `ruby`.

This runs all version against the same example (`jina pray`) to compare their speed, here are the results on my machine:

Language | CPU time | Clock time | Comment
---------|----------|------------|-------------------------------------------
Ruby     | 160 ms   | 180 ms     | The difference between CPU time and Clock is caused by ruby VM file loading (IO)
Crystal  | 95 ms    | 86 ms      | Crystal is a Ruby-like compiled language, and it optimizes loading using threads, that's why we have more CPU time here.
C++      | 39 ms    | 39 ms      | The C++ version is very fast and stable, as expected from a statically compiled language.
Rust     | 23 ms    | 23 ms      | Even better then C++, not sure why yet, maybe the file read.