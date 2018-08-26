#ifndef LIBDARK_ASSERT
#define LIBDARK_ASSERT

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

