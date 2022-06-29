%{
/* ---C declarations--- */

/* Common imports */
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#include "lex.yy.c"

/* Prototypes for parsing */
void yyerror(const char *s);
int yylex();
int yywrap();

/* Prototypes for symbol table */
void add_symbol(char symbol_cat);
void insert_type();
int search_type(char *symbol);

/* Structure of the symbol table */
struct dataType {
    char *id_name;
    char *data_type;
    char *symbol_type;
    int line_no;
} symbol_table[40];

/* Variables for symbol table */
int count=0;
int query;
char type[10];
extern int countln;
%}

/* ---Yacc definitions--- */

%token VOID CHARACTER PRINT SCAN INT FLOAT CHAR FOR IF ELSE TRUE FALSE INT_NUM FLOAT_NUM ID LE GE EQ NE GT LT AND OR STR ADD MULTIPLY DIVIDE SUBTRACT UNARY INCLUDE RETURN

/* ---Descriptions of expected inputs | Corresponding actions--- */

%%
prog                                : headers startFunc '(' ')' '{' body return '}'
                                    ;

headers                             : headers headers
                                    | INCLUDE {add_symbol('H');}
                                    ;

startFunc                           : dtype ID {add_symbol('F');}
                                    ;

dtype                               : INT { insert_type(); }
                                    | FLOAT { insert_type(); }
                                    | CHAR { insert_type(); }
                                    | VOID { insert_type(); }
                                    ;

body                                : FOR {add_symbol('K');} '(' stmt ';' condition ';' stmt ')' '{' body '}'
                                    | IF {add_symbol('K');} '(' condition ')' '{' body '}' else
                                    | stmt ';'
                                    | body body
                                    | PRINT {add_symbol('K');} '(' STR ')' ';'
                                    | SCAN {add_symbol('K');} '(' STR ',' '&' ID ')' ';'
                                    ;
                                    
else                                : ELSE {add_symbol('K');} '{' body '}'
                                    |
                                    ;

condition                           : value relop value
                                    | TRUE {add_symbol('K');}
                                    | FALSE {add_symbol('K');}
                                    ;
                            
stmt                                : dtype ID {add_symbol('V');} init
                                    | ID '=' exp
                                    | ID relop exp
                                    | ID UNARY
                                    | UNARY ID
                                    ;

value                               : INT_NUM {add_symbol('C');}
                                    | FLOAT_NUM {add_symbol('C');}
                                    | CHARACTER {add_symbol('C');}
                                    | ID
                                    ;

relop                               : LT
                                    | GT
                                    | LE
                                    | GE
                                    | EQ
                                    | NE
                                    ;

init                                : '=' value
                                    |
                                    ;

exp                                 : exp arithop exp
                                    | value
                                    ;

arithop                             : ADD
                                    | SUBTRACT
                                    | MULTIPLY
                                    | DIVIDE
                                    ;

return                              : RETURN {add_symbol('K');} value ';'
                                    |
                                    ;
%%

/* ---Functions--- */

/* Parse the input file */
int main() {
    yyparse();

    printf("\n\n");
	printf("\t\t\t\t\t\t\t\t PHASE 1: LEXICAL ANALYSIS \n\n");
	printf("\nSYMBOL   DATATYPE   TYPE   LINE NUMBER \n");
	printf("_______________________________________\n\n");

	int i=0;
	for(i=0; i<count; i++) {
		printf("%s\t%s\t%s\t%d\t\n", symbol_table[i].id_name, symbol_table[i].data_type, symbol_table[i].symbol_type, symbol_table[i].line_no);
	}
	for(i=0;i<count;i++) {
		free(symbol_table[i].id_name);
		free(symbol_table[i].symbol_type);
	}

	printf("\n\n");
}

/*  Search symbols */
int search_type(char *symbol) {
	int x;
	for(x=count-1; x>=0; x--) {
		if(strcmp(symbol_table[x].id_name, symbol)==0) {
			return -1;
			break;
		}
	}
	return 0;
}

/* Adding the symbols to the symbol table */
void add_symbol(char symbol_cat){
    query = search_type(yytext);

    if(!query){
        if(symbol_cat == 'H'){
            symbol_table[count].id_name=strdup(yytext);
			symbol_table[count].data_type=strdup(type);
			symbol_table[count].line_no=countln;
			symbol_table[count].symbol_type=strdup("Header");
			count++;
        }
        else if(symbol_cat == 'K') {
			symbol_table[count].id_name=strdup(yytext);
			symbol_table[count].data_type=strdup("N/A");
			symbol_table[count].line_no=countln;
			symbol_table[count].symbol_type=strdup("Keyword\t");
			count++;
		}
		else if(symbol_cat == 'V') {
			symbol_table[count].id_name=strdup(yytext);
			symbol_table[count].data_type=strdup(type);
			symbol_table[count].line_no=countln;
			symbol_table[count].symbol_type=strdup("Variable");
			count++;
		}
		else if(symbol_cat == 'C') {
			symbol_table[count].id_name=strdup(yytext);
			symbol_table[count].data_type=strdup("CONST");
			symbol_table[count].line_no=countln;
			symbol_table[count].symbol_type=strdup("Constant");
			count++;
		}
		else if(symbol_cat == 'F') {
			symbol_table[count].id_name=strdup(yytext);
			symbol_table[count].data_type=strdup(type);
			symbol_table[count].line_no=countln;
			symbol_table[count].symbol_type=strdup("Function");
			count++;
		}
    }
}

/* Copy the data type of variables to the 'type' character array */
void insert_type() {
	strcpy(type, yytext);
}

/* Prints the errors that occur when we compile and execute our Yacc file */
void yyerror(const char* msg) {
    fprintf(stderr, "%s\n", msg);
}