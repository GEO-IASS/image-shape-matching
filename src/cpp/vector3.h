// Tao Du
// taodu@stanford.edu
// Feb 14, 2015

#ifndef _VECTOR3_H_
#define _VECTOR3_H_

class Vector3 {
 public:
  // Initialization.
  Vector3();
  Vector3(double x, double y, double z);
  Vector3(const Vector3& v);
 
  // Overload operator.
  // Assignment.
  Vector3& operator=(const Vector3& v);
  // [] subscription.
  double& operator[](int i);
  const double& operator[](int i) const;
 
  // - prefix.
  Vector3 operator-() const;
 
  // Binary operator that treats left/right operand differently.
  Vector3& operator+=(double d);
  Vector3& operator+=(const Vector3& v);
  Vector3& operator-=(double d);
  Vector3& operator-=(const Vector3& v);
  Vector3& operator*=(double d);
  // Component wise product.
  Vector3& operator*=(const Vector3& v);
  Vector3& operator/=(double d);
  // Component wise division.
  Vector3& operator/=(const Vector3& v);
 
  // Length.
  double Length() const;
  // LengthSquared.
  double LengthSquared() const;
 
  // Static method:
  // Cross product.
  static Vector3 Cross(const Vector3 &left, const Vector3 &right);
  // Dot product.
  static double Dot(const Vector3 &left, const Vector3 &right);
 
  // Component-wise min and max.
  static Vector3 Min(const Vector3 &left, const Vector3 &right);
  static Vector3 Max(const Vector3 &left, const Vector3 &right);
 
  // Data members.
  double x, y, z;
};

// Binary operator that won't change left/right operand.
// Plus.
Vector3 operator+(const Vector3& left, const Vector3& right);
Vector3 operator+(const Vector3& left, double right);
Vector3 operator+(double left, const Vector3& right);
// Minus.
Vector3 operator-(const Vector3& left, const Vector3& right);
Vector3 operator-(const Vector3& left, double right);
Vector3 operator-(double left, const Vector3& right);
// Product.
// Component wise product.
Vector3 operator*(const Vector3& left, const Vector3& right);
Vector3 operator*(const Vector3& left, double right);
Vector3 operator*(double left, const Vector3& right);
// Division.
// Component wise division.
Vector3 operator/(const Vector3& left, const Vector3& right);
Vector3 operator/(const Vector3& left, double right);
Vector3 operator/(double left, const Vector3& right);

#endif
