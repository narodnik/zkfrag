# Automake settings.
#==============================================================================
# Look for macros in the m4 subdirectory.
#------------------------------------------------------------------------------
ACLOCAL_AMFLAGS = -I m4


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

#TESTS = libdark-test_runner.sh
#
#check_PROGRAMS = test/libdark-test
#test_libdark_test_CPPFLAGS = -I${srcdir}/include ${bitcoin_BUILD_CPPFLAGS}
#test_libdark_test_LDADD = src/libdark.la ${boost_unit_test_framework_LIBS} ${bitcoin_LIBS}
#test_libdark_test_SOURCES = \
#    test/block_state.cpp \
#    test/data_base.cpp \
#    test/main.cpp \
#    test/settings.cpp \
#    test/store.cpp \
#    test/unspent_outputs.cpp \
#    test/unspent_transaction.cpp \
#    test/databases/address_database.cpp \
#    test/databases/block_database.cpp \
#    test/databases/transaction_database.cpp \
#    test/memory/accessor.cpp \
#    test/memory/file_storage.cpp \
#    test/primitives/hash_table.cpp \
#    test/primitives/hash_table_header.cpp \
#    test/primitives/hash_table_multimap.cpp \
#    test/primitives/list.cpp \
#    test/primitives/list_element.cpp \
#    test/primitives/list_iterator.cpp \
#    test/primitives/record_manager.cpp \
#    test/primitives/slab_manager.cpp \
#    test/result/address_iterator.cpp \
#    test/result/address_result.cpp \
#    test/result/block_result.cpp \
#    test/result/transaction_iterator.cpp \
#    test/result/transaction_result.cpp \
#    test/utility/storage.cpp \
#    test/utility/storage.hpp \
#    test/utility/utility.cpp \
#    test/utility/utility.hpp

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
include_libdarkdir = ${includedir}/libdark
include_libdark_HEADERS = \
    include/libdark/error.hpp

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

