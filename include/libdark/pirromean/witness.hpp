#ifndef LIBDARK_PIRROMEAN_WITNESS_HPP
#define LIBDARK_PIRROMEAN_WITNESS_HPP

#include <vector>
#include <boost/optional.hpp>

namespace libdark {

template <typename CurveType>
class pirr_witness
{
public:
    typedef typename CurveType::ec_point ec_point;
    typedef typename CurveType::ec_scalar ec_scalar;

    typedef std::vector<pirr_witness<CurveType>> list;

    pirr_witness(const ec_point& commit);
    pirr_witness(const ec_scalar& secret, const ec_point& generator);

    static pirr_witness random(const ec_point& generator);

    pirr_witness clone_public() const;

    bool has_secret() const;
    const ec_scalar secret() const;
    const ec_point& commit() const;

    std::string pretty(size_t indent=0) const;

private:
    typedef boost::optional<ec_scalar> optional_scalar;

    optional_scalar secret_;
    ec_point commit_;
};

} // namespace libdark

#include <libdark/impl/pirromean/witness.ipp>

#endif

