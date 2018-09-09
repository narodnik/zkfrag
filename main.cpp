#include <fstream>
#include <iostream>
#include <iterator>
#include <string>
#include <libdark.hpp>

#include <libdark/pirromean/gate.hpp>
#include <libdark/pirromean/keypair.hpp>
#include <libdark/pirromean/model.hpp>
#include <libdark/pirromean/portal.hpp>
#include <libdark/pirromean/witness.hpp>

void print_ast(libdark::sigma_ast_node::ptr node, size_t indent=0)
{
    std::cout << std::string(indent, ' ')
        << libdark::ast_type_to_string(node->type);
    if (!node->value.empty())
        std::cout << ": " << node->value;
    std::cout << std::endl;
    for (auto child: node->children)
        print_ast(child, indent + 2);
}

void print_error(const libdark::ast_parser_error& error, std::ifstream& file)
{
    std::cerr << "Error parsing fragment: " << error.message << std::endl;
    file.clear();
    file.seekg(0, std::ios::beg);

    size_t current_location = 0;
    size_t current_line = 0;
    for (std::string line; std::getline(file, line); )
    {
        if (current_location + line.size() >= error.location)
        {
            std::cerr << "Line " << current_line << ":" << std::endl;
            std::cerr << line << std::endl;
            break;
        }
        current_location += line.size() + 1;
        ++current_line;
    }

    const auto offset = error.location - current_location - 1;
    std::cerr << std::string(offset, ' ') << "^" << std::endl;
}

int main(int argc, char** argv)
{
    std::string filename = "fragment.zkf";
    if (argc == 2)
        filename = argv[1];
    std::cout << "Opening: " << filename << std::endl;

    std::ifstream file(filename);
    if (!file.is_open())
    {
        std::cerr << "Error opening file." << std::endl;
        return -1;
    }

    libdark::sigma_ast_parser parser;
    auto root = parser.parse(file);

    if (!root)
    {
        std::cerr << "Parse failed." << std::endl;
        print_error(parser.error(), file);
        return -1;
    }

    std::cout << "Parse successful:" << std::endl << std::endl;

    print_ast(root);

    libdark::variables_map variables;
    variables["G"] = bc::ec_point::G;
    variables["H"] = bc::ec_point(bc::base16_literal(
        "02a5d7927f021e8561a33c28fb4cc537dfab678ef1709f04002338a5ab6d02316c"));
    variables["d"] = bc::ec_scalar(bc::base16_literal(
        "e3e796dcbd77e3565618d1feeb6ddc921f6531e417ed32182253ed564b764b3b"));
    variables["z"] = bc::ec_scalar(bc::base16_literal(
        "afc743a0af634724f4c2e9d3b78a4e2bc5602eb9e038ced88cbd5220d65f07e9"));
    variables["x"] = bc::ec_scalar(bc::base16_literal(
        "319e421f7040de652ebbc02782a4a07b0e8323ed95ef1a92c6704e0a6d6612ed"));
    const auto& G = *variables["G"].point();
    const auto& H = *variables["H"].point();
    const auto& d = *variables["d"].scalar();
    const auto& x = *variables["x"].scalar();
    variables["Q"] = d * G;
    variables["Y"] = x * H;

    DARK_ASSERT(variables["G"].point());
    DARK_ASSERT(variables["d"].scalar());
    DARK_ASSERT(variables["Q"].point());

    typedef libdark::pirr_keypair<libdark::curve_secp256k1> pirr_keypair;
    typedef libdark::pirr_witness<libdark::curve_secp256k1> pirr_witness;
    typedef libdark::pirr_portal<libdark::curve_secp256k1> pirr_portal;
    typedef libdark::pirr_gate<libdark::curve_secp256k1> pirr_gate;
    typedef libdark::pirr_model<libdark::curve_secp256k1> pirr_model;

    auto gate_0 = std::make_shared<pirr_gate>(0);
    auto gate_1 = std::make_shared<pirr_gate>(1);
    auto gate_2 = std::make_shared<pirr_gate>(2);
    auto gate_3 = std::make_shared<pirr_gate>(3);
    libdark::link(gate_0, gate_3);

    auto portal_a = std::make_shared<pirr_portal>(pirr_keypair::list{
        pirr_keypair::random(*variables["G"].point())
    });
    auto portal_b = std::make_shared<pirr_portal>(pirr_keypair::list{
        pirr_keypair::random(*variables["G"].point()).clone_public()
    });
    auto portal_c = std::make_shared<pirr_portal>(pirr_keypair::list{
        pirr_keypair::random(*variables["G"].point())
    });
    auto portal_d = std::make_shared<pirr_portal>(pirr_keypair::list{
        pirr_keypair::random(*variables["G"].point()).clone_public()
    });

    libdark::connect(gate_0, portal_a, gate_2);

    libdark::connect(gate_0, portal_b, gate_1);
    libdark::connect(gate_1, portal_c, gate_2);

    libdark::connect(gate_2, portal_d, gate_3);

    auto model = pirr_model(
        { gate_0, gate_1, gate_2, gate_3 },
        { portal_a, portal_b, portal_c, portal_d }
    );

    model.sign();

    const auto result = check_rules(root, variables);
    const auto ec = result.first;
    if (ec)
    {
        const auto node = result.second;
        std::cerr << "Error validating fragment: "
            << ec.message() << std::endl;
        print_ast(node);
        return -1;
    }

    return 0;
}

