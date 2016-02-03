all: words_path_c++ words_path_crystal words_path_rs Elixir.WordsPath.beam words_path_go words_path_mrb

words_path_c++: words_path.cpp
	clang++ -O3 words_path.cpp -o words_path_c++

words_path_crystal: words_path.cr
	crystal build --release words_path.cr -o words_path_crystal

words_path_rs: words_path.rs
	rustc -O words_path.rs -o words_path_rs

Elixir.WordsPath.beam: words_path.ex
	elixirc words_path.ex

words_path_mrb: words_path.mrb
	./mruby-1.2.0/build/host/bin/mrbc -Bwords_path_mrb words_path.mrb
	cat words_path.c words_path_mrb_append.c > words_path_mrb.c
	gcc -std=c99 -Imruby-1.2.0/include words_path_mrb.c -o words_path_mrb mruby-1.2.0/build/host/lib/libmruby.a -lm
	rm words_path.c words_path_mrb.c

words_path_go: words_path.go
	go build -o words_path_go words_path.go

clean:
	rm -f words_path_c++ words_path_crystal words_path_rs Elixir.WordsPath.beam words_path_mrb.c words_path_mrb

test: all
	./benchmark.rb

re: clean all
