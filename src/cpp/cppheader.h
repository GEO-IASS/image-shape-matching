// Tao Du
// taodu@stanford.edu
// Feb 14, 2015

#ifndef _CPPHEADER_H_
#define _CPPHEADER_H_
// This header file includes all the .h file from C++.

// Assertion.
#include <assert.h>

// Math.
#define _USE_MATH_DEFINES
#include <math.h>
// Usage from math.h:
// M_PI pi
// M_PI_2 pi/2
// M_PI_4 pi/4
// M_1_PI 1/pi
// M_2_PI 2/pi

// Epsilon.
#include <float.h>
// Usage from float.h:
// DBL_EPSILON  epsilon between 1 and 1+\varepsilon that is representable. Used
// to decide whether a small number is zero.

// String.
#include <string.h>

// Vector.
#include <vector>

// Sorting.
// Used in building BVHTree.
#include <algorithm>

#endif
