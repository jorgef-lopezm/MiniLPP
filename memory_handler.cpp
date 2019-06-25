#include "memory_handler.h"

MemoryHandler::MemoryHandler() {
    labelCount = 0;
    usesExponentiation = false;
    currentContext = nullptr;
}

std::string MemoryHandler::getVariablePlace(std::string id) {
    if (currentContext != nullptr) {
        return currentContext->getStackPlace(id);
    }
    return id;
}

void MemoryHandler::registerVariable(std::string variable, std::pair<int, int> type) {
    globalVariables.insert(std::pair<std::string, std::pair<int, int>>(variable, type));
}

void MemoryHandler::registerMethod(MethodHandler *method) {
    methods.insert(std::pair<std::string, MethodHandler *>(method->getName(), method));
}

int MemoryHandler::getMethodVarsAmt(std::string id) {
    auto methodsIt = methods.find(id);
    if (methodsIt != methods.end())
        return methods[id]->getVarsAmt();
    return 0;
}

int MemoryHandler::getMethodParamsAmt(std::string id){
    auto methodsIt = methods.find(id);
    if (methodsIt != methods.end())
        return methods[id]->getParamsAmt();
    return 0;
}

void MemoryHandler::setCurrentContext(std::string id) {
    MethodHandler *method = nullptr;
    auto methodsIt = methods.find(id);
    if (methodsIt != methods.end())
        method = methods[id];
    currentContext = method;
}

std::string MemoryHandler::getConstPlace(int constant) {
    auto constsIt = constants.find(constant);
    if (constsIt != constants.end()) {
        return constants[constant];
    }
    return "const" + std::to_string(constants.size());
}

void MemoryHandler::registerConstant(int constant, std::string constPlace) {
    auto constsIt = constants.find(constant);
    if (constsIt == constants.end())
        constants.insert(std::pair<int, std::string>(constant, constPlace));
}

std::string MemoryHandler::getTempPlace() {
    std::string place = "temp" + std::to_string(temps.size());
    temps.insert(place);
    return place;
}

std::string MemoryHandler::getFormat(std::string format) {
    auto formatsIt = formats.find(format);
    if (formatsIt != formats.end()) {
        return formats[format];
    }
    std::string fmt = "fmt" + std::to_string(formats.size());
    formats.insert(std::pair<std::string, std::string>(format, fmt));
    return fmt;
}

std::string MemoryHandler::getNewLabel() {
    std::string output = "label" + std::to_string(labelCount);
    labelCount++;
    return output;
}

std::string MemoryHandler::getStrPlace(std::string str) {
    auto stringsIt = strings.find(str);
    if (stringsIt != strings.end()) {
        return strings[str];
    }
    std::string strN = "str" + std::to_string(strings.size());
    strings.insert(std::pair<std::string, std::string>(str, strN));
    return strN;
}

std::string MemoryHandler::getExponentFunction() {
    std::ostringstream exponentFunction;
    if (usesExponentiation) {
        exponentFunction << "pow:\n"
                         << "push ebp\n"
                         << "mov ebp, esp\n"
                         << "sub esp, 8\n"
                         << "mov dword[ebp - 4], 1\n"
                         << "mov dword[ebp - 8], 1\n"
                         << "pow_loop:\n"
                         << "mov eax, dword[ebp + 12]\n"
                         << "cmp dword[ebp - 4], eax\n"
                         << "jg pow_exit_loop\n"
                         << "mov eax, dword[ebp - 8]\n"
                         << "mov ebx, dword[ebp + 8]\n"
                         << "imul eax, ebx\n"
                         << "mov dword[ebp - 8], eax\n"
                         << "inc dword[ebp - 4]\n"
                         << "jmp pow_loop\n"
                         << "pow_exit_loop:\n"
                         << "mov eax, dword[ebp - 8]\n"
                         << "mov esp, ebp\n"
                         << "pop ebp\n"
                         << "ret\n";
    }
    return exponentFunction.str();
}

std::string MemoryHandler::getDataSection() {
    std::ostringstream dataSection;
    dataSection << "global main\n"
                << "extern printf\n"
                << "section .data\n"
                << "true dd 1\n"
                << "false dd 0\n";
    for (auto &&variable : globalVariables) {
        if (variable.second.second == 3)
            dataSection << variable.first << " times " << variable.second.first << " dd 0\n";
        else
            dataSection << variable.first << " dd 0\n";
    }

    for (auto &&consant : constants)
        dataSection << consant.second << " dd " << consant.first << "\n";

    for (auto temp : temps)
        dataSection << temp << " dd 0\n";

    for (auto &&str : strings)
        dataSection << str.second << " db \"" << str.first << "\", 0\n";

    for (auto &&fmt : formats)
        dataSection << fmt.second << " db \"" << fmt.first << "\", 0\n";

    return dataSection.str();
}