%{

#include <stdint.h>
#include <stdio.h>

#include "tsh.h"

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

  // struct treenode *node;
}

%token<ival> T_INTEGER
%token<str> T_STRING T_SYMBOL

%token T_ACTOR T_BOPEN T_BCLOSE T_OBJECT T_SEMICOLON T_POPEN T_PCLOSE
%token T_COMMA T_ASSIGN T_DOT T_NEW T_WHILE T_NOTEQUAL T_EQUAL T_RETURN T_SWITCH
%token T_CASE T_PLUS T_MINUS T_DEC T_INC T_THIS T_NULL T_ASTERISK T_SLASH T_IF
%token T_ELSE T_LT T_GT T_LTE T_GTE T_AND T_OR T_AOPEN T_ACLOSE T_FOR T_BANG
%token T_TRUE T_FALSE T_STATIC T_INCLUDE T_QUOTE T_SHL T_SHR T_BAND T_BOR T_DEFINE
%token T_USE T_MOD T_ELLIPSIS T_DOLLAR T_DEBUGGER T_VOID

%start root

%%

statement
    : T_STRING                                  { puts($1); }
    ;


statement_list
    : statement
    | statement_list statement

root
    : statement_list
    ;



%%

void yyerror(const char *str) {
  // ABORT_F("Parse error: %s at '%s', line %i\n", str, yytext, yylineno);
  panic("Parse error!");
}