/*
 * The MIT License (MIT)
 * 
 * Copyright (c) 2014 Krzysztof Narkiewicz <krzysztof.narkiewicz@ezaquarii.com>
 * 
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 * 
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 * 
 */

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
    #include <iostream>
    #include <string>
    #include <vector>
    #include <stdint.h>
    #include "../command.hpp"
    #include "../ast_node.hpp"

    namespace libdark {
        class flex_scanner;
        class ast_driver;
    }
}

// Bison calls yylex() function that must be provided by us to suck tokens
// from the scanner. This block will be placed at the beginning of IMPLEMENTATION file (cpp).
// We define this function here (function! not method).
// This function is called only inside Bison, so we make it static to limit symbol visibility for the linker
// to avoid potential linking conflicts.
%code top
{
    #include <iostream>
    #include "../scanner.hpp"
    #include "parser.hpp"
    #include "../ast_parser.hpp"
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
    
    using namespace libdark;
}

%output  "generated/parser.cpp"
// Also output the header too
%defines "generated/parser.hpp"

%lex-param { libdark::flex_scanner &scanner }
%lex-param { libdark::ast_driver &driver }
%parse-param { libdark::flex_scanner &scanner }
%parse-param { libdark::ast_driver &driver }
%locations
%define parse.trace
%define parse.error verbose

%define api.token.prefix {TOKEN_}

%token END 0 "end of file"
//%token <uint64_t> NUMBER "number";

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
%token <std::string> INT "int";
%token <std::string> TOKEN "token";

//%type< libdark::Command > command;
//%type< std::vector<uint64_t> > arguments;

%type < libdark::ast_node_ptr > program header version_number

%start program

%%

program:
	header private prove
    {
        $$ = std::make_shared<libdark::ast_node>(
            libdark::operation_type::root, $1, nullptr);
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
        $$ = std::make_shared<libdark::ast_node>(version);
        std::cout << "version: " << version << std::endl;
    }
    | INT DOT INT DOT INT
    {
        std::string version = $1;
        version += ".";
        version += $3;
        version += ".";
        version += $5;
        $$ = std::make_shared<libdark::ast_node>(version);
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
    {
        std::cout << "private value: " << $1 << std::endl;
    }
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

// Bison expects us to provide implementation - otherwise linker complains
void libdark::bison_parser::error(
    const location &loc , const std::string &message)
{
    std::cerr << "Error: " << message << std::endl
        << "Location: " << driver.location() << std::endl;
}
 
