#ifndef PARSER_H
#define PARSER_H

#include "lexer.h"
#include <iostream>

class Parser {
public:
    Parser(Lexer &lexer): lexer(lexer) { error = false; };

private:
    Lexer &lexer;
    bool error;
    void yyerror(const char *msg);

public:
    int parse();
};

#endif