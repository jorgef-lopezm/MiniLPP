#include "lexer.h"

/*!max:re2c*/

Lexer::Lexer(std::istream &in): ctx(in) {
    lineNo = 1;
}

Lexer::Context::Context(std::istream &in): in(in) {
    buff.resize(SIZE + YYMAXFILL);
    lim = buff.begin() + SIZE;
    cur = lim;
    tok = lim;
    eof = false;
}

bool Lexer::Context::fill(size_t need) {
    if (eof)
        return false;

    size_t free = std::distance(buff.begin(), tok);

    if (free < need)
        return false;

    std::copy(tok, lim, buff.begin());
    std::advance(lim, -free);
    std::advance(cur, -free);
    std::advance(tok, -free);

    char *p = buff.data() + std::distance(buff.begin(), lim);
    in.read(p, free);
    std::advance(lim, in.gcount());

    if (lim < buff.begin() + SIZE) {
        eof = true;
        std::fill(lim, buff.end(), 0);
        std::advance(lim, YYMAXFILL);
    }

    return true;
}

std::string Lexer::Context::tokenText() {
    return std::string(tok, cur);
}

int Lexer::makeToken(int token) {
    lexeme = ctx.tokenText();
    return token;
}

int Lexer::getNextToken() {
    std::vector<char>::iterator YYMARKER;
    
    while (1) {
        ctx.tok = ctx.cur;
        /*!re2c
            re2c:define:YYCTYPE = char;
            re2c:define:YYLIMIT = ctx.lim;
            re2c:define:YYCURSOR = ctx.cur;
            re2c:define:YYFILL = "if(!ctx.fill(@@))return EoF;";
            re2c:define:YYFILL:naked = 1;
            num = [0-9]*;
            bin = '0b' [0-1]+;
            hex = '0x' [a-fA-F0-9]+;
            end = "\x00";
            ids = [_a-zA-Z][_a-zA-Znum]*;
            [ \t]                                   { continue; }
            [\n]                                    { lineNo++; return makeToken('\n'); }
            "["                                     { return makeToken('['); }
            "]"                                     { return makeToken(']'); }
            ","                                     { return makeToken(','); }
            ":"                                     { return makeToken(':'); }
            "("                                     { return makeToken('('); }
            ")"                                     { return makeToken(')'); }
            "<-"                                    { return makeToken(OP_ASSIGN); }
            "+"                                     { return makeToken('+'); }
            "-"                                     { return makeToken('-'); }
            "*"                                     { return makeToken('*'); }
            "^"                                     { return makeToken('^'); }
            "<"                                     { return makeToken('<'); }
            ">"                                     { return makeToken('>'); }
            "="                                     { return makeToken('='); }
            "<>"                                    { return makeToken(OP_NOT_EQ); }
            "<="                                    { return makeToken(OP_LESS_EQ); }
            ">="                                    { return makeToken(OP_GREATER_EQ); }
            "\""                                    { goto str_constant; }
            "'"                                     { goto ch_constant; }
            'abrir'                                 { return makeToken(KW_ABRIR); }
            'archivo'                               { return makeToken(KW_ARCHIVO); }                                                       
            'arreglo'                               { return makeToken(KW_ARREGLO); }                                                       
            'booleano'                              { return makeToken(KW_BOOLEANO); }                                                       
            'cadena'                                { return makeToken(KW_CADENA); }                                                       
            'caracter'                              { return makeToken(KW_CARACTER); }                                                     
            'caso'                                  { return makeToken(KW_CASO); }                                                 
            'cerrar'                                { return makeToken(KW_CERRAR); }                                                                                         
            'como'                                  { return makeToken(KW_COMO); }                                                                                     
            'de'                                    { return makeToken(KW_DE); }                                                                                     
            'div'                                   { return makeToken(KW_DIV); }                                                                                     
            'entero'                                { return makeToken(KW_ENTERO); }                                                     
            'entonces'                              { return makeToken(KW_ENTONCES); }                                 
            'es'                                    { return makeToken(KW_ES); }                             
            'escriba'                               { return makeToken(KW_ESCRIBA); }                                 
            'escribir'                              { return makeToken(KW_ESCRIBIR); }                                 
            'escritura'                             { return makeToken(KW_ESCRITURA); }                                 
            'falso'                                 { return makeToken(KW_FALSO); }                                                 
            'fin'                                   { return makeToken(KW_FIN); }                                                 
            'final'                                 { return makeToken(KW_FINAL); }                                                 
            'funcion'                               { return makeToken(KW_FUNCION); }                                                     
            'haga'                                  { return makeToken(KW_HAGA); }                                                 
            'hasta'                                 { return makeToken(KW_HASTA); }                                     
            'inicio'                                { return makeToken(KW_INICIO); }                                         
            'lea'                                   { return makeToken(KW_LEA); }                                     
            'lectura'                               { return makeToken(KW_LECTURA); }                                         
            'leer'                                  { return makeToken(KW_LEER); }                                     
            'llamar'                                { return makeToken(KW_LLAMAR); }                 
            'mientras'                              { return makeToken(KW_MIENTRAS); }                                                     
            'mod'                                   { return makeToken(KW_MOD); }                                                 
            'no'                                    { return makeToken(KW_NO); }                                                 
            'o'                                     { return makeToken(KW_O); }                                             
            'para'                                  { return makeToken(KW_PARA); }                                                 
            'procedimiento'                         { return makeToken(KW_PROCEDIMIENTO); }                                                                 
            'real'                                  { return makeToken(KW_REAL); }                                                         
            'registro'                              { return makeToken(KW_REGISTRO); }                                                             
            'repita'                                { return makeToken(KW_REPITA); }                                                             
            'retorne'                               { return makeToken(KW_RETORNE); }                                                             
            'secuencial'                            { return makeToken(KW_SECUENCIAL); }                                                 
            'si'                                    { return makeToken(KW_SI); }                                         
            'sino'                                  { return makeToken(KW_SINO); }                                                                                                                 
            'tipo'                                  { return makeToken(KW_TIPO); }                                                                                                                 
            'var'                                   { return makeToken(KW_VAR); }                                                                                                                 
            'verdadero'                             { return makeToken(KW_VERDADERO); }                                                                                         
            'y'                                     { return makeToken(KW_Y); }
            ids                                     { return makeToken(IDENTIFIER); }
            num | hex | bin                         { return makeToken(NUMBER); }
            "//"                                    { goto line_comment; }
            "/*"                                    { goto block_comment; }
            end                                     { return EoF; }                                               
            *                                       { return ERROR; }
        */
str_constant:
        /*!re2c
            "\"\""                                  { goto str_constant; }
            "\""                                    { return makeToken(STRING); }
            end                                     { return ERROR; }
            .                                       { goto str_constant; }
        */
ch_constant:
        /*!re2c
            "'''"                                   { return makeToken(CHARACTER); }
            ."'"                                    { return makeToken(CHARACTER); }
            "'"                                     { return ERROR; }
        */
line_comment:
        /*!re2c
            "\n"                                    { continue; }
            .                                       { goto line_comment; }
        */
block_comment:
        /*!re2c
            "*""/"                                  { continue; }
            .                                       { goto block_comment; }                                   
        */
    }
}