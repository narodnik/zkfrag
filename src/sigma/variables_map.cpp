#include <libdark/sigma/variables_map.hpp>

namespace libdark {

sigma_variant::sigma_variant()
{
}
sigma_variant::sigma_variant(const bc::ec_point& point)
  : type_(type::point), point_(point)
{
}
sigma_variant::sigma_variant(const bc::ec_scalar& scalar)
  : type_(type::scalar), scalar_(scalar)
{
}

bc::ec_point* sigma_variant::point()
{
    if (type_ != type::point)
        return nullptr;
    return &point_;
}
bc::ec_scalar* sigma_variant::scalar()
{
    if (type_ != type::scalar)
        return nullptr;
    return &scalar_;
}

const bc::ec_point* sigma_variant::point() const
{
    if (type_ != type::point)
        return nullptr;
    return &point_;
}
const bc::ec_scalar* sigma_variant::scalar() const
{
    if (type_ != type::scalar)
        return nullptr;
    return &scalar_;
}

} // namespace libdark

