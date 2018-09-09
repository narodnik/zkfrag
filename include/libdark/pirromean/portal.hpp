#ifndef LIBDARK_PIRROMEAN_PORTAL_HPP
#define LIBDARK_PIRROMEAN_PORTAL_HPP

#include <list>
#include <vector>
#include <libdark/pirromean/keypair.hpp>
#include <libdark/pirromean/witness.hpp>

namespace libdark {

template <typename CurveType>
class pirr_gate;

template <typename CurveType>
class pirr_portal
{
public:
    typedef pirr_keypair<CurveType> keypair_type;
    typedef pirr_witness<CurveType> witness_type;
    typedef typename CurveType::ec_scalar response_type;

    typedef typename keypair_type::list keypair_list;
    typedef typename witness_type::list witness_list;
    typedef std::vector<response_type> response_list;

    typedef std::shared_ptr<pirr_portal> ptr;
    typedef std::list<ptr> ptrlist;

    pirr_portal(const keypair_list& keys);

    std::string pretty(size_t indent=0) const;

private:
    template <typename GatePtrType, typename PortalPtrType>
    friend void connect(
        GatePtrType start, PortalPtrType portal, GatePtrType end);

    typedef pirr_gate<CurveType> gate_type;
    typedef std::weak_ptr<gate_type> gate_wptr;

    const keypair_list keys_;
    witness_list witnesses_;
    response_list responses_;

    gate_wptr input_, output_;
};

} // namespace libdark

#include <libdark/impl/pirromean/portal.ipp>

#endif

