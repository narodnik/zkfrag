#ifndef LIBDARK_EXPRESSION_HPP
#define LIBDARK_EXPRESSION_HPP

#include <memory>

namespace libdark {

enum class operation_type
{
    value
};

class expression
{
public:
    expression(const std::string& value, const expression* parent);
    expression(operation_type type,
        expression* left, expression* right, const expression* parent);

    ~expression();

    const operation_type type() const;
    const std::string& value() const;

    const expression* left() const;
    const expression* right() const;
    const expression* parent() const;

private:
    const operation_type type_;
    const std::string value_;

    expression* left_, * right_;
    const expression* parent_;
};

} // namespace libdark

#endif

