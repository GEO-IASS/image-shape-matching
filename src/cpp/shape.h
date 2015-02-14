// Tao Du
// taodu@stanford.edu
// Feb 14, 2015

#ifndef _SHAPE_H_
#define _SHAPE_H_

// The convention of the three virutal functions:
// GetIntersection: returns DBL_MAX point and DBL_MAX t if the shape and l do
// not intersect for any reason.
// DoesIntersect: returns false if l and the shape do not intersect for any
// reason.
// GetIntersectionT: returns DBL_MAX if l and the shape do not intersect for
// any reason.

#include "intersection.h"
#include "line.h"
#include "bbox.h"

class Shape {
 public:
  virtual Intersection GetIntersection(const Line &l) const = 0;
  virtual bool DoesIntersect(const Line &l) const = 0;
  virtual double GetIntersectionT(const Line &l) const = 0;
  virtual BBox GetBBox() const = 0;
};

#endif 
