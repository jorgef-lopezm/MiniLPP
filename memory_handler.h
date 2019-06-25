#ifndef MEMORY_HANDLER_H
#define MEMORY_HANDLER_H

#include <set>
#include <list>
#include <string>
#include <sstream>
#include <algorithm>
#include <tuple>
#include "method_handler.h"

class MemoryHandler
{
public:
  MemoryHandler();
  std::string getVariablePlace(std::string);
  void registerVariable(std::string, std::pair<int, int>);
  void registerMethod(MethodHandler *);
  int getMethodVarsAmt(std::string);
  int getMethodParamsAmt(std::string);
  MethodHandler *getCurrentContext() { return currentContext; }
  void setCurrentContext(std::string);
  void resetContext() { currentContext = nullptr; }
  std::string getConstPlace(int);
  void registerConstant(int, std::string);
  std::string getTempPlace();
  std::string getFormat(std::string);
  std::string getNewLabel();
  std::string getStrPlace(std::string str);
  void setUsesExponentiation() { usesExponentiation = true; }
  std::string getExponentFunction();
  std::string getDataSection();

private:
  int labelCount;
  bool usesExponentiation;
  MethodHandler *currentContext;
  std::unordered_map<std::string, std::pair<int, int>> globalVariables;
  std::unordered_map<std::string, MethodHandler *> methods;
  std::unordered_map<std::string, std::string> formats;
  std::unordered_map<std::string, std::string> strings;
  std::unordered_map<int, std::string> constants;
  std::set<std::string> temps;
};

#endif