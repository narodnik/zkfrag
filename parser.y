%{
#include <cstdio>
#include <iostream>
using namespace std;

#include "../ast_node.hpp"

// Declare stuff from Flex that Bison needs to know about:
extern "C" int yylex();
extern int yyparse();
extern FILE *yyin;
 
void yyerror(const char* s);
%}

// Include libdark::ast_node in the parser header
%code requires {
#ifndef EXPR_INCLUDE_HEADER
#define EXPR_INCLUDE_HEADER

#include "../ast_node.hpp"

#endif
}

%output  "generated/parser.cpp"
// Also output the header too
%defines "generated/parser.hpp"

// Bison fundamentally works by asking flex to get the next token, which it
// returns as an object of type "yystype".  But tokens could be of any
// arbitrary data type!  So we deal with that in Bison by defining a C union
// holding each of the types of tokens that Flex could return, and have Bison
// use that union instead of "int" for the definition of "yystype":
%union {
	char *sval;
    libdark::ast_node* ast;
}

// define the constant-string tokens:
%token COMMA COLON EQUAL MULTIPLY PLUS PRIVATE PROVE
%token LESS_EQ GREATER_EQ LESS GREATER
%token L_BRACKET R_BRACKET REPRESENT LINEAR_EQUATION RANGE_PROOF ANY ALL
%token VERSION DOT

// Define the "terminal symbol" token types
// and associate each with a field of the union:
%token <sval> INT
%token <sval> TOKEN

%type <ast> program header version_number

%%

program:
	header private prove
    {
        $$ = new libdark::ast_node(libdark::operation_type::root, $1, nullptr);
    }
	;
header:
	VERSION version_number
    {
        $$ = $2;
    }
	;
version_number:
    INT DOT INT
    {
        std::string version = $1;
        version += ".";
        version += $3;
        $$ = new libdark::ast_node(version);
    }
    | INT DOT INT DOT INT
    {
        std::string version = $1;
        version += ".";
        version += $3;
        version += ".";
        version += $5;
        $$ = new libdark::ast_node(version);
    }

private:
    PRIVATE COLON private_values
    ;
private_values:
    private_values COMMA private_value
    | private_value
    ;
private_value:
    TOKEN
    ;

prove:
    PROVE COLON statements
    | PROVE COLON
    ;
statements:
    statements COMMA statement
    | statement
    ;
statement:
    represent | linear_equation | range_proof | any | all
    ;

represent:
    REPRESENT L_BRACKET equality_expression R_BRACKET
    ;

linear_equation:
    LINEAR_EQUATION L_BRACKET equality_expression R_BRACKET
    ;

range_proof:
    RANGE_PROOF L_BRACKET range_expression R_BRACKET
    ;

equality_expression:
    expression EQUAL expression

range_expression:
    expression LESS_EQ expression
    | expression GREATER_EQ expression
    | expression LESS expression
    | expression GREATER expression
    ;

expression:
    expression PLUS item
    | item
    ;

item:
    TOKEN TOKEN
    | TOKEN MULTIPLY TOKEN
    | TOKEN
    | INT TOKEN
    | INT
    ;

any:
    ANY L_BRACKET statements R_BRACKET
    ;

all:
    ALL L_BRACKET statements R_BRACKET
    ;

%%

int main(int, char**) {
	// Open a file handle to a particular file:
	FILE *myfile = fopen("a.snazzle.file", "r");
	// Make sure it is valid:
	if (!myfile) {
		cout << "I can't open a.snazzle.file!" << endl;
		return -1;
	}
	// Set Flex to read from it instead of defaulting to STDIN:
	yyin = myfile;
	
	// Parse through the input:
	yyparse();

    return 0;
}

void yyerror(const char* s) {
	cout << "EEK, parse error!  Message: " << s << endl;
	// might as well halt now:
	exit(-1);
}

