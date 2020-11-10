/* A Bison parser, made by GNU Bison 2.3.  */

/* Skeleton interface for Bison's Yacc-like parsers in C

   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301, USA.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     T_INTEGER = 258,
     T_STRING = 259,
     T_SYMBOL = 260,
     T_ACTOR = 261,
     T_BOPEN = 262,
     T_BCLOSE = 263,
     T_OBJECT = 264,
     T_SEMICOLON = 265,
     T_POPEN = 266,
     T_PCLOSE = 267,
     T_COMMA = 268,
     T_ASSIGN = 269,
     T_DOT = 270,
     T_NEW = 271,
     T_WHILE = 272,
     T_NOTEQUAL = 273,
     T_EQUAL = 274,
     T_RETURN = 275,
     T_SWITCH = 276,
     T_CASE = 277,
     T_PLUS = 278,
     T_MINUS = 279,
     T_DEC = 280,
     T_INC = 281,
     T_THIS = 282,
     T_NULL = 283,
     T_ASTERISK = 284,
     T_SLASH = 285,
     T_IF = 286,
     T_ELSE = 287,
     T_LT = 288,
     T_GT = 289,
     T_LTE = 290,
     T_GTE = 291,
     T_AND = 292,
     T_OR = 293,
     T_AOPEN = 294,
     T_ACLOSE = 295,
     T_FOR = 296,
     T_BANG = 297,
     T_TRUE = 298,
     T_FALSE = 299,
     T_STATIC = 300,
     T_INCLUDE = 301,
     T_QUOTE = 302,
     T_SHL = 303,
     T_SHR = 304,
     T_BAND = 305,
     T_BOR = 306,
     T_DEFINE = 307,
     T_USE = 308,
     T_MOD = 309,
     T_ELLIPSIS = 310,
     T_DOLLAR = 311,
     T_DEBUGGER = 312,
     T_VOID = 313
   };
#endif
/* Tokens.  */
#define T_INTEGER 258
#define T_STRING 259
#define T_SYMBOL 260
#define T_ACTOR 261
#define T_BOPEN 262
#define T_BCLOSE 263
#define T_OBJECT 264
#define T_SEMICOLON 265
#define T_POPEN 266
#define T_PCLOSE 267
#define T_COMMA 268
#define T_ASSIGN 269
#define T_DOT 270
#define T_NEW 271
#define T_WHILE 272
#define T_NOTEQUAL 273
#define T_EQUAL 274
#define T_RETURN 275
#define T_SWITCH 276
#define T_CASE 277
#define T_PLUS 278
#define T_MINUS 279
#define T_DEC 280
#define T_INC 281
#define T_THIS 282
#define T_NULL 283
#define T_ASTERISK 284
#define T_SLASH 285
#define T_IF 286
#define T_ELSE 287
#define T_LT 288
#define T_GT 289
#define T_LTE 290
#define T_GTE 291
#define T_AND 292
#define T_OR 293
#define T_AOPEN 294
#define T_ACLOSE 295
#define T_FOR 296
#define T_BANG 297
#define T_TRUE 298
#define T_FALSE 299
#define T_STATIC 300
#define T_INCLUDE 301
#define T_QUOTE 302
#define T_SHL 303
#define T_SHR 304
#define T_BAND 305
#define T_BOR 306
#define T_DEFINE 307
#define T_USE 308
#define T_MOD 309
#define T_ELLIPSIS 310
#define T_DOLLAR 311
#define T_DEBUGGER 312
#define T_VOID 313




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
#line 20 "tsh.y"
{
  long long ival;
  const char *str;
  float fval;

  // struct treenode *node;
}
/* Line 1529 of yacc.c.  */
#line 173 "../include/tsh.tab.h"
	YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif

extern YYSTYPE yylval;

