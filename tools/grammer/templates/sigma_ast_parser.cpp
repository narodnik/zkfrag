#include <${include_path}/${class_prefix}_ast_parser.hpp>

#include "${class_prefix}_ast_driver.hpp"
#include "parser/generated/parser.hpp"
#include "parser/scanner.hpp"

namespace ${library_name} {

${class_prefix}_ast_node::ptr ${class_prefix}_ast_parser::parse(
    std::istream& stream)
{
    return ast_parser_base::parse<
        ${class_prefix}_ast_driver, ${class_prefix}_flex_scanner,
        ${class_prefix}_bison_parser, ${class_prefix}_ast_node::ptr>(stream);
}

} // namespace ${library_name}

