%{

#include <stdint.h>
#include <stdio.h>

#include "ast.h"
#include "tsh.h"
#include "list.h"

// #include "CompilerState.h"

extern int yylex();
extern int yyparse();
extern FILE *yyin;
extern char *yytext;
extern int yylineno;

void yyerror(const char *);

typedef enum type_t {
    u0,
    u8,
    i8,
    u16,
    i16,
    u32,
    i32,
    u64,
    i64
} type_t;

%}

%union {
  long long ival;
  const char *str;
  float fval;
  enum type_t type;
  // struct linked_list *list;
  // struct operation_t *operation;

  struct node_t *node;
}

%token<ival> T_INTEGER
%token<str> T_STRING T_SYMBOL
%token<type> T_U0 T_U8

%token T_ACTOR T_BOPEN T_BCLOSE T_OBJECT T_SEMICOLON T_POPEN T_PCLOSE
%token T_COMMA T_ASSIGN T_DOT T_NEW T_WHILE T_NOTEQUAL T_EQUAL T_RETURN T_SWITCH
%token T_CASE T_PLUS T_MINUS T_DEC T_INC T_THIS T_NULL T_ASTERISK T_SLASH T_IF
%token T_ELSE T_LT T_GT T_LTE T_GTE T_AND T_OR T_AOPEN T_ACLOSE T_FOR T_BANG
%token T_TRUE T_FALSE T_STATIC T_INCLUDE T_QUOTE T_SHL T_SHR T_BAND T_BOR T_DEFINE
%token T_USE T_MOD T_ELLIPSIS T_DOLLAR T_DEBUGGER

%type<type> type
%type<node> statement statement_list compound_statement print_statement string

%start root

%%

string
    : T_STRING                                  { $$ = value_node(V_STRING, $1); }
    ;

type
    : T_U0                                      { $$ = u0; }
    | T_U8                                      { $$ = u8; }
    ;

function_definition
    : type T_SYMBOL T_POPEN T_PCLOSE compound_statement           { define_function($2, $1, $5); }
    ;

print_statement
    : string T_SEMICOLON                      { $$ = node2(PRINT, $1, NULL); }
    ;

statement
    : print_statement
    ;

compound_statement
	: T_BOPEN T_BCLOSE							{ $$ = NULL; }
	| T_BOPEN statement_list T_BCLOSE			{ $$ = $2; }
	;

statement_list
    : statement                     { $$ = node2(LIST, $1, NULL); }
    | statement_list statement      { $$ = node2(LIST, $2, $1); }

root_element
    : statement_list
    | function_definition
    ;

root
    : root_element
    | root root_element
    ;



%%

void yyerror(const char *str) {
  printf("Parse error: %s at '%s', line %i\n", str, yytext, yylineno);
  panic("Parse error!");
}