#include <libdark/sigma/sigma_ast_parser.hpp>

#include "sigma_ast_driver.hpp"
#include "parser/generated/parser.hpp"
#include "parser/scanner.hpp"

namespace libdark {

sigma_ast_node::ptr sigma_ast_parser::parse(std::istream& stream)
{
    return ast_parser_base::parse<
        sigma_ast_driver, sigma_flex_scanner,
        sigma_bison_parser, sigma_ast_node::ptr>(stream);
}

} // namespace libdark

