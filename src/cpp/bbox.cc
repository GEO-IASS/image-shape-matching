// Tao Du
// taodu@stanford.edu
// Feb 14, 2015

#include "common.h"

// Default constructor.
// Will init pMin = +Infty and init pMax = -Infty.
BBox::BBox() {
  m_pMin.x = m_pMin.y = m_pMin.z = DBL_MAX;
  m_pMax.x = m_pMax.y = m_pMax.z = -DBL_MAX;
  m_center.x = m_center.y = m_center.z = 0.0;
}

// Use pMin and pMax to init the box.
BBox::BBox(Vector3 pMin, Vector3 pMax) {
  m_pMin = pMin;
  m_pMax = pMax;
  m_center = (m_pMin + m_pMax) / 2;
}

// Use 6 double numbers to init the box.
BBox::BBox(double xmin, double xmax, double ymin, double ymax,
           double zmin, double zmax) {
  assert(xmax >= xmin);
  assert(ymax >= ymin);
  assert(zmax >= zmin);
  m_pMin.x = xmin;
  m_pMax.x = xmax;
  m_pMin.y = ymin;
  m_pMax.y = ymax;
  m_pMin.z = zmin;
  m_pMax.z = zmax;
  m_center = (m_pMax + m_pMin) / 2.0;
}

bool BBox::DoesIntersect(const Line &l) const {
  return GetIntersectionT(l) != DBL_MAX;
}

Intersection BBox::GetIntersection(const Line &l) const {
  Intersection inter;
  inter.point = Vector3(DBL_MAX, DBL_MAX, DBL_MAX);
  inter.t = DBL_MAX;

  Vector3 d = l.GetDirection();
  Vector3 o = l.GetOrigin();
  // If o is inside the bbox return DBL_MAX.
  if (IsInside(o) || (d.x == 0.0 && d.y == 0.0 && d.z == 0.0))
    return inter;

  // Find the t parameter of three pairs of slabs.
  Vector3 tnear, tfar;
  for (int i = 0; i < 3; i++) {
    if (d[i] == 0.0) {
      if (o[i] > m_pMin[i] && o[i] < m_pMax[i]) {
        tnear[i] = -DBL_MAX;
        tfar[i] = DBL_MAX;
      } else {
        return inter;
      }
    } else {
      double a = 1.0 / d[i];
      if (a >= 0.0) {
        tnear[i] = a * (m_pMin[i] - o[i]);
        tfar[i] = a * (m_pMax[i] - o[i]);
      } else {
        tnear[i] = a * (m_pMax[i] - o[i]);
        tfar[i] = a * (m_pMin[i] - o[i]);
      }
    }
  }
  double tmin = -DBL_MAX;
  double tmax = DBL_MAX;
  for (int i = 0; i < 3; i++) {
    if (tnear[i] > tmin) {
      tmin = tnear[i];
    }
    if (tfar[i] < tmax) {
      tmax = tfar[i];
    }
  }
  if (tmin <= tmax && tmin > DBL_EPSILON) {
    // fill the data in inter
    inter.point = l(tmin);
    inter.t = tmin;
  }
  return inter;
}

// If we can find an intersection t\in[0, +infty), return it.
// In all the other cases return DBL_MAX.
double BBox::GetIntersectionT(const Line &l) const {
  Vector3 d = l.GetDirection();
  Vector3 o = l.GetOrigin();
  // If o is inside the bbox return DBL_MAX.
 if (IsInside(o) || (d.x == 0.0 && d.y == 0.0 && d.z == 0.0))
   return DBL_MAX;

  // Find the t parameter of three pairs of slabs.
  Vector3 tnear, tfar;
  for (int i = 0; i < 3; i++) {
    if (d[i] == 0.0) {
      if (o[i] > m_pMin[i] && o[i] < m_pMax[i]) {
        tnear[i] = -DBL_MAX;
        tfar[i] = DBL_MAX;
      } else {
        return DBL_MAX;
      }
    } else {
      double a = 1.0 / d[i];
      if (a >= 0.0) {
        tnear[i] = a * (m_pMin[i] - o[i]);
        tfar[i] = a * (m_pMax[i] - o[i]);
      } else {
        tnear[i] = a * (m_pMax[i] - o[i]);
        tfar[i] = a * (m_pMin[i] - o[i]);
      }
    }
  }
  double tmin = -DBL_MAX;
  double tmax = DBL_MAX;
  for (int i = 0; i < 3; i++) {
    if (tnear[i] > tmin)
      tmin = tnear[i];
    if (tfar[i] < tmax)
      tmax = tfar[i];
  }
  double inter = DBL_MAX;
  if (tmin <= tmax && tmin > DBL_EPSILON) {
    inter = tmin;
  }
  return inter;
}

// Find the longest edge in the box and return its id.
// 0 -> x, 1 -> y, 2 -> z.
int BBox::GetMaxExtentId() const {
  int maxId = 0;
  Vector3 edgeLength = m_pMax - m_pMin;
  double maxValue = edgeLength.x;
  if (edgeLength.y > maxValue) {
    maxId = 1;
    maxValue = edgeLength.y;
  }
  if (edgeLength.z > maxValue) {
    maxId = 2;
    maxValue = edgeLength.z;
  }
  return maxId;
}

// Find the shortest edge in the box and return its id.
int BBox::GetMinExtentId() const {
  int minId = 0;
  Vector3 edgeLength = m_pMax - m_pMin;
  double minValue = edgeLength.x;
  if (edgeLength.y < minValue) {
    minId = 1;
    minValue = edgeLength.y;
  }
  if (edgeLength.z < minValue) {
    minId = 2;
    minValue = edgeLength.z;
  }
  return minId;
}

// Decide whether a point is inside the bounding box.
bool BBox::IsInside(const Vector3 &p) const {
  return p.x >= m_pMin.x && p.x <= m_pMax.x &&
         p.y >= m_pMin.y && p.y <= m_pMax.y &&
         p.z >= m_pMin.z && p.z <= m_pMax.z;
}

// Combine two bounding box together.
BBox BBox::Combine(const BBox &b1, const BBox &b2) {
  BBox b;
  b.m_pMin = Vector3::Min(b1.m_pMin, b2.m_pMin);
  b.m_pMax = Vector3::Max(b1.m_pMax, b2.m_pMax);
  // Update the center.
  b.m_center = (b.m_pMax + b.m_pMin) / 2;
  return b;
}

// Combine a bounding box and a point together.
BBox BBox::Combine(const BBox &b, const Vector3 &p) {
  BBox b2 = b;
  b2.m_pMin = Vector3::Min(p, b.m_pMin);
  b2.m_pMax = Vector3::Max(p, b.m_pMax);
  // Update the center.
  b2.m_center = (b2.m_pMax + b2.m_pMin) / 2;
  return b2;
}

// Combine two bounding box together.
BBox* BBox::Combine(const BBox *b1, const BBox *b2) {
  Vector3 pMin = Vector3::Min(b1->m_pMin, b2->m_pMin);
  Vector3 pMax = Vector3::Max(b1->m_pMax, b2->m_pMax);
  BBox *b = new BBox(pMin, pMax);
  return b;
}
