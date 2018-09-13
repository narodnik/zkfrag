#ifndef LIBDARK_PIRROMEAN_GATE_HPP
#define LIBDARK_PIRROMEAN_GATE_HPP

#include <memory>
#include <vector>
#include <libdark/pirromean/portal.hpp>

namespace libdark {

template <typename CurveType>
class pirr_gate
{
public:
    typedef typename CurveType::ec_scalar ec_scalar;
    typedef typename pirr_portal<CurveType>::ptrlist portal_ptrlist;

    typedef std::shared_ptr<pirr_gate> ptr;
    typedef std::vector<ptr> ptrlist;

    pirr_gate(size_t index);

    ptr clone_public() const;

    size_t index() const;

    bool is_start() const;
    bool is_end() const;

    bool has_challenge() const;
    const ec_scalar& challenge() const;
    void set_challenge(const ec_scalar& challenge);

    void compute_challenge();

    bool has_empty_input_witnesses() const;

    portal_ptrlist inputs() const;
    portal_ptrlist outputs() const;

    std::string pretty(size_t indent=0) const;

private:
    enum class position_type
    {
        start,
        default_,
        end
    };

    template <typename GatePtrType>
    friend void link(GatePtrType start, GatePtrType end);

    template <typename GatePtrType, typename PortalPtrType>
    friend void connect(
        GatePtrType start, PortalPtrType portal, GatePtrType end);

    const size_t index_;
    position_type position_ = position_type::default_;
    // Gates collectively own the portals
    portal_ptrlist inputs_, outputs_;

    ec_scalar challenge_;
};

template <typename GatePtrType>
void link(GatePtrType start, GatePtrType end);

template <typename GatePtrType, typename PortalPtrType>
void connect(GatePtrType start, PortalPtrType portal, GatePtrType end);

} // namespace libdark

#include <libdark/impl/pirromean/gate.ipp>

#endif

