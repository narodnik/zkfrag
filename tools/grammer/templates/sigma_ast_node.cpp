#include <${include_path}/${class_prefix}_ast_node.hpp>

#include <libdark/utility/assert.hpp>

namespace ${library_name} {

std::string ast_type_to_string(const ${class_prefix}_ast_type type)
{
    switch (type)
    {
        ${ast_type_to_string}
    }
    DARK_ASSERT(false);
    // Shouldn't ever reach here!
    return "ERROR";
}

} // namespace ${library_name}

