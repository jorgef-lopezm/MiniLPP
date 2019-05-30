%require "3.3.2"
%language "c++"
%parse-param { Lexer & lexer }
%define parse.error verbose
%define api.value.type variant
%define api.namespace {Expr}
%define api.parser.class {Parser}

%code requires{
    #include <unordered_map>
    class Lexer;
}

%{
    #include "lexer.h"

    #define yylex(arg) lexer.getNextToken()
    
	namespace Expr{
    	void Parser::error(const std::string & msg) {
    	    std::cerr << "Syntax Error:Line:" << lexer.getLineNo() << ":Token: \"" << lexer.getLexeme() << "\": " << msg << std::endl;
    	}
	}
%}

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
%token OP_ASSIGN			"<-"
%token OP_NOT_EQ			"<>"
%token OP_LESS_EQ			"<="
%token OP_GREATER_EQ		">="
                                    /*---Identifier & Constants---*/
%token STRING CHARACTER IDENTIFIER NUMBER
									
									
									/*---Operations Precedence---*/
%left '=' "<>" '<' '>' "<=" ">="
%left '+' "o"
%left '*' "div" "mod" 'y' 
%left "no" '-'  

%%

input:	                    	program																{ std::cout << "File Parsed Succesfully" << std::endl; }										
;

program:	              		opt_subtype_definition_section
								opt_variable_section
								opt_subprogram_decl
								"inicio" opt_eols
								statement_list eols
								"fin" opt_eols											
;

opt_subtype_definition_section: subtype_definition_section eols
                                |%empty
;

subtype_definition_section:		subtype_definition_section eols "tipo" IDENTIFIER "es" type
								|"tipo" IDENTIFIER "es" type		
;

opt_variable_section:	    	variable_section eols
                            	|%empty
;

variable_section:	        	variable_section eols type id_list			
								|type id_list		
;

opt_subprogram_decl:			subprogram_decl_list eols
                            	|%empty
;

subprogram_decl_list:			subprogram_decl_list eols subprogram_decl			
								|subprogram_decl										
;

subprogram_decl:				"funcion" IDENTIFIER opt_arguments ':' type eols
								opt_variable_section
								"inicio" opt_eols
								statement_list eols
								"fin"
								|"procedimiento" IDENTIFIER opt_arguments eols
								opt_variable_section
								"inicio" opt_eols
								statement_list eols
								"fin"											
;

statement_list:					statement_list eols statement
								|statement
;

statement:						assign
								|"llamar" IDENTIFIER
								|"llamar" subprogram_call
								|"escriba" argument_list
								|"lea" lvalue_list
								|if_statement
								|"mientras" expr opt_eols 
								"haga" eols
								statement_list eols
								"fin" "mientras"
								|"repita" eols
								statement_list eols
								"hasta" expr									
								|"para" assign "hasta" expr "haga" eols
								statement_list eols
								"fin" "para"										
;

opt_eols:                   	eols
                            	|%empty
;

eols:	                    	eols '\n'											
								|'\n'												
;

type:                       	"entero"											
								|"booleano"											
								|"caracter"											
								|array-type											
;

array-type:     	        	"arreglo" '[' NUMBER ']' "de" type				
;

id_list:						id_list	',' IDENTIFIER									
								|IDENTIFIER												
;

opt_arguments:					'(' argument_decl_list ')'			
                            	|%empty
;

argument_decl_list:	        	argument_decl_list ',' type IDENTIFIER					
								|argument_decl_list ',' "var" type IDENTIFIER				
								|type IDENTIFIER											
								|"var" type IDENTIFIER									
;

assign:							lvalue "<-" expr
;

lvalue:	                    	IDENTIFIER												
								|IDENTIFIER '[' expr ']'									
;

expr:	                    	expr '=' term										
								|expr "<>" term										
								|expr '<' term										
								|expr '>' term										
								|expr "<=" term										
								|expr ">=" term
								|"no" expr
								|'-' expr								
								|term												
;

term:	                    	term '+' factor										
								|term '-' factor										
								|term "o" factor										
								|factor												
;

factor:							factor '*' exponent									
								|factor "div" exponent								
								|factor "mod" exponent								
								|factor "y" exponent									
								|exponent										
;

exponent:	                	exponent '^' rvalue
								|rvalue
;

rvalue:                     	'(' expr ')'
								|constant	
								|lvalue
								|subprogram_call
;

constant:                   	NUMBER
								|CHARACTER
								|"verdadero"
								|"falso"
;

subprogram_call:	        	IDENTIFIER '(' opt_expr_list ')'
;

opt_expr_list:	            	expr_list
                            	|%empty
;

expr_list:				    	expr_list ',' expr
								|expr
;

argument_list:					argument_list ',' expr
								|argument_list ',' STRING
								|expr
								|STRING
;

lvalue_list:					lvalue_list ',' lvalue
								|lvalue
;

if_statement:					"si" expr opt_eols 
								"entonces" opt_eols
								statement_list eols
								else_if_statement
								"fin" "si"	
;

else_if_statement:				"sino" else_if_statement_p
								|%empty
;

else_if_statement_p:			"si" expr opt_eols 
								"entonces" opt_eols
								statement_list
								"fin" "si" opt_eols
								else_if_statement
								|eols statement_list eols
;