%{
    #include <iostream>
    #include <cstdlib>
    #include "../../sigma_ast_driver.hpp"
    #include "../scanner.hpp"
    #include <libdark/sigma/sigma_ast_parser.hpp>
    #include "parser.hpp"
    #include <libdark/parser/master/location.hh>
    
    // Original yyterminate() macro returns int. Since we're using
    // Bison 3 variants as tokens, we must redefine it to change type
    // from `int` to `sigma_bison_parser::semantic_type`
    #define yyterminate() libdark::sigma_bison_parser::make_END(libdark::location());
    
    // This will track current scanner location.
    // Action is called when length of the token is known.
    #define YY_USER_ACTION driver_.increase_location(yyleng);
%}

%option nodefault
%option noyywrap
%option c++
%option yyclass="sigma_flex_scanner"
%option prefix="libdark_"
%option outfile="src/sigma/parser/generated/scanner.cpp" header-file="src/sigma/parser/generated/scanner.hpp"

%%
[ \t\n] ;
,       {
            return libdark::sigma_bison_parser::make_COMMA(
                libdark::location());
        }
:       {
            return libdark::sigma_bison_parser::make_COLON(
                libdark::location());
        }
\<=     {
            return libdark::sigma_bison_parser::make_LESS_EQ(
                libdark::location());
        }
\>=     {
            return libdark::sigma_bison_parser::make_GREATER_EQ(
                libdark::location());
        }
\<      {
            return libdark::sigma_bison_parser::make_LESS(
                libdark::location());
        }
\>      {
            return libdark::sigma_bison_parser::make_GREATER(
                libdark::location());
        }
=       {
            return libdark::sigma_bison_parser::make_EQUAL(
                libdark::location());
        }
\*      {
            return libdark::sigma_bison_parser::make_MULTIPLY(
                libdark::location());
        }
\+      {
            return libdark::sigma_bison_parser::make_PLUS(
                libdark::location());
        }
\-      {
            return libdark::sigma_bison_parser::make_MINUS(
                libdark::location());
        }
private {
            return libdark::sigma_bison_parser::make_PRIVATE(
                libdark::location());
        }
prove   {
            return libdark::sigma_bison_parser::make_PROVE(
                libdark::location());
        }
\(      {
            return libdark::sigma_bison_parser::make_L_BRACKET(
                libdark::location());
        }
\)      {
            return libdark::sigma_bison_parser::make_R_BRACKET(
                libdark::location());
        }
represent {
            return libdark::sigma_bison_parser::make_REPRESENT(
                libdark::location());
        }
linear_equation {
            return libdark::sigma_bison_parser::make_LINEAR_EQUATION(
                libdark::location());
        }
range_proof {
            return libdark::sigma_bison_parser::make_RANGE_PROOF(
                libdark::location());
        }
any     {
            return libdark::sigma_bison_parser::make_ANY(
                libdark::location());
        }
all     {
            return libdark::sigma_bison_parser::make_ALL(
                libdark::location());
        }
version {
            return libdark::sigma_bison_parser::make_VERSION(
                libdark::location());
        }
\.      {
            return libdark::sigma_bison_parser::make_DOT(
                libdark::location());
        }
[0-9]+  {
            return libdark::sigma_bison_parser::make_NUMBER(
                yytext, libdark::location()); 
        }
[a-zA-Z]+[a-zA-Z0-9_]*  {
            return libdark::sigma_bison_parser::make_TOKEN(
                yytext, libdark::location()); 
        }
.       ;
            
<<EOF>> {
            return yyterminate();
        }

%%
