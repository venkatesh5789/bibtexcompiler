
/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton interface for Bison's Yacc-like parsers in C
   
      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

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
     TOKEN_ABBREV = 1,
     TOKEN_AT = 2,
     TOKEN_COMMA = 3,
     TOKEN_COMMENT = 4,
     TOKEN_ENTRY = 5,
     TOKEN_EQUALS = 6,
     TOKEN_FIELD = 7,
     TOKEN_INCLUDE = 8,
     TOKEN_INLINE = 9,
     TOKEN_KEY = 10,
     TOKEN_LBRACE = 11,
     TOKEN_LITERAL = 12,
     TOKEN_NEWLINE = 13,
     TOKEN_PREAMBLE = 14,
     TOKEN_RBRACE = 15,
     TOKEN_HASH = 16,
     TOKEN_SPACE = 17,
     TOKEN_STRING = 18,
     TOKEN_VALUE = 19,
     TOKEN_NUMBER = 258,
     TOKEN_UNKNOWN = 259
   };
#endif
/* Tokens.  */
#define TOKEN_ABBREV 1
#define TOKEN_AT 2
#define TOKEN_COMMA 3
#define TOKEN_COMMENT 4
#define TOKEN_ENTRY 5
#define TOKEN_EQUALS 6
#define TOKEN_FIELD 7
#define TOKEN_INCLUDE 8
#define TOKEN_INLINE 9
#define TOKEN_KEY 10
#define TOKEN_LBRACE 11
#define TOKEN_LITERAL 12
#define TOKEN_NEWLINE 13
#define TOKEN_PREAMBLE 14
#define TOKEN_RBRACE 15
#define TOKEN_HASH 16
#define TOKEN_SPACE 17
#define TOKEN_STRING 18
#define TOKEN_VALUE 19
#define TOKEN_NUMBER 258
#define TOKEN_UNKNOWN 259




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef char* YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;


