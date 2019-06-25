#ifndef METHOD_HANDLER_H
#define METHOD_HANDLER_H

#include <map>
#include <iostream>
#include <list>
#include <string.h>
#include <unordered_map>

class MethodHandler {
public:
	MethodHandler(std::string id) : id(id) { localVarsOffset = 0; }
	std::string getName() { return id; }
	std::string getStackPlace(std::string);
	bool searchParam(std::string);
	bool paramIsVar(std::string);
	void registerParam(std::string, std::pair<int, int>);
	int getParamsAmt() { return params.size(); }
	bool searchVar(std::string);
	void registerVar(std::string, std::pair<int, int>);
	int getVarOffset(int, bool);
	int getVarsAmt() { return localVars.size(); }

private:
	int localVarsOffset;
	std::string id;
	std::unordered_map<std::string, std::pair<int, int>> localVars;
	std::unordered_map<std::string, std::pair<int, int>> params;
};

#endif