#ifndef LIBDARK_SIGMA_VARIABLES_MAP_HPP
#define LIBDARK_SIGMA_VARIABLES_MAP_HPP

#include <unordered_map>
#include <bitcoin/bitcoin.hpp>

namespace libdark {

// variant that can hold either point or scalar values for proofs
class sigma_variant
{
public:
    // Default constructor needed for unordered_map to work.
    sigma_variant();
    // We should add move constructors
    sigma_variant(const bc::ec_point& point);
    sigma_variant(const bc::ec_scalar& scalar);

    bc::ec_point* point();
    bc::ec_scalar* scalar();

    const bc::ec_point* point() const;
    const bc::ec_scalar* scalar() const;

private:
    union
    {
        bc::ec_point point_;
        bc::ec_scalar scalar_;
    };

    enum class type
    {
        point,
        scalar
    } type_;
};

typedef std::unordered_map<std::string, sigma_variant> variables_map;

} // namespace libdark

#endif

