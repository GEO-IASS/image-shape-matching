// Tao Du
// taodu@stanford.edu
// Feb 14, 2015

// An intersection contains a point and a parameter.

#ifndef _INTERSECTION_H_
#define _INTERSECTION_H_

#include "vector3.h"

struct Intersection {
 public:
  // An empty constructor.
  Intersection(){}
  Intersection(const Vector3 &p, double d)
    : point(p), t(d) {}

  Vector3 point;
  double t;
};

#endif
