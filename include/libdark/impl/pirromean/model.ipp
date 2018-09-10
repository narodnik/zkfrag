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

template <typename GatePtrType>
void perform_verify(GatePtrType gate);

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
    auto input_gate = portal->input().lock();
    DARK_ASSERT(input_gate);
    get_challenge(input_gate);

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
            DARK_ASSERT(next);
            make_join(next);
        }
    }
}

template <typename CurveType>
bool pirr_model<CurveType>::verify() const
{
    auto start = start_gate();
    perform_verify(start);
    auto end = end_gate();
    return start->challenge() == end->challenge();
}

template <typename GatePtrType>
void perform_verify(GatePtrType gate)
{
    if (!gate->has_challenge())
    {
        DARK_ASSERT(gate->is_start());
    }
    else
    {
        // Wait for other inputs to finish
        if (gate->has_empty_input_witnesses())
            return;
        gate->compute_challenge();
    }

    for (auto portal: gate->outputs())
    {
        portal->derive_witnesses();

        auto output = portal->output().lock();
        DARK_ASSERT(output);
        perform_verify(output);
    }
}

template <typename CurveType>
std::string pirr_model<CurveType>::pretty(size_t indent) const
{
    auto result = std::string(indent * 4, ' ') + "model: \n";
    for (auto gate: gates_)
        result += gate->pretty(indent + 1);
    for (auto portal: portals_)
        result += portal->pretty(indent + 1);
    return result;
}

} // namespace libdark

#endif

