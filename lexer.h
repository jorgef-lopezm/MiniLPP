#ifndef LEXER_H
#define LEXER_H

#include <vector>
#include <fstream>
#include <string>
#include <iostream>

#include "tokens.h"

#define SIZE 1024
#define ERROR   -1
#define EoF     0

class Lexer {
public:
    Lexer(std::istream &in);

private:
    struct Context {
    public:
        Context(std::istream &in);

        std::istream &in;
        std::vector<char> buff;
        std::vector<char>::iterator cur, lim, tok;
        bool eof;

        bool fill(size_t need);

        std::string tokenText();
    } ctx;

    int lineNo;
    std::string lexeme;

    int makeToken(int token);

public:
    int getLineNo() { return lineNo; }
    std::string getLexeme() { return lexeme; }
    int getNextToken();
};

#endif