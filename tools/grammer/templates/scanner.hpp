#ifndef ${HEADER_PREFIX}_${CLASS_PREFIX}_PARSER_SCANNER_HPP
#define ${HEADER_PREFIX}_${CLASS_PREFIX}_PARSER_SCANNER_HPP


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
    #define yyFlexLexer ${library_name}_${class_prefix}_FlexLexer
    #include <FlexLexer.h>
#endif

// Scanner method signature is defined by this macro.
// Original yylex() returns int.
// Since Bison 3 uses symbol_type, we must change returned type.
// We also rename it to something sane, since you cannot overload return type.
#undef YY_DECL
#define YY_DECL ${library_name}::${class_prefix}_bison_parser::symbol_type \
    ${library_name}::${class_prefix}_flex_scanner::get_next_token()

// this is needed for symbol_type
#include <${include_path}/${class_prefix}_ast_node.hpp>
#include "../${class_prefix}_ast_driver.hpp"
#include "generated/parser.hpp"

namespace ${library_name} {

// Forward declare interpreter to avoid include.
// Header is added in implementation file.
    
class ${class_prefix}_flex_scanner
 : public yyFlexLexer
{
public:
    ${class_prefix}_flex_scanner(${class_prefix}_ast_driver& driver)
      : driver_(driver) {}
    virtual ~${class_prefix}_flex_scanner() {}
    virtual ${class_prefix}_bison_parser::symbol_type get_next_token();
        
private:
    ${class_prefix}_ast_driver& driver_;
};

} // namespace ${library_name}

#endif

