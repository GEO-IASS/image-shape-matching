// Tao Du
// taodu@stanford.edu
// Feb 14, 2015

#ifndef _BVHTREENODE_H_
#define _BVHTREENODE_H_

#include "cppheader.h"
#include "triangle.h"

class BVHTreeNode : public Shape {
  BVHTreeNode(Triangle *triangle);
  BVHTreeNode(std::vector<Triangle *> &objs);
  virtual ~BVHTreeNode();

  Intersection GetIntersection(const Line &l) const;
  bool DoesIntersect(const Line &l) const;
  double GetIntersectionT(const Line &l) const;

  // Get the bounding box.
  BBox GetBBox() const { return bbox; }

  // Interior node: triangle = NULL.
  // Leaf node: triangle != NULL, left = right = NULL.
  BBox bbox;
  Triangle *triangle;
  BVHTreeNode *left;
  BVHTreeNode *right;
};

#endif
