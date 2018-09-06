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
        auto _K2233E7SJ9MY = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::root);
        _K2233E7SJ9MY->children.push_back($1);
        _K2233E7SJ9MY->children.push_back($2);
        _K2233E7SJ9MY->children.push_back($3);
        $$ = _K2233E7SJ9MY;

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
        auto _COMM1AW5I45I = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::version);
        //_COMM1AW5I45I->children.push_back($1);
        //_COMM1AW5I45I->children.push_back($3);
        $$ = _COMM1AW5I45I;
    }
    | NUMBER DOT NUMBER DOT NUMBER
    {
        auto _92QOBEQQEMYI = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::version);
        //_92QOBEQQEMYI->children.push_back($1);
        //_92QOBEQQEMYI->children.push_back($3);
        //_92QOBEQQEMYI->children.push_back($5);
        $$ = _92QOBEQQEMYI;
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
        auto _1JSTIQEKD998 = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::private_section);
        _1JSTIQEKD998->children.push_back($1);
        $$ = _1JSTIQEKD998;
    }
    ;
private_value:
    TOKEN
    {
        auto _WKIDOBUYMJCE = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::private_value, $1);
        $$ = _WKIDOBUYMJCE;
    }
    ;
prove:
    PROVE COLON statements
    {
        auto _NP0JFB8IF3OU = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::prove_section, $3->value);
        _NP0JFB8IF3OU->children = std::move($3->children);
        $$ = _NP0JFB8IF3OU;
    }
    | PROVE COLON
    {
        auto _UBGZ7EGNJIQG = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::prove_section);
        $$ = _UBGZ7EGNJIQG;
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
        auto _Q4MX9DECUIPB = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::template_);
        _Q4MX9DECUIPB->children.push_back($1);
        $$ = _Q4MX9DECUIPB;
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
        auto _4QJN4WWHK2AL = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::represent);
        _4QJN4WWHK2AL->children.push_back($3);
        $$ = _4QJN4WWHK2AL;
    }
    ;
linear_equation:
    LINEAR_EQUATION L_BRACKET equality_expression R_BRACKET
    {
        auto _63B6XRLZM1XH = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::linear_equation);
        _63B6XRLZM1XH->children.push_back($3);
        $$ = _63B6XRLZM1XH;
    }
    ;
range_proof:
    RANGE_PROOF L_BRACKET range_expression R_BRACKET
    {
        auto _9I25ROIT89PO = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::range_proof);
        _9I25ROIT89PO->children.push_back($3);
        $$ = _9I25ROIT89PO;
    }
    ;
equality_expression:
    expression EQUAL expression
    {
        auto _KTSNLVGDTSW3 = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::equal);
        _KTSNLVGDTSW3->children.push_back($1);
        _KTSNLVGDTSW3->children.push_back($3);
        $$ = _KTSNLVGDTSW3;
    }
    ;
range_expression:
    expression LESS_EQ expression
    {
        auto _2V6WH561GNO4 = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::less_equal);
        _2V6WH561GNO4->children.push_back($1);
        _2V6WH561GNO4->children.push_back($3);
        $$ = _2V6WH561GNO4;
    }
    | expression GREATER_EQ expression
    {
        auto _JWTR1OLPPMZK = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::greater_equal);
        _JWTR1OLPPMZK->children.push_back($1);
        _JWTR1OLPPMZK->children.push_back($3);
        $$ = _JWTR1OLPPMZK;
    }
    | expression LESS expression
    {
        auto _JYLBBS4BPLDX = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::less);
        _JYLBBS4BPLDX->children.push_back($1);
        _JYLBBS4BPLDX->children.push_back($3);
        $$ = _JYLBBS4BPLDX;
    }
    | expression GREATER expression
    {
        auto _US263B6ACUIU = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::greater);
        _US263B6ACUIU->children.push_back($1);
        _US263B6ACUIU->children.push_back($3);
        $$ = _US263B6ACUIU;
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
        auto _7473GDJANIXU = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::negative);
        _7473GDJANIXU->children.push_back($3);
        auto negative = _7473GDJANIXU;
        $1->children.push_back(negative);
        $$ = $1;
    }
    | item
    {
        auto _ATX741015WN2 = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::sum);
        _ATX741015WN2->children.push_back($1);
        $$ = _ATX741015WN2;
    }
    ;
item:
    TOKEN TOKEN
    {
        auto _8B33N2ZNSKKA = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::variable, $1);
        auto _GAACY4FA82XT = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::variable, $2);
        auto _JXRR0URROCXV = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::multiply);
        _JXRR0URROCXV->children.push_back(_8B33N2ZNSKKA);
        _JXRR0URROCXV->children.push_back(_GAACY4FA82XT);
        $$ = _JXRR0URROCXV;
    }
    | TOKEN MULTIPLY TOKEN
    {
        auto _NWFAT8QDNOOM = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::variable, $1);
        auto _HPCFSLY8MH2J = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::variable, $2);
        auto _1WCB2Q1ADBZ0 = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::multiply);
        _1WCB2Q1ADBZ0->children.push_back(_NWFAT8QDNOOM);
        _1WCB2Q1ADBZ0->children.push_back(_HPCFSLY8MH2J);
        $$ = _1WCB2Q1ADBZ0;
    }
    | TOKEN
    {
        auto _CXV2S0CVVCH2 = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::variable, $1);
        $$ = _CXV2S0CVVCH2;
    }
    | NUMBER TOKEN
    {
        auto _QGX2Z0G8SH66 = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::number, $1);
        auto _JL47M0M6IPXK = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::variable, $2);
        auto _LW07IQ7LWIFU = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::multiply);
        _LW07IQ7LWIFU->children.push_back(_QGX2Z0G8SH66);
        _LW07IQ7LWIFU->children.push_back(_JL47M0M6IPXK);
        $$ = _LW07IQ7LWIFU;
    }
    | NUMBER
    {
        auto _M6U03SWNBOKF = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::number, $1);
        $$ = _M6U03SWNBOKF;
    }
    ;
any:
    ANY L_BRACKET statements R_BRACKET
    {
        auto _K02MIKSF3VME = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::any, $3->value);
        _K02MIKSF3VME->children = std::move($3->children);
        $$ = _K02MIKSF3VME;
    }
    ;
all:
    ALL L_BRACKET statements R_BRACKET
    {
        auto _JCQ0V106UIJZ = std::make_shared<libdark::sigma_ast_node>(
            libdark::sigma_ast_type::all, $3->value);
        _JCQ0V106UIJZ->children = std::move($3->children);
        $$ = _JCQ0V106UIJZ;
    }
    ;

%%

// Bison expects us to provide implementation - otherwise linker complains
void libdark::sigma_bison_parser::error(
    const location &loc , const std::string &message)
{
    driver.error_message = message;
}
 
