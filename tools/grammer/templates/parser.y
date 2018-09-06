%skeleton "lalr1.cc" /* -*- C++ -*- */
%require "3.0"
%defines
%define parser_class_name { sigma_bison_parser }

%define api.token.constructor
%define api.value.type variant
%define parse.assert
%define api.namespace { ${library_name} }
%define api.location.type { libdark::location }

%code requires
{
    #include <string>
    #include <libdark/parser/master/location.hh>
    #include "../../sigma_ast_driver.hpp"
    #include <${include_path}/${class_prefix}_ast_node.hpp>

    namespace ${library_name} {
        class ${class_prefix}_flex_scanner;
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
    #include <${include_path}/${class_prefix}_ast_parser.hpp>
    
    // yylex() arguments are defined in parser.y
    static ${library_name}::${class_prefix}_bison_parser::symbol_type yylex(
        ${library_name}::${class_prefix}_flex_scanner &scanner,
        ${library_name}::${class_prefix}_ast_driver &driver)
    {
        return scanner.get_next_token();
    }
    
    // you can accomplish the same thing by inlining the code using
    // preprocessor x and y are same as in above static function
    // #define yylex(x, y) scanner.get_next_token()
}

%lex-param { ${library_name}::${class_prefix}_flex_scanner& scanner }
%lex-param { ${library_name}::${class_prefix}_ast_driver& driver }
%parse-param { ${library_name}::${class_prefix}_flex_scanner& scanner }
%parse-param { ${library_name}::${class_prefix}_ast_driver& driver }
%locations
%define parse.trace
%define parse.error verbose

%define api.token.prefix {TOKEN_}

%token END 0 "end of file"

${token_list}

%type <${library_name}::${class_prefix}_ast_node::ptr>
${node_list}

%start program

%%
${grammar_code}
%%

// Bison expects us to provide implementation - otherwise linker complains
void ${library_name}::${class_prefix}_bison_parser::error(
    const location &loc , const std::string &message)
{
    driver.error_message = message;
}
 
