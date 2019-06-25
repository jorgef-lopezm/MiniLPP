#include "lexer.h"

/*!max:re2c*/

extern YYNODESTATE pool;


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

int Lexer::getNextToken(semantic_type *yylval) {
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
            "<-"                                    { return makeToken(token::OP_ASSIGN); }
            "+"                                     { return makeToken('+'); }
            "-"                                     { return makeToken('-'); }
            "*"                                     { return makeToken('*'); }
            "^"                                     { return makeToken('^'); }
            "<"                                     { return makeToken('<'); }
            ">"                                     { return makeToken('>'); }
            "="                                     { return makeToken('='); }
            "<>"                                    { return makeToken(token::OP_NOT_EQ); }
            "<="                                    { return makeToken(token::OP_LESS_EQ); }
            ">="                                    { return makeToken(token::OP_GREATER_EQ); }
            "\""                                    { goto str_constant; }
            "'"                                     { goto ch_constant; }
            'abrir'                                 { return makeToken(token::KW_ABRIR); }
            'archivo'                               { return makeToken(token::KW_ARCHIVO); }                                                       
            'arreglo'                               { return makeToken(token::KW_ARREGLO); }                                                       
            'booleano'                              { return makeToken(token::KW_BOOLEANO); }                                                       
            'cadena'                                { return makeToken(token::KW_CADENA); }                                                       
            'caracter'                              { return makeToken(token::KW_CARACTER); }                                                     
            'caso'                                  { return makeToken(token::KW_CASO); }                                                 
            'cerrar'                                { return makeToken(token::KW_CERRAR); }                                                                                         
            'como'                                  { return makeToken(token::KW_COMO); }                                                                                     
            'de'                                    { return makeToken(token::KW_DE); }                                                                                     
            'div'                                   { return makeToken(token::KW_DIV); }                                                                                     
            'entero'                                { return makeToken(token::KW_ENTERO); }                                                     
            'entonces'                              { return makeToken(token::KW_ENTONCES); }                                 
            'es'                                    { return makeToken(token::KW_ES); }                             
            'escriba'                               { return makeToken(token::KW_ESCRIBA); }                                 
            'escribir'                              { return makeToken(token::KW_ESCRIBIR); }                                 
            'escritura'                             { return makeToken(token::KW_ESCRITURA); }                                 
            'falso'                                 { return makeToken(token::KW_FALSO); }                                                 
            'fin'                                   { return makeToken(token::KW_FIN); }                                                 
            'final'                                 { return makeToken(token::KW_FINAL); }                                                 
            'funcion'                               { return makeToken(token::KW_FUNCION); }                                                     
            'haga'                                  { return makeToken(token::KW_HAGA); }                                                 
            'hasta'                                 { return makeToken(token::KW_HASTA); }                                     
            'inicio'                                { return makeToken(token::KW_INICIO); }                                         
            'lea'                                   { return makeToken(token::KW_LEA); }                                     
            'lectura'                               { return makeToken(token::KW_LECTURA); }                                         
            'leer'                                  { return makeToken(token::KW_LEER); }                                     
            'llamar'                                { return makeToken(token::KW_LLAMAR); }                 
            'mientras'                              { return makeToken(token::KW_MIENTRAS); }                                                     
            'mod'                                   { return makeToken(token::KW_MOD); }                                                 
            'no'                                    { return makeToken(token::KW_NO); }                                                 
            'o'                                     { return makeToken(token::KW_O); }                                             
            'para'                                  { return makeToken(token::KW_PARA); }                                                 
            'procedimiento'                         { return makeToken(token::KW_PROCEDIMIENTO); }                                                                 
            'real'                                  { return makeToken(token::KW_REAL); }                                                         
            'registro'                              { return makeToken(token::KW_REGISTRO); }                                                             
            'repita'                                { return makeToken(token::KW_REPITA); }                                                             
            'retorne'                               { return makeToken(token::KW_RETORNE); }                                                             
            'secuencial'                            { return makeToken(token::KW_SECUENCIAL); }                                                 
            'si'                                    { return makeToken(token::KW_SI); }                                         
            'sino'                                  { return makeToken(token::KW_SINO); }                                                                                                                 
            'tipo'                                  { return makeToken(token::KW_TIPO); }                                                                                                                 
            'var'                                   { return makeToken(token::KW_VAR); }                                                                                                                 
            'verdadero'                             { return makeToken(token::KW_VERDADERO); }                                                                                         
            'y'                                     { return makeToken(token::KW_Y); }
            ids                                     { yylval->emplace<std::string> () = ctx.tokenText(); return makeToken(token::IDENTIFIER); }
            num | hex | bin                         { yylval->emplace<int> () = stoi(ctx.tokenText()); return makeToken(token::NUMBER); }
            "//"                                    { goto line_comment; }
            "/*"                                    { goto block_comment; }
            end                                     { return EoF; }                                               
            *                                       { return ERROR; }
        */
str_constant:
        /*!re2c
            "\"\""                                  { goto str_constant; }
            "\""                                    { yylval->emplace<std::string> () = ctx.tokenText(); return makeToken(token::STRING); }
            end                                     { return ERROR; }
            .                                       { goto str_constant; }
        */
ch_constant:
        /*!re2c
            "'''"                                   { yylval->emplace<char> () = stoi(ctx.tokenText()); return makeToken(token::CHARACTER); }
            ."'"                                    { yylval->emplace<char> () = stoi(ctx.tokenText()); return makeToken(token::CHARACTER); }
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