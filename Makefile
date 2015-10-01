all: words_path_c++ words_path_crystal

words_path_c++: words_path.cpp
	clang++ -O3 words_path.cpp -o words_path_c++

words_path_crystal: words_path.cr
	crystal build words_path.cr -o words_path_crystal

clean:
	rm -f words_path_c++ words_path_crystal

re: clean all