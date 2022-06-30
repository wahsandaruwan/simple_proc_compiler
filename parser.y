%{
/* ---C declarations--- */

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#include "lex.yy.c"

void yyerror(const char *s);
int yylex();
int yywrap();

void add(char c);
void insert();
int search(char *c);

struct dataType {
    char *id_name;
    char *data_type;
    char *symbol_type;
} symbol_table[35];

int count=0;
int q;
char st[20];
%}

%token VOID CHARACTER PRINT SCAN INT FLOAT CHAR FOR IF ELSE TRUE FALSE INT_NUM FLOAT_NUM ID LE GE EQ NE GT LT AND OR STR ADD MULTIPLY DIVIDE SUBTRACT UNARY INCLUDE RETURN

/* ---Descriptions of expected inputs--- */

%%
prog                                : headers startFunc '(' ')' '{' body return '}'
                                    ;

headers                             : headers headers
                                    | INCLUDE {add('H');}
                                    ;

startFunc                           : dtype ID {add('F');}
                                    ;

dtype                               : INT { insert(); }
                                    | FLOAT { insert(); }
                                    | CHAR { insert(); }
                                    | VOID { insert(); }
                                    ;

body                                : FOR {add('K');} '(' stmt ';' condition ';' stmt ')' '{' body '}'
                                    | IF {add('K');} '(' condition ')' '{' body '}' else
                                    | stmt ';'
                                    | body body
                                    | PRINT {add('K');} '(' STR ')' ';'
                                    | SCAN {add('K');} '(' STR ',' '&' ID ')' ';'
                                    ;
                                    
else                                : ELSE {add('K');} '{' body '}'
                                    |
                                    ;

condition                           : value relop value
                                    | TRUE {add('K');}
                                    | FALSE {add('K');}
                                    ;
                            
stmt                                : dtype ID {add('V');} init
                                    | ID '=' exp
                                    | ID relop exp
                                    | ID UNARY
                                    | UNARY ID
                                    ;

value                               : INT_NUM {add('C');}
                                    | FLOAT_NUM {add('C');}
                                    | CHARACTER {add('C');}
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

return                              : RETURN {add('K');} value ';'
                                    |
                                    ;
%%

/* ---Functions--- */

int main() {
    yyparse();

	printf("\nSYMBOL   DATATYPE   TYPE \n");

	int i=0;
	for(i=0; i<count; i++) {
		printf("%s\t%s\t%s\t\n", symbol_table[i].id_name, symbol_table[i].data_type, symbol_table[i].symbol_type);
	}

	printf("\n\n");
}

/ * Start - For Symbol Table */
int search(char *c) {
	int x;
	for(x=count-1; x>=0; x--) {
		if(strcmp(symbol_table[x].id_name, c)==0) {
			return -1;
			break;
		}
	}
	return 0;
}

void add(char c){
    q = search(yytext);

    if(!q){
        if(c == 'H'){
            symbol_table[count].id_name=strdup(yytext);
			symbol_table[count].data_type=strdup(st);
			symbol_table[count].symbol_type=strdup("Header");
			count++;
        }
        else if(c == 'K') {
			symbol_table[count].id_name=strdup(yytext);
			symbol_table[count].data_type=strdup("Unknown");
			symbol_table[count].symbol_type=strdup("Keyword\t");
			count++;
		}
		else if(c == 'V') {
			symbol_table[count].id_name=strdup(yytext);
			symbol_table[count].data_type=strdup(st);
			symbol_table[count].symbol_type=strdup("Variable");
			count++;
		}
		else if(c == 'C') {
			symbol_table[count].id_name=strdup(yytext);
			symbol_table[count].data_type=strdup("CONST");
			symbol_table[count].symbol_type=strdup("Constant");
			count++;
		}
		else if(c == 'F') {
			symbol_table[count].id_name=strdup(yytext);
			symbol_table[count].data_type=strdup(st);
			symbol_table[count].symbol_type=strdup("Function");
			count++;
		}
    }
}

void insert() {
	strcpy(st, yytext);
}

/ * End - For Symbol Table */

void yyerror(const char* msg) {
    fprintf(stderr, "%s\n", msg);
}