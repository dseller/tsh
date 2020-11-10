%{

#include <stdint.h>
#include <stdio.h>

// #include "CompilerState.h"

extern int yylex();
extern int yyparse();
extern FILE *yyin;
extern char *yytext;
extern int yylineno;

void yyerror(const char *);

%}

%union {
  long long ival;
  const char *str;
  float fval;

  struct treenode *node;
}

%token<ival> T_INTEGER
%token<fval> T_FLOAT
%token<str> T_SYMBOL T_STRING
%token T_ACTOR T_BOPEN T_BCLOSE T_OBJECT T_SEMICOLON T_POPEN T_PCLOSE
%token T_COMMA T_ASSIGN T_DOT T_NEW T_WHILE T_NOTEQUAL T_EQUAL T_RETURN T_SWITCH
%token T_CASE T_PLUS T_MINUS T_DEC T_INC T_THIS T_NULL T_ASTERISK T_SLASH T_IF
%token T_ELSE T_LT T_GT T_LTE T_GTE T_AND T_OR T_AOPEN T_ACLOSE T_FOR T_BANG
%token T_TRUE T_FALSE T_STATIC T_INCLUDE T_QUOTE T_SHL T_SHR T_BAND T_BOR T_DEFINE
%token T_USE T_MOD T_ELLIPSIS T_DOLLAR T_DEBUGGER T_VOID

%type<str> use_statement attribute
%type<node> declaration primary_expression expression postfix_expression unary_expression assignment_expression add_expression mul_expression equality_expression cast_expression relational_expression shift_expression argument_expression_list
%type<node> case_statement case_statement_list selection_statement compound_statement statement_list iteration_statement statement statement_or_declaration function_definition parameter_declaration parameter_list jump_statement
%type<node> definition_list declaration_list expression_statement
%type<node> logical_or_expression logical_and_expression unary_operator bitwise_and_expression bitwise_or_expression tell_statement primary_expression_list attribute_list

%start definition_list

%%

primary_expression
	: T_SYMBOL													{ $$ = symbol($1); }
	| T_INTEGER													{ $$ = constant(INTEGER, fromint($1)); }
	| T_STRING													{ $$ = constant(STRING, fromstring($1)); }
	| T_FLOAT													{ ABORT_F("Floating point not supported yet.\n"); }
	| T_THIS													{ $$ = node(THIS, NULL, NULL); }
    | T_NULL													{ $$ = node(NULL_CONSTANT, NULL, NULL); }
	| T_TRUE													{ $$ = node(TRUE, NULL, NULL); }
	| T_FALSE													{ $$ = node(FALSE, NULL, NULL); }
	| T_DOLLAR													{ $$ = node(GET_VA, NULL, NULL); }
	| T_NEW T_SYMBOL T_POPEN T_PCLOSE							{ $$ = node(NEW_OBJ, constant(IDENTIFIER, fromstring($2)), NULL); }
	| T_NEW T_SYMBOL T_POPEN argument_expression_list T_PCLOSE	{ $$ = node(NEW_OBJ, constant(IDENTIFIER, fromstring($2)), $4); }
	| T_AOPEN primary_expression_list T_ACLOSE					{ $$ = node(ARRAY_INIT, NULL, $2); }
    | T_POPEN expression T_PCLOSE								{ $$ = $2; }
	;

attribute
    : T_AOPEN T_SYMBOL T_ACLOSE                                 { $$ = $2; }
    ;

attribute_list
    : attribute                                                 { $$ = node(ATTRIBUTE_LIST, constant(IDENTIFIER, fromstring($1)), NULL); }
    | attribute_list attribute                                  { $$ = node(ATTRIBUTE_LIST, constant(IDENTIFIER, fromstring($2)), $1); }
    ;

primary_expression_list
	: primary_expression										{ $$ = node(PRIM_EXP_LIST, $1, NULL); }
	| primary_expression_list T_COMMA primary_expression		{ $$ = node(PRIM_EXP_LIST, $3, $1); }
	;

postfix_expression
	: primary_expression
	| postfix_expression T_AOPEN expression T_ACLOSE			{ $$ = node(INDEX, $1, $3); }
	| postfix_expression T_POPEN T_PCLOSE						{ $$ = node(CALL, $1, NULL); }
	| postfix_expression T_POPEN argument_expression_list T_PCLOSE	{ $$ = node(CALL, $1, $3); }
	| postfix_expression T_DOT T_SYMBOL							{ $$ = node(GET_MEMBER, $1, constant(IDENTIFIER, fromstring($3))); }
	| postfix_expression T_DEC									{ $$ = node(DECREMENT, $1, NULL); }
	| postfix_expression T_INC									{ $$ = node(INCREMENT, $1, NULL); }
	;

argument_expression_list
	: assignment_expression										{ $$ = node(PARAM_LIST, $1, NULL); }
	| argument_expression_list T_COMMA assignment_expression	{ $$ = node(PARAM_LIST, $3, $1); }
	;

unary_expression
	: postfix_expression
	| unary_operator cast_expression							{ $$ = node(UNARY, $1, $2); }
	;

unary_operator
	: T_BANG													{ $$ = node(NOT, NULL, NULL); }
	;

cast_expression
	: unary_expression
	| T_POPEN T_SYMBOL T_PCLOSE cast_expression					{ $$ = node(CAST, constant(IDENTIFIER, fromstring($2)), $4); }
	;

mul_expression
	: cast_expression
	| mul_expression T_ASTERISK cast_expression					{ $$ = node(MULTIPLY, $1, $3); }
	| mul_expression T_SLASH cast_expression					{ $$ = node(DIVIDE, $1, $3); }
	| mul_expression T_MOD cast_expression						{ $$ = node(MODULO, $1, $3); }
	;

add_expression
	: mul_expression
	| add_expression T_PLUS mul_expression						{ $$ = node(ADD, $1, $3); }
	| add_expression T_MINUS mul_expression						{ $$ = node(SUB, $1, $3); }
	;

shift_expression
	: add_expression
	| shift_expression T_SHL add_expression						{ $$ = node(SHL, $1, $3); }
	| shift_expression T_SHR add_expression						{ $$ = node(SHR, $1, $3); }
	;

relational_expression
	: shift_expression
	| relational_expression T_LT shift_expression				{ $$ = node(LESS_THAN, $1, $3); }
	| relational_expression T_GT shift_expression				{ $$ = node(GREATER_THAN, $1, $3); }
	| relational_expression T_LTE shift_expression				{ $$ = node(LESS_THAN_OR_EQUAL, $1, $3); }
	| relational_expression T_GTE shift_expression				{ $$ = node(GREATER_THAN_OR_EQUAL, $1, $3); }
	;

equality_expression
	: relational_expression
	| equality_expression T_EQUAL relational_expression		    { $$ = node(EQUALS, $1, $3); }
	| equality_expression T_NOTEQUAL relational_expression		{ $$ = node(NOT_EQUALS, $1, $3); }
	;

bitwise_and_expression
	: equality_expression
	| bitwise_and_expression T_BAND equality_expression			{ $$ = node(BAND, $1, $3); }
	;

bitwise_or_expression
	: bitwise_and_expression
	| bitwise_or_expression T_BOR bitwise_and_expression		{ $$ = node(BOR, $1, $3); }
	;

logical_and_expression
	: bitwise_or_expression
    | logical_and_expression T_AND bitwise_or_expression        { $$ = node(AND, $1, $3); }
	;

logical_or_expression
	: logical_and_expression
	| logical_or_expression T_OR logical_and_expression			{ $$ = node(OR, $1, $3); }
	;

assignment_expression
	: logical_or_expression
	| unary_expression T_ASSIGN assignment_expression			{ $$ = node(ASSIGN, $1, $3); }
	;

expression
	: assignment_expression
	| T_DEBUGGER                                                { $$ = node(DEBUGGER, NULL, NULL); }
	;

declaration
	: T_SYMBOL T_SYMBOL											{ $$ = node(DECL_VAR, constant(IDENTIFIER, fromstring($1)), constant(IDENTIFIER, fromstring($2))); }
	| T_SYMBOL T_SYMBOL T_ASSIGN expression						{ $$ = node3(DECL_VAR, constant(IDENTIFIER, fromstring($1)), constant(IDENTIFIER, fromstring($2)), $4); }
	| declaration T_COMMA T_SYMBOL								//{ $$ = node3(DECL_VAR, constant(IDENTIFIER, $1->constant), constant(IDENTIFIER, fromstring($3)), $1); }
	;

declaration_list
	: declaration T_SEMICOLON									{ $$ = node(STATEMENT_LIST, $1, NULL); }
	| declaration_list declaration T_SEMICOLON					{ $$ = node(STATEMENT_LIST, $2, $1); }
	;

expression_statement
	: T_SEMICOLON												{ $$ = NULL; }
	| expression T_SEMICOLON									{ $$ = $1; }
	;

case_statement
	: T_CASE primary_expression compound_statement				{ $$ = node(CASE, $2, $3); }
	;

case_statement_list
	: case_statement											{ $$ = node(STATEMENT_LIST, $1, NULL); }
	| case_statement_list case_statement						{ $$ = node(STATEMENT_LIST, $2, $1);  }
	;

selection_statement
	: T_IF T_POPEN expression T_PCLOSE compound_statement							{ $$ = node(IF, $3, $5); }
	| T_IF T_POPEN expression T_PCLOSE compound_statement T_ELSE compound_statement { $$ = node3(IF, $3, $5, $7); }
	| T_SWITCH T_POPEN expression T_PCLOSE T_BOPEN case_statement_list T_BCLOSE		{ $$ = node(SWITCH, $3, $6); }
	;

compound_statement
	: T_BOPEN T_BCLOSE											{ $$ = NULL; }
	| T_BOPEN statement_list T_BCLOSE							{ $$ = $2; }
	;

iteration_statement
	: T_WHILE T_POPEN expression T_PCLOSE statement												{ $$ = node(WHILE, $3, $5); }
	| T_FOR T_POPEN expression_statement expression_statement T_PCLOSE statement				{ $$ = node(FOR, node3(FOR_EXP, $3, NULL, $4), $6); }
	| T_FOR T_POPEN expression_statement expression_statement expression T_PCLOSE statement		{ $$ = node(FOR, node3(FOR_EXP, $3, $5, $4), $7); }
	| T_FOR T_POPEN declaration T_SEMICOLON expression_statement T_PCLOSE statement				{ $$ = node(FOR, node3(FOR_EXP, $3, NULL, $5), $7); }
	| T_FOR T_POPEN declaration T_SEMICOLON expression_statement expression T_PCLOSE statement	{ $$ = node(FOR, node3(FOR_EXP, $3, $6, $5), $8); }
	;

jump_statement
	: T_RETURN T_SEMICOLON										{ $$ = node(RETURN, NULL, NULL); }
	| T_RETURN expression T_SEMICOLON							{ $$ = node(RETURN, $2, NULL); }
	;

use_statement
	: T_USE T_SYMBOL T_SEMICOLON								{ $$ = $2; }
	;

tell_statement
	: expression T_BANG expression T_SEMICOLON					{ $$ = node(TELL, $1, $3); }
	;

statement
	: compound_statement	
	| expression_statement
	| selection_statement
	| iteration_statement
	| jump_statement
	| tell_statement
	;

statement_or_declaration
	: declaration
	| statement
	;

statement_list
	: statement_or_declaration									{ $$ = node(STATEMENT_LIST, $1, NULL); }
	| statement_list statement_or_declaration					{ $$ = node(STATEMENT_LIST, $2, $1); }
	;

parameter_declaration
	: T_SYMBOL T_SYMBOL											{ $$ = node(DECL_PARAM, constant(IDENTIFIER, fromstring($1)), constant(IDENTIFIER, fromstring($2))); }
	| T_OBJECT T_SYMBOL											{ $$ = node(DECL_PARAM, constant(IDENTIFIER, fromstring("object")), constant(IDENTIFIER, fromstring($2))); }
	;

parameter_list
	: parameter_declaration										{ $$ = node(PARAM_LIST, $1, NULL); }
	| parameter_list T_COMMA parameter_declaration				{ $$ = node(PARAM_LIST, $3, $1); }
	| T_ELLIPSIS												{ $$ = node(VARARG, NULL, NULL); }
	;

function_definition
	: T_SYMBOL T_SYMBOL T_POPEN parameter_list T_PCLOSE compound_statement		{ $$ = node3(FUNCTION, node(DECL_VAR, constant(IDENTIFIER, fromstring($1)), constant(IDENTIFIER, fromstring($2))), $6, $4); }
	| T_SYMBOL T_SYMBOL T_POPEN T_PCLOSE compound_statement						{ $$ = node(FUNCTION, node(DECL_VAR, constant(IDENTIFIER, fromstring($1)), constant(IDENTIFIER, fromstring($2))), $5); }
	| T_SYMBOL T_POPEN T_PCLOSE compound_statement								{ $$ = node(FUNCTION, node(DECL_VAR, constant(IDENTIFIER, fromstring("void")), constant(IDENTIFIER, fromstring($1))), $4); }
	| T_SYMBOL T_POPEN parameter_list T_PCLOSE compound_statement				{ $$ = node3(FUNCTION, node(DECL_VAR, constant(IDENTIFIER, fromstring("void")), constant(IDENTIFIER, fromstring($1))), $5, $3); }
	;

definition
	: object_definition											{ define_object($1, NULL); }
	| attribute_list object_definition                          { define_object($2, $1); }
	| T_STATIC object_definition								{ define_static_object($2); }
	| message_definition										{ define_message($1, NULL); }
	| attribute_list message_definition                         { define_message($2, $1); }
	| actor_definition											{ define_actor($1, NULL); }
	| attribute_list actor_definition							{ define_actor($2, $1); }
	| use_statement												{ use($1); }
	| define_statement											{ $$ = NULL; }
	| include_statement											{ include($1); }
	;

definition_list
	: function_definition										{ $$ = node(DEFINITION_LIST, $1, NULL); }
	| definition_list definition								{ $$ = node(DEFINITION_LIST, $2, $1); }
	;

%%

void yyerror(const char *str) {
  // panic("Parse error: %s at '%s', line %i\n", str, yytext, yylineno);
  panic("Parse error");
}