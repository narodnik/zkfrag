#include <boost/test/unit_test.hpp>
#include <libdark.hpp>

BOOST_AUTO_TEST_SUITE(sha256_combine_tests)

// constructors
//-----------------------------------------------------------------------------

BOOST_AUTO_TEST_CASE(sha256_combine__default_test)
{
    libdark::sha256_combine hasher;

    hasher.update(bc::base16_literal(
        "0aafde3f"));
    hasher.update(bc::base16_literal(
        "566bc08e941f37dcd286cbd7ea254f"));
    hasher.update(bc::base16_literal(
        "db7c6df5f5fd451d54fac8d2bcd1041239ed5fef401329e9"));

    auto result = hasher.result();

    BOOST_REQUIRE_EQUAL(bc::encode_base16(result),
        "f94fa374ae5fcd4b9320dfd86f601d909780b7d2c363f434da82834ecce2caf4");
}

BOOST_AUTO_TEST_SUITE_END()

