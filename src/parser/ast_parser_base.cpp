#include <libdark/parser/ast_parser_base.hpp>

namespace libdark {

const ast_parser_error ast_parser_base::error() const
{
    return error_;
}

} // namespace libdark

