%skeleton "lalr1.cc" /* -*- C++ -*- */
%require "3.0"
%defines
%define parser_class_name { sigma_bison_parser }

%define api.token.constructor
%define api.value.type variant
%define parse.assert
%define api.namespace { libdark }
%define api.location.type { libdark::location }

%code requires
{
    #include <string>
    #include <libdark/parser/master/location.hh>
    #include "../../sigma_ast_driver.hpp"
    #include <libdark/sigma/sigma_ast_node.hpp>

    namespace libdark {
        class sigma_flex_scanner;
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
    #include <libdark/sigma/sigma_ast_parser.hpp>
    
    // yylex() arguments are defined in parser.y
    static libdark::sigma_bison_parser::symbol_type yylex(
        libdark::sigma_flex_scanner &scanner,
        libdark::sigma_ast_driver &driver)
    {
        return scanner.get_next_token();
    }
    
    // you can accomplish the same thing by inlining the code using
    // preprocessor x and y are same as in above static function
    // #define yylex(x, y) scanner.get_next_token()
}

%output  "src/sigma/parser/generated/parser.cpp"
// Also output the header too
%defines "src/sigma/parser/generated/parser.hpp"

%lex-param { libdark::sigma_flex_scanner& scanner }
%lex-param { libdark::sigma_ast_driver& driver }
%parse-param { libdark::sigma_flex_scanner& scanner }
%parse-param { libdark::sigma_ast_driver& driver }
%locations
%define parse.trace
%define parse.error verbose

%define api.token.prefix {TOKEN_}

%token END 0 "end of file"

${token_list}

%type <libdark::sigma_ast_node::ptr>
${node_list}

%start program

%%
${grammar_code}
%%

// Bison expects us to provide implementation - otherwise linker complains
void libdark::sigma_bison_parser::error(
    const location &loc , const std::string &message)
{
    driver.error_message = message;
}
 
