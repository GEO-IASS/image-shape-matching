// Tao Du
// taodu@stanford.edu
// Feb 14, 2015

#ifndef _LINE_H_
#define _LINE_H_

#include "vector3.h"

class Line {
 public:
  Line(const Vector3 &origin, const Vector3 &direction)
    : m_origin(origin), m_direction(direction) {}
  Vector3 GetDirection() const { return m_direction; }
  Vector3 GetOrigin() const { return m_origin; }

  // Overload operator.
  Vector3 operator()(double t) const { return m_origin + m_direction * t; }

 private:
  // Data member.
  // Origin.
  Vector3 m_origin;
  // It is not required to normalized the direction
  Vector3 m_direction;
};

#endif
