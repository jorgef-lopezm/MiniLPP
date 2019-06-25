%require "3.3.2"
%language "c++"
%parse-param { Lexer & lexer }
%define parse.error verbose
%define api.value.type variant
%define api.namespace {Lpp}
%define api.parser.class {Parser}

%code requires{
    #include <unordered_map>
	#include "ast.h"

    class Lexer;
}

%{
    #include "lexer.h"

    #define yylex(arg) lexer.getNextToken(arg)
    
	namespace Lpp{
    	void Parser::error(const std::string & msg) {
    	    std::cerr << "Syntax Error:Line:" << lexer.getLineNo() << ":Token: \"" << lexer.getLexeme() << "\": " << msg << std::endl;
    	}
	}
	MemoryHandler handler;
	YYNODESTATE pool;
%}

%type <ASTNode*> program type array_type subprogram_decl statement assign
%type <ASTNode*> lvalue expr term factor exponent rvalue constant subprogram_call
%type <ASTNode*> if_statement
%type <std::list<ASTNode*>> opt_subtype_definition_section subtype_definition_section
%type <std::list<ASTNode*>> opt_variable_section variable_section
%type <std::list<ASTNode*>> opt_subprogram_decl subprogram_decl_list
%type <std::list<ASTNode*>> opt_arguments argument_decl_list
%type <std::list<ASTNode*>> statement_list lvalue_list expr_list opt_expr_list
%type <std::list<ASTNode*>> argument_list else_statement
%type <std::list<std::string>> id_list

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

%type <std::string> STRING IDENTIFIER
%type <char> CHARACTER
%type <int> NUMBER									
									
									/*---Operations Precedence---*/
%left '=' "<>" '<' '>' "<=" ">="
%left '+' "o"
%left '*' "div" "mod" 'y' 
%left "no" '-'  

%%

input:	                    	program																{
																										std::cout << $1->toString() << std::endl << std::endl;
																										($1)->genCode(handler);

																										std::cout << ($1)->code << std::endl;
																										std::ofstream out("../ASM/file.asm");
    																									out << ($1)->code;
    																									out.close();
																									}											
;

program:	              		opt_subtype_definition_section
								opt_variable_section
								opt_subprogram_decl
								"inicio" opt_eols
								statement_list eols
								"fin" opt_eols														{ 
																										for (auto const &vars: $2) {
																											VariableDeclaration* varsPtr = static_cast<VariableDeclaration*>(vars);
																											varsPtr->loadVariables(handler);
																										}

																										for (auto const &method: $3) {
																											if (method->isA(ProcedureDeclaration_kind)) {
																												ProcedureDeclaration* methodPtr = static_cast<ProcedureDeclaration*>(method);
																												methodPtr->loadProcedures(handler);
																											} else {
																												FunctionDeclaration* funcPtr = static_cast<FunctionDeclaration*>(method);
																												funcPtr->loadFunctions(handler);
																											}
																										}
																													

																										std::cout << handler.getDataSection() << std::endl;

																										$$ = pool.ProgramNodeCreate(lexer.getLineNo(), $1, $2, $3, $6); 
																										
																									}								
;

opt_subtype_definition_section: subtype_definition_section eols										{ $$ = $1; }
                                |%empty																{ 
																										std::list<ASTNode*> emptyList;
																										$$ = emptyList;
																									}
;

subtype_definition_section:		subtype_definition_section eols "tipo" IDENTIFIER "es" type			{ $$ = $1; $$.emplace_back(pool.SubTypeDeclarationCreate(lexer.getLineNo(), $4, $6)); }		
								|"tipo" IDENTIFIER "es" type										{ $$.emplace_back(pool.SubTypeDeclarationCreate(lexer.getLineNo(), $2, $4)); }
;

type:                       	"entero"															{ $$ = pool.TypeCreate(lexer.getLineNo(), 0, 0, 0); }
								|"booleano"															{ $$ = pool.TypeCreate(lexer.getLineNo(), 1, 0, 0); }
								|"caracter"															{ $$ = pool.TypeCreate(lexer.getLineNo(), 2, 0, 0); }
								|array_type															{ $$ = $1; }
;

array_type:     	        	"arreglo" '[' NUMBER ']' "de" type									{ $$ = pool.TypeCreate(lexer.getLineNo(), 3, $3, $6); }
;

opt_variable_section:	    	variable_section eols												{ $$ = $1; }											
                            	|%empty																{ 
																										std::list<ASTNode*> emptyList;
																										$$ = emptyList;
																									}
;

variable_section:	        	variable_section eols type id_list									{ $$ = $1; $$.emplace_back(pool.VariableDeclarationCreate(lexer.getLineNo(), $3, $4)); }
								|type id_list														{ $$.emplace_back(pool.VariableDeclarationCreate(lexer.getLineNo(), $1, $2)); }
;

id_list:						id_list	',' IDENTIFIER												{ $$ = $1; $$.emplace_back($3); }									
								|IDENTIFIER															{ $$.emplace_back($1); }
;

opt_subprogram_decl:			subprogram_decl_list eols											{ $$ = $1; }
                            	|%empty																{ 
																										std::list<ASTNode*> emptyList;
																										$$ = emptyList;
																									}
;

subprogram_decl_list:			subprogram_decl_list eols subprogram_decl							{ $$ = $1; $$.emplace_back($3); }
								|subprogram_decl													{ $$.emplace_back($1); }
;

subprogram_decl:				"funcion" IDENTIFIER opt_arguments ':' type eols
								opt_variable_section
								"inicio" opt_eols
								statement_list eols
								"fin"																{ $$ = pool.FunctionDeclarationCreate(lexer.getLineNo(), $2, $3, $5, $7, $10); }
								|"procedimiento" IDENTIFIER opt_arguments eols
								opt_variable_section
								"inicio" opt_eols
								statement_list eols
								"fin"																{ $$ = pool.ProcedureDeclarationCreate(lexer.getLineNo(), $2, $3, $5, $8); }
;

opt_arguments:					'(' argument_decl_list ')'											{ $$ = $2; }
                            	|%empty																{ 
																										std::list<ASTNode*> emptyList;
																										$$ = emptyList;
																									}
;

argument_decl_list:	        	argument_decl_list ',' type IDENTIFIER								{ $$ = $1; $$.emplace_back(pool.ArgumentDeclarationCreate(lexer.getLineNo(), $3, $4)); }
								|argument_decl_list ',' "var" type IDENTIFIER						{ $$ = $1; $$.emplace_back(pool.ArgumentDeclarationCreate(lexer.getLineNo(), $4, $5)); }
								|type IDENTIFIER													{ $$.emplace_back(pool.ArgumentDeclarationCreate(lexer.getLineNo(), $1, $2)); }
								|"var" type IDENTIFIER												{ $$.emplace_back(pool.ArgumentDeclarationCreate(lexer.getLineNo(), $2, $3)); }
;

statement_list:					statement_list eols statement										{ $$ = $1; $$.emplace_back($3); }
								|statement															{ $$.emplace_back($1); }
;

statement:						assign																{ $$ = $1; }
								|"llamar" IDENTIFIER												{ $$ = pool.CallStatementCreate(lexer.getLineNo(), (pool.LeftValueCreate(lexer.getLineNo(), $2, nullptr))); }
								|"llamar" subprogram_call											{ $$ = pool.CallStatementCreate(lexer.getLineNo(), $2); }
								|"escriba" argument_list											{ $$ = pool.WriteStatementCreate(lexer.getLineNo(), $2); }
								|"lea" lvalue_list													{ $$ = pool.ReadStatementCreate(lexer.getLineNo(), $2); }
								|if_statement														{ $$ = $1; }
								|"mientras" expr opt_eols 
								"haga" eols
								statement_list eols
								"fin" "mientras"													{ $$ = pool.WhileStatementCreate(lexer.getLineNo(), $2, $6); }
								|"repita" eols
								statement_list eols
								"hasta" expr														{ $$ = pool.RepeatStatementCreate(lexer.getLineNo(), $3, $6); }
								|"para" assign "hasta" expr "haga" eols				
								statement_list eols
								"fin" "para"														{ $$ = pool.ForStatementCreate(lexer.getLineNo(), $2, $4, $7); }
								|"retorne" expr														{ $$ = pool.ReturnStatementCreate(lexer.getLineNo(), $2); std::cout << $$->toString() << std::endl; }
;

assign:							lvalue "<-" expr													{ $$ = pool.AssignStatementCreate(lexer.getLineNo(), $1, $3);}
;

lvalue_list:					lvalue_list ',' lvalue												{ $$ = $1; $$.emplace_back($3); }
								|lvalue																{ $$.emplace_back($1); }
;

lvalue:	                    	IDENTIFIER															{ $$ = pool.LeftValueCreate(lexer.getLineNo(), $1, nullptr); }
								|IDENTIFIER '[' expr ']'											{ $$ = pool.LeftValueCreate(lexer.getLineNo(), $1, $3); }
;

opt_expr_list:	            	expr_list															{ $$ = $1; }
                            	|%empty																{ 
																										std::list<ASTNode*> emptyList;
																										$$ = emptyList;
																									}
;

expr_list:				    	expr_list ',' expr													{ $$ = $1; $$.emplace_back($3); }
								|expr																{ $$.emplace_back($1); }
;

expr:	                    	expr '=' term														{ $$ = pool.EqualExprCreate(lexer.getLineNo(), $1, $3); }
								|expr "<>" term														{ $$ = pool.NotEqExprCreate(lexer.getLineNo(), $1, $3); }
								|expr '<' term														{ $$ = pool.LessExprCreate(lexer.getLineNo(), $1, $3); }
								|expr '>' term														{ $$ = pool.GrtrExprCreate(lexer.getLineNo(), $1, $3); }
								|expr "<=" term														{ $$ = pool.LessEqExprCreate(lexer.getLineNo(), $1, $3); }
								|expr ">=" term														{ $$ = pool.GrtrEqExprCreate(lexer.getLineNo(), $1, $3); }
								|term																{ $$ = $1; }
;

term:	                    	term '+' factor														{ $$ = pool.AddExprCreate(lexer.getLineNo(), $1, $3); }
								|term '-' factor													{ $$ = pool.SubExprCreate(lexer.getLineNo(), $1, $3); }
								|term "o" factor													{ $$ = pool.OrExprCreate(lexer.getLineNo(), $1, $3); }
								|factor																{ $$ = $1; }
;

factor:							factor '*' exponent													{ $$ = pool.MulExprCreate(lexer.getLineNo(), $1, $3); }
								|factor "div" exponent												{ $$ = pool.DivExprCreate(lexer.getLineNo(), $1, $3); }
								|factor "mod" exponent												{ $$ = pool.ModExprCreate(lexer.getLineNo(), $1, $3); }
								|factor "y" exponent												{ $$ = pool.AndExprCreate(lexer.getLineNo(), $1, $3); }
								|exponent															{ $$ = $1; }
;

exponent:	                	exponent '^' rvalue													{ $$ = pool.ExponentExprCreate(lexer.getLineNo(), $1, $3); }
								|rvalue																{ $$ = $1; }
;

rvalue:                     	'(' expr ')'														{ $$ = $2; }
								|constant															{ $$ = $1; }
								|lvalue																{ $$ = $1; }
								|subprogram_call													{ $$ = $1; }
;

constant:                   	NUMBER																{ $$ = pool.NumExpressionCreate(lexer.getLineNo(), $1); }
								|CHARACTER															{ $$ = pool.CharExpressionCreate(lexer.getLineNo(), $1); }
								|"verdadero"														{ $$ = pool.BoolExpressionCreate(lexer.getLineNo(), 1); }
								|"falso"															{ $$ = pool.BoolExpressionCreate(lexer.getLineNo(), 0); }
;

subprogram_call:	        	IDENTIFIER '(' opt_expr_list ')'									{ $$ = pool.SubprogramCallCreate(lexer.getLineNo(), $1, $3); }
;

argument_list:					argument_list ',' expr												{ $$ = $1; $$.emplace_back($3); }
								|argument_list ',' STRING											{ $$ = $1; $$.emplace_back(pool.StringExpressionCreate(lexer.getLineNo(), $3)); }
								|expr																{ $$.emplace_back($1); }
								|STRING																{ $$.emplace_back(pool.StringExpressionCreate(lexer.getLineNo(), $1)); }
;

if_statement:					"si" expr opt_eols 
								"entonces" opt_eols
								statement_list eols
								else_statement
								"fin" "si"															{ $$ = pool.IfStatementCreate(lexer.getLineNo(), $2, $6, $8); }
;


else_statement:					"sino" eols statement_list eols										{ $$ = $3; }
								|%empty																{ 
																										std::list<ASTNode*> emptyList;
																										$$ = emptyList;
																									}
;

opt_eols:                   	eols
                            	|%empty
;

eols:	                    	eols '\n'											
								|'\n'												
;