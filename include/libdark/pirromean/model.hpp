#ifndef LIBDARK_PIRROMEAN_MODEL_HPP
#define LIBDARK_PIRROMEAN_MODEL_HPP

#include <libdark/pirromean/gate.hpp>
#include <libdark/pirromean/portal.hpp>

namespace libdark {

template <typename CurveType>
class pirr_model
{
public:
    typedef typename pirr_gate<CurveType>::ptr gate_ptr;
    typedef typename pirr_gate<CurveType>::ptrlist gate_ptrlist;
    typedef typename pirr_portal<CurveType>::ptrlist portal_ptrlist;

    pirr_model(gate_ptrlist gates, portal_ptrlist portals);

    void sign();
    bool verify() const;

    pirr_model clone_public() const;

    std::string pretty(size_t indent=0) const;

private:
    gate_ptr start_gate() const;
    gate_ptr end_gate() const;

    gate_ptrlist gates_;
    portal_ptrlist portals_;
};

} // namespace libdark

#include <libdark/impl/pirromean/model.ipp>

#endif

