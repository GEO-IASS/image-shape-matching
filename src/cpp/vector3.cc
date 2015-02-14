// Tao Du
// taodu@stanford.edu
// Feb 14, 2015

#include "cppheader.h"
#include "vector3.h"

Vector3::Vector3() {
  x = y = z = 0.0;
}

Vector3::Vector3(double x, double y, double z) {
  this->x = x;
  this->y = y;
  this->z = z;
}

Vector3::Vector3(const Vector3& v) {
  x = v.x;
  y = v.y;
  z = v.z;
}

// Assignment.
Vector3& Vector3::operator=(const Vector3& v) {
  x = v.x;
  y = v.y;
  z = v.z;
  return (*this);
}

// [] subscription.
double& Vector3::operator[](int i) {
  // The index should be in the range [0, 3).
  assert(i >= 0 && i < 3);
  switch (i) {
    case 0:
      return x;
    case 1:
      return y;
    default: // i == 2.
      return z;
  }
}

// [] subscription.
const double& Vector3::operator[](int i) const {
  // The index should be in the range [0, 3).
  assert(i >= 0 && i < 3);
  switch (i) {
    case 0:
      return x;
    case 1:
      return y;
    default: // i == 2.
      return z;
  }
}
// - prefix.
Vector3 Vector3::operator-() const {
  Vector3 v;
  v.x = -x;
  v.y = -y;
  v.z = -z;
  return v;
}

Vector3& Vector3::operator+=(double d) {
  x += d;
  y += d;
  z += d;
  return (*this);
}

Vector3& Vector3::operator+=(const Vector3& v) {
  x += v.x;
  y += v.y;
  z += v.z;
  return (*this);
}

Vector3& Vector3::operator-=(double d) {
  x -= d;
  y -= d;
  z -= d;
  return (*this);
}

Vector3& Vector3::operator-=(const Vector3& v) {
  x -= v.x;
  y -= v.y;
  z -= v.z;
  return (*this);
}

Vector3& Vector3::operator*=(double d) {
  x *= d;
  y *= d;
  z *= d;
  return (*this);
}

// Component wise product.
Vector3& Vector3::operator*=(const Vector3& v) {
  x *= v.x;
  y *= v.y;
  z *= v.z;
  return (*this);
}

Vector3& Vector3::operator/=(double d) {
  // Report assertion failed if d is too small.
  assert(abs(d) > DBL_EPSILON);
  double invd = 1.0 / d;
  x *= invd;
  y *= invd;
  z *= invd;
  return (*this);
}

// Component wise division.
Vector3& Vector3::operator/=(const Vector3& v) {
  // Report assertion failed if v is too small.
  assert(abs(v.x) > DBL_EPSILON && abs(v.y) > DBL_EPSILON &&
         abs(v.z) > DBL_EPSILON);
  x /= v.x;
  y /= v.y;
  z /= v.z;
  return (*this);
}

// Length.
double Vector3::Length() const {
  return sqrt(x * x + y * y + z * z);
}

// LengthSquared.
double Vector3::LengthSquared() const {
  return x * x + y * y + z * z;
}

// Cross product.
Vector3 Vector3::Cross(const Vector3 &left, const Vector3 &right) {
  Vector3 v;
  v.x = left.y * right.z - left.z * right.y;
  v.y = left.z * right.x - left.x * right.z;
  v.z = left.x * right.y - left.y * right.x;
  return v;
}

// Dot product.
double Vector3::Dot(const Vector3 &left, const Vector3 &right) {
  return left.x * right.x + left.y * right.y + left.z * right.z;
}

// Component-wise min and max.
Vector3 Vector3::Min(const Vector3 &left, const Vector3 &right) {
  Vector3 p;
  p.x = left.x > right.x ? right.x : left.x;
  p.y = left.y > right.y ? right.y : left.y;
  p.z = left.z > right.z ? right.z : left.z;
  return p;
}

Vector3 Vector3::Max(const Vector3 &left, const Vector3 &right) {
  Vector3 p;
  p.x = left.x < right.x ? right.x : left.x;
  p.y = left.y < right.y ? right.y : left.y;
  p.z = left.z < right.z ? right.z : left.z;
  return p;
}

// Binary operators that won't change left/right operand.
Vector3 operator+(const Vector3& left, const Vector3& right) {
  Vector3 v;
  v.x = left.x + right.x;
  v.y = left.y + right.y;
  v.z = left.z + right.z;
  return v;
}

Vector3 operator+(const Vector3& left, double right) {
  Vector3 v;
  v.x = left.x + right;
  v.y = left.y + right;
  v.z = left.z + right;
  return v;
}

Vector3 operator+(double left, const Vector3& right) {
  Vector3 v;
  v.x = left + right.x;
  v.y = left + right.y;
  v.z = left + right.z;
  return v;
}

// Minus.
Vector3 operator-(const Vector3& left, const Vector3& right) {
  Vector3 v;
  v.x = left.x - right.x;
  v.y = left.y - right.y;
  v.z = left.z - right.z;
  return v;
}

Vector3 operator-(const Vector3& left, double right) {
  Vector3 v;
  v.x = left.x - right;
  v.y = left.y - right;
  v.z = left.z - right;
  return v;
}

Vector3 operator-(double left, const Vector3& right) {
  Vector3 v;
  v.x = left - right.x;
  v.y = left - right.y;
  v.z = left - right.z;
  return v;
}

// Product.
// Component wise product.
Vector3 operator*(const Vector3& left, const Vector3& right) {
  Vector3 v;
  v.x = left.x * right.x;
  v.y = left.y * right.y;
  v.z = left.z * right.z;
  return v;
}

Vector3 operator*(const Vector3& left, double right) {
  Vector3 v;
  v.x = left.x * right;
  v.y = left.y * right;
  v.z = left.z * right;
  return v;
}

Vector3 operator*(double left, const Vector3& right) {
  Vector3 v;
  v.x = left * right.x;
  v.y = left * right.y;
  v.z = left * right.z;
  return v;
}

// Division.
// Component wise division.
Vector3 operator/(const Vector3& left, const Vector3& right) {
  assert(abs(right.x) > DBL_EPSILON && abs(right.y) > DBL_EPSILON &&
         abs(right.z) > DBL_EPSILON);
  Vector3 v;
  v.x = left.x / right.x;
  v.y = left.y / right.y;
  v.z = left.z / right.z;
  return v;
}

Vector3 operator/(const Vector3& left, double right) {
  assert(abs(right) > DBL_EPSILON);
  double invd = 1.0 / right;
  Vector3 v;
  v.x = left.x * invd;
  v.y = left.y * invd;
  v.z = left.z * invd;
  return v;
}

Vector3 operator/(double left, const Vector3& right) {
  assert(abs(right.x) > DBL_EPSILON && abs(right.y) > DBL_EPSILON &&
         abs(right.z) > DBL_EPSILON);
  Vector3 v;
  v.x = left / right.x;
  v.y = left / right.y;
  v.z = left / right.z;
  return v;
}
