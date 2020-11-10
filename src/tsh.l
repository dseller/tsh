%{

#pragma warning (disable: 4005)

#include "tsh.h"
#include "convert.h"
#include "tsh.tab.h"

int isatty(int x) { return 0; }

const char *dostring(const char *);

#ifdef WIN32
#define strdup _strdup
#define fileno _fileno
#endif

#define ECHO

%}

%option yylineno
%option noyywrap

%%

"//".*										; // ignore comments
[/][*][^*]*[*]+([^*/][^*]*[*]+)*[/]			; // ignore multi-line comments (/* ... */)
[/][*]										{ panic("Unterminated comment"); }
[ \t\r\n]									; // ignore whitespace
[0-9]+										{ yylval.ival = atoi(yytext); return T_INTEGER; }
0x[0-9A-F]+									{ yylval.ival = hatoi(yytext + 2); return T_INTEGER; }
0b[0-1]+									{ yylval.ival = batoi(yytext + 2); return T_INTEGER; }
\"(\\.|[^\\"\n])*\"							{ yylval.str = dostring(yytext); return T_STRING; }
"case"										{ return T_CASE; }
"debugger"                                  { return T_DEBUGGER; }
"define"									{ return T_DEFINE; }
"else"										{ return T_ELSE; }
"for"										{ return T_FOR; }
"if"										{ return T_IF; }
"return"									{ return T_RETURN; }
"static"									{ return T_STATIC; }
"switch"									{ return T_SWITCH; }
"while"										{ return T_WHILE; }
"U0"										{ return T_U0; }
"U8"										{ return T_U8; }
[a-zA-Z_@]([a-zA-Z0-9_@])*					{ yylval.str = strdup(yytext); return T_SYMBOL; }
"!"											{ return T_BANG; }
"{"											{ return T_BOPEN; }
"}"											{ return T_BCLOSE; }
"["											{ return T_AOPEN; }
"]"											{ return T_ACLOSE; }
";"											{ return T_SEMICOLON; }
"("											{ return T_POPEN; } 
")"											{ return T_PCLOSE; }
","											{ return T_COMMA; }
"="											{ return T_ASSIGN; }
"."											{ return T_DOT; }
"&"											{ return T_BAND; }
"|"											{ return T_BOR; }
"!="										{ return T_NOTEQUAL; }
"=="										{ return T_EQUAL; }
"+"											{ return T_PLUS; }
"-"											{ return T_MINUS; }
"*"											{ return T_ASTERISK; }
"/"											{ return T_SLASH; }
"--"										{ return T_DEC; }
"++"										{ return T_INC; }
"<"											{ return T_LT; }
">"											{ return T_GT; }
"<="										{ return T_LTE; }
">="										{ return T_GTE; }
"&&"										{ return T_AND; }
"||"										{ return T_OR; }
"'"											{ return T_QUOTE; }
"<<"										{ return T_SHL; }
">>"										{ return T_SHR; }
"%"											{ return T_MOD; }
"..."										{ return T_ELLIPSIS; }

%%

const char *dostring(const char *str) {
  const char *ptr = (const char *)(str+1);
  char *result = (char *)malloc(strlen(ptr));
  memset(result, 0, strlen(ptr));

  // Handle escape characters.
  char *dst = result;
  for (char *p = (char *)ptr; *p != '"' && *p != NULL; p++) {
    if (*p == '\\') {
	  p++;
	  switch (*p) {
		case '\\':
		case '"':
		  *dst++ = *p;
		  break;

		case 'n':
		  *dst++ = '\n';
		  break;

		case 'r':
		  *dst++ = '\r';
		  break;

		case 't':
		  *dst++ = '\t';
		  break;
	  }
	}
	else
	  *dst++ = *p;
  }

  return (const char *)result;
}