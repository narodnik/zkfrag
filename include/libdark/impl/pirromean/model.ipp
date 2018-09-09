#ifndef LIBDARK_PIRROMEAN_MODEL_IPP
#define LIBDARK_PIRROMEAN_MODEL_IPP

namespace libdark {

template <typename GatePtrType>
void get_challenge(GatePtrType gate);

template <typename PortalPtrType>
void compute_witness(PortalPtrType portal);

template <typename PortalPtrType>
void simulate_witness(PortalPtrType portal);

template <typename PortalPtrType>
void perform_protocol(PortalPtrType portal);

template <typename GatePtrType>
void make_join(GatePtrType gate);

template <typename CurveType>
pirr_model<CurveType>::pirr_model(gate_ptrlist gates, portal_ptrlist portals)
  : gates_(gates), portals_(portals)
{
}

template <typename CurveType>
typename pirr_model<CurveType>::gate_ptr
pirr_model<CurveType>::start_gate() const
{
    for (auto gate: gates_)
        if (gate->is_start())
            return gate;
    return nullptr;
}
template <typename CurveType>
typename pirr_model<CurveType>::gate_ptr
pirr_model<CurveType>::end_gate() const
{
    for (auto gate: gates_)
        if (gate->is_end())
            return gate;
    return nullptr;
}

template <typename CurveType>
void pirr_model<CurveType>::sign()
{
    auto end = end_gate();
    get_challenge(end);

    auto start = start_gate();
    start->set_challenge(end->challenge());

    make_join(start);
}

template <typename GatePtrType>
void get_challenge(GatePtrType gate)
{
    if (gate->has_challenge())
        return;
    // TODO: sort this out, "invalid graph"
    if (gate->is_start())
        throw;
    for (auto portal: gate->inputs())
        compute_witness(portal);
    gate->compute_challenge();
}

template <typename PortalPtrType>
void compute_witness(PortalPtrType portal)
{
    if (portal->is_signing_portal())
        perform_protocol(portal);
    else
        simulate_witness(portal);
}

template <typename PortalPtrType>
void simulate_witness(PortalPtrType portal)
{
    auto gate = portal->input().lock();
    if (!gate)
        // TODO: return error
        throw;
    portal->create_random_responses();
    portal->derive_witnesses();
}
template <typename PortalPtrType>
void perform_protocol(PortalPtrType portal)
{
    portal->create_random_witnesses();
}

template <typename GatePtrType>
void make_join(GatePtrType gate)
{
    if (!gate->has_challenge())
        gate->compute_challenge();
    for (auto portal: gate->outputs())
    {
        if (portal->is_signing_portal())
            portal->compute_valid_responses();
        else
        {
            portal->create_random_responses();
            portal->derive_witnesses();

            auto next = portal->output().lock();
            if (!next)
                throw;
            make_join(next);
        }
    }
}

template <typename CurveType>
bool pirr_model<CurveType>::verify() const
{
    return true;
}

} // namespace libdark

#endif

