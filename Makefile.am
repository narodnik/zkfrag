# Automake settings.
#==============================================================================
# Look for macros in the m4 subdirectory.
#------------------------------------------------------------------------------
ACLOCAL_AMFLAGS = -I m4

# Haven't managed to get Bison working with autotools
#AM_YFLAGS = \
#    --defines=src/sigma/parser/generated/parser.hpp \
#    --output=src/sigma/parser/generated/parser.cpp


# Distribute, make and install products.
#==============================================================================
# files => ${pkgconfigdir}
#------------------------------------------------------------------------------
pkgconfig_DATA = \
    libdark.pc

# files => ${docdir}
#------------------------------------------------------------------------------
doc_DATA = \
    AUTHORS \
    COPYING \
    ChangeLog \
    INSTALL \
    NEWS \
    README

# src/libdark.la => ${libdir}
#------------------------------------------------------------------------------
lib_LTLIBRARIES = src/libdark.la
src_libdark_la_CPPFLAGS = -I${srcdir}/include ${bitcoin_BUILD_CPPFLAGS}
src_libdark_la_LIBADD = ${bitcoin_LIBS}
src_libdark_la_SOURCES = \
    src/sigma/sigma_ast_parser.cpp \
    src/sigma/sigma_ast_node.cpp \
    src/sigma/variables_map.cpp \
    src/sigma/check_rules.cpp \
    src/sigma/parser/generated/parser.cpp \
    src/sigma/parser/generated/scanner.cpp \
    src/error.cpp \
    src/math/sha256_combine.cpp \
    src/parser/ast_parser_base.cpp

# local: test/libdark-test
#------------------------------------------------------------------------------
if WITH_TESTS

TESTS = libdark-test_runner.sh

check_PROGRAMS = test/libdark-test
test_libdark_test_CPPFLAGS = -I${srcdir}/include ${bitcoin_BUILD_CPPFLAGS}
test_libdark_test_LDADD = src/libdark.la ${boost_unit_test_framework_LIBS} ${bitcoin_LIBS}
test_libdark_test_SOURCES = \
    test/main.cpp \
    test/math/sha256_combine.cpp

endif WITH_TESTS

# local: tools/initchain/initchain
#------------------------------------------------------------------------------
if WITH_TOOLS

noinst_PROGRAMS = tools/zkfrag/zkfrag
tools_zkfrag_zkfrag_CPPFLAGS = -I${srcdir}/include ${bitcoin_BUILD_CPPFLAGS}
tools_zkfrag_zkfrag_LDADD = src/libdark.la ${bitcoin_LIBS}
tools_zkfrag_zkfrag_SOURCES = \
    tools/zkfrag/main.cpp

endif WITH_TOOLS

# files => ${includedir}/dark
#------------------------------------------------------------------------------
include_HEADERS = \
    include/libdark.hpp

include_libdarkdir = ${includedir}/libdark
include_libdark_HEADERS = \
    include/libdark/error.hpp

include_libdark_mathdir = ${includedir}/libdark/math
include_libdark_math_HEADERS = \
    include/libdark/math/sha256_combine.hpp

include_libdark_sigmadir = ${includedir}/libdark/sigma
include_libdark_sigma_HEADERS = \
    include/libdark/sigma/check_rules.hpp \
    include/libdark/sigma/sigma_ast_node.hpp \
    include/libdark/sigma/sigma_ast_parser.hpp \
    include/libdark/sigma/variables_map.hpp \
    include/libdark/sigma/variables_parser.hpp

include_libdark_parserdir = ${includedir}/libdark/parser
include_libdark_parser_HEADERS = \
    include/libdark/parser/ast_driver.hpp \
    include/libdark/parser/ast_node.hpp \
    include/libdark/parser/ast_parser_base.hpp

include_libdark_impl_parserdir = ${includedir}/libdark/impl/parser
include_libdark_impl_parser_HEADERS = \
    include/libdark/impl/parser/ast_driver.ipp \
    include/libdark/impl/parser/ast_node.ipp \
    include/libdark/impl/parser/ast_parser_base.ipp

include_libdark_utilitydir = ${includedir}/libdark/utility
include_libdark_utility_HEADERS = \
    include/libdark/utility/assert.hpp

#include_dark_databasedir = ${includedir}/dark/database
#include_dark_database_HEADERS = \
#    include/bitcoin/database/block_state.hpp \
#    include/bitcoin/database/data_base.hpp \
#    include/bitcoin/database/define.hpp \
#    include/bitcoin/database/settings.hpp \
#    include/bitcoin/database/store.hpp \
#    include/bitcoin/database/unspent_outputs.hpp \
#    include/bitcoin/database/unspent_transaction.hpp \
#    include/bitcoin/database/verify.hpp \
#    include/bitcoin/database/version.hpp

# Custom make targets.
#==============================================================================
# make target: tools
#------------------------------------------------------------------------------
target_tools = \
    tools/zkfrag/zkfrag

tools: ${target_tools}

