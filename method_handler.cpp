#include "method_handler.h"

std::string MethodHandler::getStackPlace(std::string id) {
    auto localVarsIt = localVars.find(id);
    auto paramsIt = params.find(id);

    if (localVarsIt != localVars.end()) {
        return "ebp - " + std::to_string(localVars[id].first);
    }
    if (paramsIt != params.end()) {
        return "ebp + " + std::to_string(params[id].first);
    }
    return "";
}

void MethodHandler::registerParam (std::string id, std::pair<int, int> info) {
    params.insert(std::pair<std::string, std::pair<int, int>>(id, info));
}

void MethodHandler::registerVar (std::string id, std::pair<int, int> info) {
    localVars.insert(std::pair<std::string, std::pair<int, int>>(id, info));
}

int MethodHandler::getVarOffset(int size, bool isArray) {
    localVarsOffset += size;
    return localVarsOffset;
}