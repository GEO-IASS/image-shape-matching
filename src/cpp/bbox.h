// Tao Du
// taodu@stanford.edu
// Feb 14, 2015

// the axis aligned bounding box class used in BVH acceleration structure.

#ifndef _BBOX_H_
#define _BBOX_H_

#include "intersection.h"
#include "line.h"
#include "vector3.h"

class BBox {
 public:
  // Default constructor.
  // Will init pMin = +Infty and init pMax = -Infty.
  BBox();
  // Use pMin and pMax to init the box.
  BBox(Vector3 pMin, Vector3 pMax);
  // Use 6 double numbers to init the box.
  BBox(double xmin, double xmax, double ymin, double ymax,
       double zmin, double zmax);

  bool DoesIntersect(const Line &l) const;
  Intersection GetIntersection(const Line &l) const;
  double GetIntersectionT(const Line &l) const;

  // Get pMin.
  Vector3 GetMin() const { return m_pMin; }
  // Get pMax.
  Vector3 GetMax() const { return m_pMax; }
  // Get the center of the box.
  Vector3 GetCenter() const { return m_center; }
 
  // Find the longest edge in the box and return its id.
  // 0 -> x, 1 -> y, 2 -> z.
  int GetMaxExtentId() const;
  // Find the shortest edge in the box and return its id.
  // 0 -> x, 1 -> y, 2 -> z.
  int GetMinExtentId() const;
 
  // Decide whether a point is inside.
  bool IsInside(const Vector3 &p) const;

  // Static functions.
  // Combine two bounding box together.
  static BBox Combine(const BBox &b1, const BBox &b2);
  // Combine a bounding box and a point together.
  static BBox Combine(const BBox &b, const Vector3 &p);
  // combine two bounding box together by their pointers.
  static BBox* Combine(const BBox *b1, const BBox *b2);

 private:
  // Data member.
  Vector3 m_center; // The center of the bounding box.
  Vector3 m_pMin, m_pMax; // The min and max vertex of the bounding box.
};

#endif
