#include "expression.hpp"

namespace libdark {

expression::expression(const std::string& value, const expression* parent)
  : type_(operation_type::value), value_(value),
    left_(nullptr), right_(nullptr)
{
}

expression::expression(operation_type type,
    expression* left, expression* right, const expression* parent
)
  : type_(type), left_(left), right_(right)
{
}

expression::~expression()
{
    delete left_;
    delete right_;
}

const operation_type expression::type() const
{
    return type_;
}
const std::string& expression::value() const
{
    return value_;
}

const expression* expression::left() const
{
    return left_;
}
const expression* expression::right() const
{
    return right_;
}
const expression* expression::parent() const
{
    return parent_;
}

} // namespace libdark

