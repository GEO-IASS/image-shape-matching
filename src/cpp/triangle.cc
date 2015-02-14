// Tao Du
// taodu@stanford.edu
// Feb 14, 2015

#include "cppheader.h"
#include "triangle.h"

Triangle::Triangle() {
  m_vertices[0] = m_vertices[1] = m_vertices[2] = Vector3();
  m_normal = Vector3();
  m_area = 0.0;
  m_bbox = BBox(Vector3(), Vector3());
}

Triangle::Triangle(const Vector3& v1, const Vector3& v2, const Vector3& v3) {
  m_vertices[0] = v1;
  m_vertices[1] = v2;
  m_vertices[2] = v3;
  m_normal = Vector3::Cross(v2 - v1, v3 - v2);

  // Compute the area of the triangle.
  m_area = 0.5 * m_normal.Length();
  // Normalize the normal!
  if (m_area < DBL_EPSILON)
    m_normal = Vector3(0.0, 0.0, 0.0);
  else
    m_normal = m_normal / (2 * m_area);

  // Compute the bounding box.
  Vector3 pMin = Vector3::Min(v1, Vector3::Min(v2, v3));
  Vector3 pMax = Vector3::Max(v1, Vector3::Max(v2, v3));
  m_bbox = BBox(pMin, pMax);
}

// Overload operator.
Vector3 Triangle::operator[](int i) const {
  // i can only be 0, 1 or 2.
  assert(i >= 0 && i < 3);
  return m_vertices[i];
}
 
// Compute the barycentric weight of a given p.
// if p is not in the plane, return DBL_MAX, DBL_MAX, DBL_MAX.
Vector3 Triangle::GetBarycentricWeight(const Vector3 &p) const {
  if (p.x == DBL_MAX ||
      p.y == DBL_MAX ||
      p.z == DBL_MAX) {
    return Vector3(DBL_MAX, DBL_MAX, DBL_MAX);
  }
  // Compute the area of the three triangles.
  Vector3 v[3];
  // v = triangle vertices - p.
  for (int i = 0; i < 3; i++) {
    v[i] = m_vertices[i] - p;
  }
  // Use cross product to compute the area of the triangles.
  Vector3 vArea[3];
  vArea[0] = Vector3::Cross(v[1], v[2]);
  vArea[1] = Vector3::Cross(v[2], v[0]);
  vArea[2] = Vector3::Cross(v[0], v[1]);
  // Compute the signed area of each of the three triangles.
  double area[3];
  // If the dot product between vArea and m_normal is positive then the
  // corresponding triangle is positive. Otherwise it is negative.
  double areaSum = 0.0;
  for (int i = 0; i < 3; i++) {
    area[i] = vArea[i].Length() * 0.5 *
              (Vector3::Dot(vArea[i], m_normal) > 0.0 ? 1.0 : -1.0);
    areaSum += area[i];
  }
  // If the sum of areas are not equal to m_area, then the point is not in
  // the triangle plane. Here we use a relaxed error bound.
  if (abs(areaSum - m_area) > FLT_EPSILON) {
    return Vector3(DBL_MAX, DBL_MAX, DBL_MAX);
  }
  // Return the barycentric weight.
  return Vector3(area[0], area[1], area[2]) / m_area;
}

// Get the intersection point.
Intersection Triangle::GetIntersection(const Line& l) const {
  Intersection inter;
  inter.point = Vector3(DBL_MAX, DBL_MAX, DBL_MAX);
  inter.t = DBL_MAX;
  double t = GetIntersectionT(l);
  if (t == DBL_MAX)
    return inter;
  inter.t = t;
  inter.point = l(t);
  return inter;
}

bool Triangle::DoesIntersect(const Line &l) const {
  return GetIntersectionT(l) != DBL_MAX;
}

// Get the parameter of the intersection point in line. For any cases where
// the line does not intersect with the triangle, we will return DBL_MAX.
double Triangle::GetIntersectionT(const Line &l) const {
  // Test whether the line and the plane are parallel.
  Vector3 o = l.GetOrigin();
  Vector3 d = l.GetDirection();
  // If they are parallel, return DBL_MAX.
  double c = Vector3::Dot(d, m_normal);
  if (abs(c) < FLT_EPSILON)
   return DBL_MAX;
 
  // Compute the solution.
  // Line equation: o + t*d = p
  // where p is the intersection point.
  // Triangle plane equation.
  // (p - v[0]) * m_normal = 0
  // Solve:
  // (o + t*d - v[0]) * normal = 0
  // t*(d * normal) + (o - v[0]) * normal = 0
  // t*c + (o - v[0]) * normal = 0
  double t = Vector3::Dot(o - m_vertices[0], m_normal) / -c;
  if (t <= 0.0)
    return DBL_MAX;
  Vector3 w = GetBarycentricWeight(l(t));
  if ((w.x == DBL_MAX && w.y == DBL_MAX && w.z == DBL_MAX) ||
      w.x < 0.0 || w.y < 0.0 || w.z < 0.0)
    return DBL_MAX;
  return t;
}
