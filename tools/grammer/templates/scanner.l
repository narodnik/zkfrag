%{
    #include <iostream>
    #include <cstdlib>
    #include "../../${class_prefix}_ast_driver.hpp"
    #include "../scanner.hpp"
    #include <${include_path}/${class_prefix}_ast_parser.hpp>
    #include "parser.hpp"
    #include <libdark/parser/master/location.hh>
    
    // Original yyterminate() macro returns int. Since we're using
    // Bison 3 variants as tokens, we must redefine it to change type
    // from `int` to `sigma_bison_parser::semantic_type`
    #define yyterminate() ${library_name}::${class_prefix}_bison_parser::make_END(${library_name}::location());
    
    // This will track current scanner location.
    // Action is called when length of the token is known.
    #define YY_USER_ACTION driver_.increase_location(yyleng);
%}

%option nodefault
%option noyywrap
%option c++
%option yyclass="${class_prefix}_flex_scanner"
%option prefix="${library_name}_${class_prefix}_"
%option outfile="src/sigma/parser/generated/scanner.cpp" header-file="src/sigma/parser/generated/scanner.hpp"

%%
${flex_tokens}
            
<<EOF>> {
            return yyterminate();
        }

%%
