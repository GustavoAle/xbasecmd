#include "math.ch"
#include <hbclass.ch>

METHOD New() CLASS MATH
    set(3,15)
RETURN Self

METHOD SQRT(value) CLASS MATH
RETURN value ** (1/2)


