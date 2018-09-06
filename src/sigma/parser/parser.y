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
        auto _P2608RG5L03L = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::root);
        _P2608RG5L03L->children.push_back($1);
        _P2608RG5L03L->children.push_back($2);
        _P2608RG5L03L->children.push_back($3);
        $$ = _P2608RG5L03L;

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
        auto _NPKQNGIJGR2M = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::number, $1);
        auto _7DGD4TLK7TY0 = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::number, $3);
        auto _PL1BMPUE04PQ = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::version);
        _PL1BMPUE04PQ->children.push_back(_NPKQNGIJGR2M);
        _PL1BMPUE04PQ->children.push_back(_7DGD4TLK7TY0);
        $$ = _PL1BMPUE04PQ;
    }
    | NUMBER DOT NUMBER DOT NUMBER
    {
        auto _M9VEF1QKT7IK = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::number, $1);
        auto _13DKF1SC3QFE = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::number, $3);
        auto _ED4F41B10GD9 = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::number, $5);
        auto _WE9JI3XPOGL6 = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::version);
        _WE9JI3XPOGL6->children.push_back(_M9VEF1QKT7IK);
        _WE9JI3XPOGL6->children.push_back(_13DKF1SC3QFE);
        _WE9JI3XPOGL6->children.push_back(_ED4F41B10GD9);
        $$ = _WE9JI3XPOGL6;
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
        auto _IACFLKJEKAHK = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::private_section);
        _IACFLKJEKAHK->children.push_back($1);
        $$ = _IACFLKJEKAHK;
    }
    ;
private_value:
    TOKEN
    {
        auto _ELFI7808PT16 = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::private_value, $1);
        $$ = _ELFI7808PT16;
    }
    ;
prove:
    PROVE COLON statements
    {
        auto _WDMPVV9FCHGD = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::prove_section, $3->value);
        _WDMPVV9FCHGD->children = std::move($3->children);
        $$ = _WDMPVV9FCHGD;
    }
    | PROVE COLON
    {
        auto _1SFE44QN14HQ = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::prove_section);
        $$ = _1SFE44QN14HQ;
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
        auto _9ZYGTF57445T = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::template_);
        _9ZYGTF57445T->children.push_back($1);
        $$ = _9ZYGTF57445T;
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
        auto _71UF6GW5VAPY = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::represent);
        _71UF6GW5VAPY->children.push_back($3);
        $$ = _71UF6GW5VAPY;
    }
    ;
linear_equation:
    LINEAR_EQUATION L_BRACKET equality_expression R_BRACKET
    {
        auto _11DLLFY4I00Y = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::linear_equation);
        _11DLLFY4I00Y->children.push_back($3);
        $$ = _11DLLFY4I00Y;
    }
    ;
range_proof:
    RANGE_PROOF L_BRACKET range_expression R_BRACKET
    {
        auto _TMAS8N8I35UA = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::range_proof);
        _TMAS8N8I35UA->children.push_back($3);
        $$ = _TMAS8N8I35UA;
    }
    ;
equality_expression:
    expression EQUAL expression
    {
        auto _YJVI5F2S3XXL = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::equal);
        _YJVI5F2S3XXL->children.push_back($1);
        _YJVI5F2S3XXL->children.push_back($3);
        $$ = _YJVI5F2S3XXL;
    }
    ;
range_expression:
    expression LESS_EQ expression
    {
        auto _3SGQCWO1T74X = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::less_equal);
        _3SGQCWO1T74X->children.push_back($1);
        _3SGQCWO1T74X->children.push_back($3);
        $$ = _3SGQCWO1T74X;
    }
    | expression GREATER_EQ expression
    {
        auto _037DKD7Y0J4G = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::greater_equal);
        _037DKD7Y0J4G->children.push_back($1);
        _037DKD7Y0J4G->children.push_back($3);
        $$ = _037DKD7Y0J4G;
    }
    | expression LESS expression
    {
        auto _X1MOBLJAC9AG = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::less);
        _X1MOBLJAC9AG->children.push_back($1);
        _X1MOBLJAC9AG->children.push_back($3);
        $$ = _X1MOBLJAC9AG;
    }
    | expression GREATER expression
    {
        auto _XM40PX7ILXV0 = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::greater);
        _XM40PX7ILXV0->children.push_back($1);
        _XM40PX7ILXV0->children.push_back($3);
        $$ = _XM40PX7ILXV0;
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
        auto _ON73SA7G0PQB = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::negative);
        _ON73SA7G0PQB->children.push_back($3);
        auto negative = _ON73SA7G0PQB;
        $1->children.push_back(negative);
        $$ = $1;
    }
    | item
    {
        auto _TKVT2ERFSZXK = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::sum);
        _TKVT2ERFSZXK->children.push_back($1);
        $$ = _TKVT2ERFSZXK;
    }
    ;
item:
    TOKEN TOKEN
    {
        auto _SHS5LL3UKPBI = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::variable, $1);
        auto _XTCJVN7JAQFT = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::variable, $2);
        auto _EGRJ1I92XV2P = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::multiply);
        _EGRJ1I92XV2P->children.push_back(_SHS5LL3UKPBI);
        _EGRJ1I92XV2P->children.push_back(_XTCJVN7JAQFT);
        $$ = _EGRJ1I92XV2P;
    }
    | TOKEN MULTIPLY TOKEN
    {
        auto _FPD15SUYG01R = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::variable, $1);
        auto _1BY6LNFZDW6S = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::variable, $2);
        auto _S0ZVJ3O3TUBB = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::multiply);
        _S0ZVJ3O3TUBB->children.push_back(_FPD15SUYG01R);
        _S0ZVJ3O3TUBB->children.push_back(_1BY6LNFZDW6S);
        $$ = _S0ZVJ3O3TUBB;
    }
    | TOKEN
    {
        auto _SNQWVXQ7Z4PM = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::variable, $1);
        $$ = _SNQWVXQ7Z4PM;
    }
    | NUMBER TOKEN
    {
        auto _I27HTUYY72OS = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::number, $1);
        auto _383ZHMUT86T7 = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::variable, $2);
        auto _PG3O0J8NQCRN = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::multiply);
        _PG3O0J8NQCRN->children.push_back(_I27HTUYY72OS);
        _PG3O0J8NQCRN->children.push_back(_383ZHMUT86T7);
        $$ = _PG3O0J8NQCRN;
    }
    | NUMBER
    {
        auto _GQ21YC8Y5Q3T = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::number, $1);
        $$ = _GQ21YC8Y5Q3T;
    }
    ;
any:
    ANY L_BRACKET statements R_BRACKET
    {
        auto _UHTT7BKWY96U = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::any, $3->value);
        _UHTT7BKWY96U->children = std::move($3->children);
        $$ = _UHTT7BKWY96U;
    }
    ;
all:
    ALL L_BRACKET statements R_BRACKET
    {
        auto _ZCSPNRT1K65Z = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::all, $3->value);
        _ZCSPNRT1K65Z->children = std::move($3->children);
        $$ = _ZCSPNRT1K65Z;
    }
    ;

%%

// Bison expects us to provide implementation - otherwise linker complains
void libdark::sigma_bison_parser::error(
    const location &loc , const std::string &message)
{
    driver.error_message = message;
}
 
