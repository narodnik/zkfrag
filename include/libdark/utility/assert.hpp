#ifndef LIBDARK_UTILITY_ASSERT_HPP
#define LIBDARK_UTILITY_ASSERT_HPP

#ifdef NDEBUG
    #define DARK_ASSERT(expression)
    #define DARK_ASSERT_MSG(expression, text)
    #define DARK_DEBUG_ONLY(expression)
#else
    #include <cassert>
    #define DARK_ASSERT(expression) assert(expression)
    #define DARK_ASSERT_MSG(expression, text) assert((expression)&&(text))
    #define DARK_DEBUG_ONLY(expression) expression
#endif

#endif

