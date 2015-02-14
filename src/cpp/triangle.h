// Tao Du
// taodu@stanford.edu
// Feb 14, 2015

#ifndef _TRIANGLE_H_
#define _TRIANGLE_H_

#include "bbox.h"
#include "shape.h"

class Triangle : public Shape {
 public:
  Triangle();
  Triangle(const Vector3& v1, const Vector3& v2, const Vector3& v3);
  ~Triangle() {}

  // Overload operator.
  // it is not allowed to modify the data so we return by value.
  Vector3 operator[](int i) const;
 
  // The normal is defined on right hand rule and the normal is guaranteed
  // to be normalized.
  Vector3 GetNormal() const { return m_normal; }

  Vector3 GetBarycentricWeight(const Vector3 &p) const;
 
  // Get the area of the triangle
  double getArea() const { return m_area; }

  // Virtual functions.
  Intersection GetIntersection(const Line &l) const;
  bool DoesIntersect(const Line &l) const;
  double GetIntersectionT(const Line &l) const;

  // Get the bounding box.
  BBox GetBBox() const { return m_bbox; }

 private:
  // Data member.
  Vector3 m_vertices[3];
  // m_normal stores the normal of the triangle.
  Vector3 m_normal;
  // Bounding box.
  BBox m_bbox;

  double m_area;
};

#endif
