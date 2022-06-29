%{
/* ---C declarations--- */

#include "parser.tab.h"

/* Keep track of the line number */
int countln = 0;
%}

/* Creates a scanner that stores a line number */
%option yylineno

/* ---Regular expressions--- */

ALPHA                   [a-zA-Z]
NUMBER                  [0-9]
UNARY                   "++"|"--"

/* ---Token specifications (Pattern -> Action)--- */

%%
"print"                         { return PRINT; }
"scan"                          { return SCAN; }
"int"                           { return INT; }
"float"                         { return FLOAT; }
"char"                          { return CHAR; }
"void"                          { return VOID; }
"return"                        { return RETURN; }
"for"	                        { return FOR; }
"if"	                        { return IF; }
"else"	                        { return ELSE; }
^"#include"[ ]*<.+\.h>          { return INCLUDE; }
"true"                          { return TRUE; }
"false"                         { return FALSE; }
[-]?{NUMBER}+                   { return INT_NUM; }
[-]?{NUMBER}+\.{NUMBER}{1,6}    { return FLOAT_NUM; }
{ALPHA}({ALPHA}|{NUMBER})*      { return ID; }
{UNARY}                         { return UNARY; }
"<="                            { return LE; }
">="                            { return GE; }
"=="                            { return EQ; }
"!="                            { return NE; }
">"	                            { return GT; }
"<"	                            { return LT; }
"&&"	                        { return AND; }
"||"	                        { return OR; }
"+"                             { return ADD; }
"-"                             { return SUBTRACT; }
"/"                             { return DIVIDE; }
"*"                             { return MULTIPLY; }
\/\/.*                          { ; }
\/\*(.*\n)*.*\*\/               { ; } 
[ \t]*                          { ; }
[\n]                            { countln++; }
.	                            { return *yytext; }
["].*["]                        { return STR; }
['].[']                         { return CHARACTER; }
%%

/* ---Functions--- */

/* Wrap up all */
int yywrap() {
    return 1;
}