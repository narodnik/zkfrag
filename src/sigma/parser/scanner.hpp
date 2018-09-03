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
#include <libdark/sigma/sigma_ast_node.hpp>
#include "../sigma_ast_driver.hpp"
#include "generated/parser.hpp"

namespace libdark {

// Forward declare interpreter to avoid include.
// Header is added in implementation file.
    
class flex_scanner
 : public yyFlexLexer
{
public:
    flex_scanner(sigma_ast_driver& driver) : driver_(driver) {}
    virtual ~flex_scanner() {}
    virtual libdark::bison_parser::symbol_type get_next_token();
        
private:
    sigma_ast_driver& driver_;
};

}

#endif

