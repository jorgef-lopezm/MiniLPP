%pure-parser

%{
    #include "parser.h"

    #define yyparse(x) Parser::parse()
    #define yylex(arg) lexer.getNextToken()
    #define YYERROR_VERBOSE 1
    
    void Parser::yyerror(const char *msg) {
        std::cerr << "Syntax Error:Line:" << lexer.getLineNo() << ":Token: \"" << lexer.getLexeme() << "\": " << msg << std::endl;
        error = true;
    }
%}

%expect 55

                                    /*---Key Words---*/
%token KW_ABRIR             "abrir"
%token KW_ARCHIVO           "archivo"
%token KW_ARREGLO           "arreglo"
%token KW_BOOLEANO          "booleano"
%token KW_CADENA            "cadena"
%token KW_CARACTER          "caracter"
%token KW_CASO              "caso"
%token KW_CERRAR            "cerrar"
%token KW_COMO              "como"
%token KW_DE                "de"
%token KW_DIV               "div"
%token KW_ENTERO            "entero"
%token KW_ENTONCES          "entonces"
%token KW_ES                "es"
%token KW_ESCRIBA           "escriba"
%token KW_ESCRIBIR          "escribir"
%token KW_ESCRITURA         "escritura"
%token KW_FALSO             "falso"
%token KW_FIN               "fin"
%token KW_FINAL             "final"
%token KW_FUNCION           "funcion"
%token KW_HAGA              "haga"
%token KW_HASTA             "hasta"
%token KW_INICIO            "inicio"
%token KW_LEA               "lea"
%token KW_LECTURA           "lectura"
%token KW_LEER              "leer"
%token KW_LLAMAR            "llamar"
%token KW_MIENTRAS          "mientras"
%token KW_MOD               "mod"
%token KW_NO                "no"
%token KW_O                 "o"
%token KW_PARA              "para"
%token KW_PROCEDIMIENTO     "procedimiento"
%token KW_REAL              "real"
%token KW_REGISTRO          "registro"
%token KW_REPITA            "repita"
%token KW_RETORNE           "retorne"
%token KW_SECUENCIAL        "secuencial"
%token KW_SI                "si"
%token KW_SINO              "sino"
%token KW_TIPO              "tipo"
%token KW_VAR               "var"
%token KW_VERDADERO         "verdadero"
%token KW_Y                 "y"
                                    /*---Punctuation---*/
%token OP_ASSIGN OP_EQ OP_NOT_EQ OP_LESS_EQ OP_GREATER_EQ
                                    /*---Identifier & Constants---*/
%token STR_CONST CHAR_CONST IDENTIFIER NUM_CONST

%%

input:	                    program		                    { std::cout << "File Parsed Succesfully" << std::endl; }										
;

program:	                opt-eols
							opt-subtype-definition-section
							opt-variable-section
							opt-subprogram-decl
							"inicio" opt-eols
							opt-statement-list
							"fin" opt-eols											
;

opt-subtype-definition-section: subtype-definition-section eols
                                |%empty
;

subtype-definition-section:	subtype-definition-section eols "tipo" IDENTIFIER "es" type	
							|"tipo" IDENTIFIER "es" type								
;

opt-variable-section:	    variable-section eols
                            |%empty
;

variable-section:	        variable-section eols type id-list					
							|type id-list										
;

id-list:					id-list	',' IDENTIFIER									
							|IDENTIFIER												
;

opt-subprogram-decl:		subprogram-decl-list eols
                            |%empty
;

subprogram-decl-list:		subprogram-decl-list eols subprogram-decl			
							|subprogram-decl										
;

subprogram-decl:			subprogram-header
							eols
							opt-variable-section
							"inicio"
							opt-eols
							opt-statement-list
							"fin"												
;

subprogram-header:	        function-header									
							|procedure-header								
;

function-header:			"funcion" IDENTIFIER opt-arguments ':' type				
;

opt-arguments:				'(' argument-decl-list ')'			
                            |%empty
;

argument-decl-list:	        argument-decl-list ',' type IDENTIFIER					
							|argument-decl-list ',' "var" type IDENTIFIER				
							|type IDENTIFIER											
							|"var" type IDENTIFIER									
;

procedure-header:			"procedimiento" IDENTIFIER opt-arguments 				
;

opt-statement-list:	        statement-list eols
                            |%empty
;

statement-list: 	        statement-list eols statement						
							|statement											
;

statement:					assign												
							|"llamar" subprogram-call							
							|"llamar" IDENTIFIER	
                            |"escriba" argument-list									
							|"si" expr opt-eols "entonces"
							opt-eols
							opt-statement-list
							else-if
							else
							"fin" "si"											
							|"mientras" expr "haga"
							opt-eols
							opt-statement-list
							"fin" "mientras"									
							|"para" assign "hasta" expr "haga"
							opt-eols
							opt-statement-list
							"fin" "para"										
							|"repita"
							opt-eols
							opt-statement-list
							"hasta" expr										
							|"retorne" expr															
							|"lea" lvalue										
;

argument-list:	            argument-list ',' expr					
							|argument-list ',' STR_CONST		
							|expr												
							|STR_CONST									
;

else-if:					else-if "sino" "si" expr opt-eols 
							"entonces" opt-eols
							opt-statement-list "fin" "si" opt-eols
							|%empty
;

else:						"sino" opt-eols statement-list
							|%empty
;

assign:	                    lvalue OP_ASSIGN expr									
;

lvalue:	                    IDENTIFIER												
							|IDENTIFIER '[' expr ']'									
;

expr:	                    expr OP_EQ term										
							|expr "<>" term										
							|expr '<' term										
							|expr '>' term										
							|expr "<=" term										
							|expr ">=" term										
							|term												
;

term:	                    term '+' factor										
							|term '-' factor										
							|term 'o' factor										
							|factor												
;

factor:						factor '*' exponent									
							|factor "div" exponent								
							|factor "mod" exponent								
							|factor 'y' exponent									
							|exponent										
;

exponent:	                exponent '^' rvalue
							|rvalue
;

rvalue:                     '(' expr ')'
							|constant	
							|'-' expr											
							|lvalue			
							|subprogram-call	
							|"no" expr
;

constant:                   NUM_CONST
							|CHAR_CONST
							|"verdadero"
							|"falso"
;

subprogram-call:	        IDENTIFIER '(' opt-expr-list ')'
;

opt-expr-list:	            expr-list
                            |%empty
;

expr-list:				    expr-list ',' expr
							|expr
;

type:                       "entero"											
							|"booleano"											
							|"caracter"											
							|IDENTIFIER												
							|array-type											
;

array-type:     	        "arreglo" '[' NUM_CONST ']' "de" type				
;

opt-eols:                   eols
                            |%empty
;

eols:	                    eols '\n'											
							|'\n'												
;