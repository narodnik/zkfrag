#ifndef LIBDARK_PIRROMEAN_KEYPAIR_HPP
#define LIBDARK_PIRROMEAN_KEYPAIR_HPP

#include <vector>
#include <boost/optional.hpp>
#include <bitcoin/bitcoin.hpp>

namespace libdark {

struct curve_secp256k1
{
    typedef bc::ec_secret ec_secret;
    typedef bc::ec_scalar ec_scalar;
    typedef bc::ec_point ec_point;
};

template <typename CurveType>
class pirr_keypair
{
public:
    typedef typename CurveType::ec_point ec_point;
    typedef typename CurveType::ec_scalar ec_scalar;

    typedef std::vector<pirr_keypair<CurveType>> list;

    pirr_keypair(const ec_point& publik, const ec_point& generator);
    pirr_keypair(const ec_scalar& secret, const ec_point& generator);

    static pirr_keypair random(const ec_point& generator);

    pirr_keypair clone_public() const;

    bool has_secret() const;
    const ec_scalar& secret() const;
    const ec_point& public_() const;
    const ec_point& generator() const;

    std::string pretty(size_t indent=0) const;

private:
    typedef boost::optional<ec_scalar> optional_scalar;

    optional_scalar secret_;
    ec_point publik_;
    const ec_point generator_;
};

} // namespace libdark

#include <libdark/impl/pirromean/keypair.ipp>

#endif

