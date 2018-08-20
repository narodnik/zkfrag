%{
#include <cstdio>
#include <iostream>
using namespace std;

// Declare stuff from Flex that Bison needs to know about:
extern "C" int yylex();
extern int yyparse();
extern FILE *yyin;
 
void yyerror(const char *s);
%}

// Bison fundamentally works by asking flex to get the next token, which it
// returns as an object of type "yystype".  But tokens could be of any
// arbitrary data type!  So we deal with that in Bison by defining a C union
// holding each of the types of tokens that Flex could return, and have Bison
// use that union instead of "int" for the definition of "yystype":
%union {
	int ival;
	float fval;
	char *sval;
}

// define the constant-string tokens:
%token COMMA COLON EQUAL MULTIPLY PLUS PRIVATE PROVE
%token LESS_EQ GREATER_EQ LESS GREATER
%token L_BRACKET R_BRACKET REPRESENT LINEAR_EQUATION RANGE_PROOF ANY ALL
%token VERSION

// Define the "terminal symbol" token types I'm going to use (in CAPS
// by convention), and associate each with a field of the union:
%token <ival> INT
%token <fval> FLOAT
%token <sval> TOKEN

%%

snazzle:
	header private prove { cout << "done with a snazzle file!" << endl; }
	;
header:
	VERSION FLOAT { cout << "reading a snazzle file version " << $2 << endl; }
	;

private:
    PRIVATE COLON private_values
    ;
private_values:
    private_values COMMA private_value
    | private_value
    ;
private_value:
    TOKEN { cout << "new variable: " << $1 << endl; }
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
    REPRESENT { cout << "represent:\n"; } L_BRACKET equality_expression R_BRACKET
    { cout << "endrepr" << endl; }

linear_equation:
    LINEAR_EQUATION { cout << "le:\n"; } L_BRACKET equality_expression R_BRACKET
    { cout << "endle" << endl; }
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
{ cout << "expr 1 2: " << $1 << " " << $2 << endl; }
    | TOKEN MULTIPLY TOKEN
{ cout << "expr 1 3: " << $1 << " " << $3 << endl; }
    | TOKEN
{ cout << "expr 1: " << $1 << endl; }
    | INT TOKEN
{ cout << "expr intm: " << $1 << " " << $2 << endl; }
    | INT
{ cout << "expr int: " << $1 << endl; }
    ;

any:
    ANY { cout << "any\n"; } L_BRACKET statements R_BRACKET
    { cout << "endany" << endl; }
    ;

all:
    ALL { cout << "all\n"; } L_BRACKET statements R_BRACKET
    { cout << "endall" << endl; }
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
	
}

void yyerror(const char *s) {
	cout << "EEK, parse error!  Message: " << s << endl;
	// might as well halt now:
	exit(-1);
}

