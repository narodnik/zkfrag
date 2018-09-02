#ifndef SIGMA_PARSER_SCANNER_HPP
#define SIGMA_PARSER_SCANNER_HPP


/**
 * Generated Flex class name is yyFlexLexer by default.
 * If we want to use more flex-generated classes we should name
 * them differently. See scanner.l prefix option.
 * 
 * Unfortunately the implementation relies on this trick with
 * redefining class name with a preprocessor macro. See GNU Flex manual,
 * "Generating C++ Scanners" section
 */
#if !defined(yyFlexLexerOnce)
    #undef yyFlexLexer
    // the trick with prefix; no namespace here :(
    #define yyFlexLexer libdark_FlexLexer
    #include <FlexLexer.h>
#endif

// Scanner method signature is defined by this macro.
// Original yylex() returns int.
// Since Bison 3 uses symbol_type, we must change returned type.
// We also rename it to something sane, since you cannot overload return type.
#undef YY_DECL
#define YY_DECL libdark::bison_parser::symbol_type \
    libdark::flex_scanner::get_next_token()

// this is needed for symbol_type
#include "generated/parser.hpp"

namespace libdark {

// Forward declare interpreter to avoid include.
// Header is added in implementation file.
class ast_parser_driver;
    
class flex_scanner
 : public yyFlexLexer
{
public:
    flex_scanner(ast_parser_driver &driver) : driver_(driver) {}
    virtual ~flex_scanner() {}
    virtual bison_parser::symbol_type get_next_token();
        
private:
    ast_parser_driver &driver_;
};

}

#endif

