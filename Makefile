all: words_path_c++ words_path_crystal words_path_rs

words_path_c++: words_path.cpp
	clang++ -O3 words_path.cpp -o words_path_c++

words_path_crystal: words_path.cr
	crystal build --release words_path.cr -o words_path_crystal

words_path_rs: words_path.rs
	rustc -O words_path.rs -o words_path_rs

clean:
	rm -f words_path_c++ words_path_crystal words_path_rs

test: all
	time -p ./words_path.rb jina pray
	@echo "-----------------"
	time -p ./words_path_crystal jina pray
	@echo "-----------------"
	time -p ./words_path_c++ jina pray
	@echo "-----------------"
	time -p ./words_path_rs jina pray

re: clean all
