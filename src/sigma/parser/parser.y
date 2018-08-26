%skeleton "lalr1.cc" /* -*- C++ -*- */
%require "3.0"
%defines
%define parser_class_name { bison_parser }

%define api.token.constructor
%define api.value.type variant
%define parse.assert
%define api.namespace { libdark }
%code requires
{
    #include <string>
    #include <libdark/sigma/ast_node.hpp>

    namespace libdark {
        class flex_scanner;
        class ast_driver;
    }
}

// Bison calls yylex() function that must be provided by us to suck tokens
// from the scanner.
// This block will be placed at the beginning of IMPLEMENTATION file (cpp).
// We define this function here (function! not method).
// This function is called only inside Bison, so we make it static to
// limit symbol visibility for the linker to avoid potential linking conflicts.
%code top
{
    #include "../scanner.hpp"
    #include "parser.hpp"
    #include <libdark/sigma/ast_parser.hpp>
    #include "location.hh"
    
    // yylex() arguments are defined in parser.y
    static libdark::bison_parser::symbol_type yylex(
        libdark::flex_scanner &scanner, libdark::ast_driver &driver)
    {
        return scanner.get_next_token();
    }
    
    // you can accomplish the same thing by inlining the code using preprocessor
    // x and y are same as in above static function
    // #define yylex(x, y) scanner.get_next_token()
}

%output  "src/sigma/parser/generated/parser.cpp"
// Also output the header too
%defines "src/sigma/parser/generated/parser.hpp"

%lex-param { libdark::flex_scanner &scanner }
%lex-param { libdark::ast_driver &driver }
%parse-param { libdark::flex_scanner &scanner }
%parse-param { libdark::ast_driver &driver }
%locations
%define parse.trace
%define parse.error verbose

%define api.token.prefix {TOKEN_}

%token END 0 "end of file"

%token COMMA "comma"
%token COLON "colon"
%token EQUAL "equal"
%token MULTIPLY "multiply"
%token PLUS "plus"
%token PRIVATE "private"
%token PROVE "prove"
%token LESS_EQ "less_eq"
%token GREATER_EQ "greater_eq"
%token LESS "less"
%token GREATER "greater"
%token L_BRACKET "l_bracket"
%token R_BRACKET "r_bracket"
%token REPRESENT "represent"
%token LINEAR_EQUATION "linear_equation"
%token RANGE_PROOF "range_proof"
%token ANY "any"
%token ALL "all"
%token VERSION "version"
%token DOT "dot"
%token <std::string> NUMBER "number";
%token <std::string> TOKEN "token";

%type < libdark::ast_node_ptr > program header version_number
    private private_value prove statement
    represent linear_equation range_proof any all
    equality_expression range_expression expression item

%type < libdark::ast_node_list > private_values statements

%start program

%%

program:
	header private prove
    {
        $$ = std::make_shared<libdark::ast_node>(libdark::ast_type::root);
        $$->children.push_back($1);
        $$->children.push_back($2);
        $$->children.push_back($3);

        driver.root = $$;
    }
	;
header:
	VERSION version_number
    {
        $$ = $2;
    }
	;
version_number:
    NUMBER DOT NUMBER
    {
        std::string version = $1;
        version += ".";
        version += $3;
        $$ = std::make_shared<libdark::ast_node>(
            libdark::ast_type::version, version);
    }
    | NUMBER DOT NUMBER DOT NUMBER
    {
        std::string version = $1;
        version += ".";
        version += $3;
        version += ".";
        version += $5;
        $$ = std::make_shared<libdark::ast_node>(
            libdark::ast_type::version, version);
    }

private:
    PRIVATE COLON private_values
    {
        $$ = std::make_shared<libdark::ast_node>(
            libdark::ast_type::private_section);
        $$->children = std::move($3);
    }
    ;
private_values:
    private_values COMMA private_value
    {
        $1.push_back($3);
        $$ = std::move($1);
    }
    | private_value
    {
        $$.push_back($1);
    }
    ;
private_value:
    TOKEN
    {
        $$ = std::make_shared<libdark::ast_node>(
            libdark::ast_type::private_value, $1);
    }
    ;

prove:
    PROVE COLON statements
    {
        $$ = std::make_shared<libdark::ast_node>(
            libdark::ast_type::prove_section);
        $$->children = std::move($3);
    }
    | PROVE COLON
    {
        $$ = std::make_shared<libdark::ast_node>(
            libdark::ast_type::prove_section);
    }
    ;
statements:
    statements COMMA statement
    {
        $1.push_back($3);
        $$ = std::move($1);
    }
    | statement
    {
        $$.push_back($1);
    }
    ;
statement:
    represent
    {
        $$ = std::move($1);
    }
    | linear_equation
    {
        $$ = std::move($1);
    }
    | range_proof
    {
        $$ = std::move($1);
    }
    | any
    {
        $$ = std::move($1);
    }
    | all
    {
        $$ = std::move($1);
    }
    ;

represent:
    REPRESENT L_BRACKET equality_expression R_BRACKET
    {
        $$ = std::make_shared<libdark::ast_node>(
            libdark::ast_type::represent);
        $$->children.push_back($3);
    }
    ;

linear_equation:
    LINEAR_EQUATION L_BRACKET equality_expression R_BRACKET
    {
        $$ = std::make_shared<libdark::ast_node>(
            libdark::ast_type::linear_equation);
        $$->children.push_back($3);
    }
    ;

range_proof:
    RANGE_PROOF L_BRACKET range_expression R_BRACKET
    {
        $$ = std::make_shared<libdark::ast_node>(
            libdark::ast_type::range_proof);
        $$->children.push_back($3);
    }
    ;

equality_expression:
    expression EQUAL expression
    {
        $$ = std::make_shared<libdark::ast_node>(
            libdark::ast_type::equal);
        $$->children.push_back($1);
        $$->children.push_back($3);
    }
    ;

range_expression:
    expression LESS_EQ expression
    {
        $$ = std::make_shared<libdark::ast_node>(
            libdark::ast_type::less_equal);
        $$->children.push_back($1);
        $$->children.push_back($3);
    }
    | expression GREATER_EQ expression
    {
        $$ = std::make_shared<libdark::ast_node>(
            libdark::ast_type::greater_equal);
        $$->children.push_back($1);
        $$->children.push_back($3);
    }
    | expression LESS expression
    {
        $$ = std::make_shared<libdark::ast_node>(
            libdark::ast_type::less);
        $$->children.push_back($1);
        $$->children.push_back($3);
    }
    | expression GREATER expression
    {
        $$ = std::make_shared<libdark::ast_node>(
            libdark::ast_type::greater);
        $$->children.push_back($1);
        $$->children.push_back($3);
    }
    ;

expression:
    expression PLUS item
    {
        $1->children.push_back($3);
        $$ = std::move($1);
    }
    | item
    {
        $$ = std::make_shared<libdark::ast_node>(
            libdark::ast_type::sum);
        $$->children.push_back($1);
    }
    ;

item:
    TOKEN TOKEN
    {
        $$ = std::make_shared<libdark::ast_node>(
            libdark::ast_type::multiply);
        auto value_1 = std::make_shared<libdark::ast_node>(
            libdark::ast_type::variable, $1);
        auto value_2 = std::make_shared<libdark::ast_node>(
            libdark::ast_type::variable, $2);
        $$->children.push_back(value_1);
        $$->children.push_back(value_2);
    }
    | TOKEN MULTIPLY TOKEN
    {
        $$ = std::make_shared<libdark::ast_node>(
            libdark::ast_type::multiply);
        auto value_1 = std::make_shared<libdark::ast_node>(
            libdark::ast_type::variable, $1);
        auto value_2 = std::make_shared<libdark::ast_node>(
            libdark::ast_type::variable, $3);
        $$->children.push_back(value_1);
        $$->children.push_back(value_2);
    }
    | TOKEN
    {
        $$ = std::make_shared<libdark::ast_node>(
            libdark::ast_type::variable, $1);
    }
    | NUMBER TOKEN
    {
        $$ = std::make_shared<libdark::ast_node>(
            libdark::ast_type::multiply);
        auto value_1 = std::make_shared<libdark::ast_node>(
            libdark::ast_type::number, $1);
        auto value_2 = std::make_shared<libdark::ast_node>(
            libdark::ast_type::variable, $2);
        $$->children.push_back(value_1);
        $$->children.push_back(value_2);
    }
    | NUMBER
    {
        $$ = std::make_shared<libdark::ast_node>(
            libdark::ast_type::number, $1);
    }
    ;

any:
    ANY L_BRACKET statements R_BRACKET
    {
        $$ = std::make_shared<libdark::ast_node>(
            libdark::ast_type::any);
        $$->children = std::move($3);
    }
    ;

all:
    ALL L_BRACKET statements R_BRACKET
    {
        $$ = std::make_shared<libdark::ast_node>(
            libdark::ast_type::all);
        $$->children = std::move($3);
    }
    ;
    
%%

// Bison expects us to provide implementation - otherwise linker complains
void libdark::bison_parser::error(
    const location &loc , const std::string &message)
{
    driver.error_message = message;
}
 
