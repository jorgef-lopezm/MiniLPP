#include <iostream>
#include <fstream>
#include "parser.h"
#include <list>

int main(int argc, char *argv[]) {
	if (argc != 2) {
		fprintf(stderr, "Usage: %s <input file>\n", argv[0]);
		return 1;
	}
	
	std::ifstream in;

	in.open(argv[1], std::ios::in);

	if (!in) {
		std::cerr << "Cannot open file '" << argv[1] << "'\n";
		return 1;
	}

	Lexer lexer(in);
	Lpp::Parser parser(lexer);
    parser.parse();
}