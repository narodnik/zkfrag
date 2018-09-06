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

%token <std::string> COMMA "comma"
%token <std::string> COLON "colon"
%token <std::string> LESS_EQ "less_eq"
%token <std::string> GREATER_EQ "greater_eq"
%token <std::string> LESS "less"
%token <std::string> GREATER "greater"
%token <std::string> EQUAL "equal"
%token <std::string> MULTIPLY "multiply"
%token <std::string> PLUS "plus"
%token <std::string> MINUS "minus"
%token <std::string> PRIVATE "private"
%token <std::string> PROVE "prove"
%token <std::string> L_BRACKET "l_bracket"
%token <std::string> R_BRACKET "r_bracket"
%token <std::string> REPRESENT "represent"
%token <std::string> LINEAR_EQUATION "linear_equation"
%token <std::string> RANGE_PROOF "range_proof"
%token <std::string> ANY "any"
%token <std::string> ALL "all"
%token <std::string> VERSION "version"
%token <std::string> DOT "dot"
%token <std::string> NUMBER "number"
%token <std::string> TOKEN "token"


%type <libdark::sigma_ast_node::ptr>
    program
    header
    version_number
    private
    private_values
    private_value
    prove
    statements
    statement
    represent
    linear_equation
    range_proof
    equality_expression
    range_expression
    expression
    item
    any
    all


%start program

%%
program:
    header private prove
    {
        auto _4ZWDX285TBHQ = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::root);
        _4ZWDX285TBHQ->children.push_back($1);
        _4ZWDX285TBHQ->children.push_back($2);
        _4ZWDX285TBHQ->children.push_back($3);
        $$ = _4ZWDX285TBHQ;

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
        auto _1GDMPJKJAN0N = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::version);
        //_1GDMPJKJAN0N->children.push_back($1);
        //_1GDMPJKJAN0N->children.push_back($3);
        $$ = _1GDMPJKJAN0N;
    }
    | NUMBER DOT NUMBER DOT NUMBER
    {
        auto _P8SVQDKTSNKF = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::version);
        //_P8SVQDKTSNKF->children.push_back($1);
        //_P8SVQDKTSNKF->children.push_back($3);
        //_P8SVQDKTSNKF->children.push_back($5);
        $$ = _P8SVQDKTSNKF;
    }
    ;
private:
    PRIVATE COLON private_values
    {
        $$ = $3;
    }
    ;
private_values:
    private_values COMMA private_value
    {
        $1->children.push_back($3);
        $$ = $1;
    }
    | private_value
    {
        auto _GS5S3LUYD8ON = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::private_section);
        _GS5S3LUYD8ON->children.push_back($1);
        $$ = _GS5S3LUYD8ON;
    }
    ;
private_value:
    TOKEN
    {
        auto _DF3YW2CBUP2M = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::private_value, $1);
        $$ = _DF3YW2CBUP2M;
    }
    ;
prove:
    PROVE COLON statements
    {
        auto _MMUN6LDK5INZ = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::prove_section, $3->value);
        _MMUN6LDK5INZ->children = std::move($3->children);
        $$ = _MMUN6LDK5INZ;
    }
    | PROVE COLON
    {
        auto _2R9BO5X622BF = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::prove_section);
        $$ = _2R9BO5X622BF;
    }
    ;
statements:
    statements COMMA statement
    {
        $1->children.push_back($3);
        $$ = $1;
    }
    | statement
    {
        auto _I86ALOAPCBRT = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::template_);
        _I86ALOAPCBRT->children.push_back($1);
        $$ = _I86ALOAPCBRT;
    }
    ;
statement:
    represent
    {
        $$ = $1;
    }
    | linear_equation
    {
        $$ = $1;
    }
    | range_proof
    {
        $$ = $1;
    }
    | any
    {
        $$ = $1;
    }
    | all
    {
        $$ = $1;
    }
    ;
represent:
    REPRESENT L_BRACKET equality_expression R_BRACKET
    {
        auto _EMTEZC1VZT5W = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::represent);
        _EMTEZC1VZT5W->children.push_back($3);
        $$ = _EMTEZC1VZT5W;
    }
    ;
linear_equation:
    LINEAR_EQUATION L_BRACKET equality_expression R_BRACKET
    {
        auto _R14JKMNV45XB = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::linear_equation);
        _R14JKMNV45XB->children.push_back($3);
        $$ = _R14JKMNV45XB;
    }
    ;
range_proof:
    RANGE_PROOF L_BRACKET range_expression R_BRACKET
    {
        auto _SRJHY9J61ZDA = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::range_proof);
        _SRJHY9J61ZDA->children.push_back($3);
        $$ = _SRJHY9J61ZDA;
    }
    ;
equality_expression:
    expression EQUAL expression
    {
        auto _611QAVPL55Y5 = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::equal);
        _611QAVPL55Y5->children.push_back($1);
        _611QAVPL55Y5->children.push_back($3);
        $$ = _611QAVPL55Y5;
    }
    ;
range_expression:
    expression LESS_EQ expression
    {
        auto _IKH79IES17TE = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::less_equal);
        _IKH79IES17TE->children.push_back($1);
        _IKH79IES17TE->children.push_back($3);
        $$ = _IKH79IES17TE;
    }
    | expression GREATER_EQ expression
    {
        auto _1XSL0UYQWY8W = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::greater_equal);
        _1XSL0UYQWY8W->children.push_back($1);
        _1XSL0UYQWY8W->children.push_back($3);
        $$ = _1XSL0UYQWY8W;
    }
    | expression LESS expression
    {
        auto _AVZV47PWGQ7Y = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::less);
        _AVZV47PWGQ7Y->children.push_back($1);
        _AVZV47PWGQ7Y->children.push_back($3);
        $$ = _AVZV47PWGQ7Y;
    }
    | expression GREATER expression
    {
        auto _7QJSMNU4505W = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::greater);
        _7QJSMNU4505W->children.push_back($1);
        _7QJSMNU4505W->children.push_back($3);
        $$ = _7QJSMNU4505W;
    }
    ;
expression:
    expression PLUS item
    {
        $1->children.push_back($3);
        $$ = $1;
    }
    | expression MINUS item
    {
        auto _5VSDO4LQLG3X = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::negative);
        _5VSDO4LQLG3X->children.push_back($3);
        auto negative = _5VSDO4LQLG3X;
        $1->children.push_back(negative);
        $$ = $1;
    }
    | item
    {
        auto _FYXG7538WK4Q = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::sum);
        _FYXG7538WK4Q->children.push_back($1);
        $$ = _FYXG7538WK4Q;
    }
    ;
item:
    TOKEN TOKEN
    {
        auto _U7803BM477UH = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::variable, $1);
        auto _0YCA1BSJXGWR = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::variable, $2);
        auto _UZPCE54BVE3G = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::multiply);
        _UZPCE54BVE3G->children.push_back(_U7803BM477UH);
        _UZPCE54BVE3G->children.push_back(_0YCA1BSJXGWR);
        $$ = _UZPCE54BVE3G;
    }
    | TOKEN MULTIPLY TOKEN
    {
        auto _I79SZ1WFCNXE = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::variable, $1);
        auto _HBUTI5A43D63 = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::variable, $2);
        auto _6VT1AQI078Y8 = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::multiply);
        _6VT1AQI078Y8->children.push_back(_I79SZ1WFCNXE);
        _6VT1AQI078Y8->children.push_back(_HBUTI5A43D63);
        $$ = _6VT1AQI078Y8;
    }
    | TOKEN
    {
        auto _GIRA7W7E2XR0 = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::variable, $1);
        $$ = _GIRA7W7E2XR0;
    }
    | NUMBER TOKEN
    {
        auto _ELFUWDMWI42K = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::number, $1);
        auto _BCRD9ZUVBZCG = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::variable, $2);
        auto _FFW2S475GQL6 = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::multiply);
        _FFW2S475GQL6->children.push_back(_ELFUWDMWI42K);
        _FFW2S475GQL6->children.push_back(_BCRD9ZUVBZCG);
        $$ = _FFW2S475GQL6;
    }
    | NUMBER
    {
        auto _EX3ZDJ8C9YZY = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::number, $1);
        $$ = _EX3ZDJ8C9YZY;
    }
    ;
any:
    ANY L_BRACKET statements R_BRACKET
    {
        auto _GWSRTE1G9EI4 = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::any, $3->value);
        _GWSRTE1G9EI4->children = std::move($3->children);
        $$ = _GWSRTE1G9EI4;
    }
    ;
all:
    ALL L_BRACKET statements R_BRACKET
    {
        auto _4RXDK4VKZGK4 = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::all, $3->value);
        _4RXDK4VKZGK4->children = std::move($3->children);
        $$ = _4RXDK4VKZGK4;
    }
    ;

%%

// Bison expects us to provide implementation - otherwise linker complains
void libdark::sigma_bison_parser::error(
    const location &loc , const std::string &message)
{
    driver.error_message = message;
}
 
