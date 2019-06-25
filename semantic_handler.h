#ifndef SEMANTIC_HANDLER_H
#define SEMANTIC_HANDLER_H

#include <list>
#include <string>

class SemanticHandler{
public:
    SemanticHandler(){}

private:
    std::list<std::string> functions;
    std::list<std::string> globalVariables;
};

#endif