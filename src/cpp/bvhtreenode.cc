// Tao Du
// taodu@stanford.edu
// Feb 14, 2015

#include "bvhtreenode.h"

bool CompareX(Triangle* t1, Triangle* t2) {
  Vector3 c1 = t1->GetBBox().GetCenter();
  Vector3 c2 = t2->GetBBox().GetCenter();
  return c1.x < c2.x;
}

bool CompareY(Triangle* t1, Triangle* t2) {
  Vector3 c1 = t1->GetBBox().GetCenter();
  Vector3 c2 = t2->GetBBox().GetCenter();
  return c1.y < c2.y;
}

bool CompareZ(Triangle* t1, Triangle* t2) {
  Vector3 c1 = t1->GetBBox().GetCenter();
  Vector3 c2 = t2->GetBBox().GetCenter();
  return c1.z < c2.z;
}

// Init a bvh tree leaf node.
BVHTreeNode::BVHTreeNode(Triangle *triangle) {
  // build a leaf node.
  this->bbox = triangle->GetBBox();
  this->triangle = triangle;
  this->left = this->right = NULL;
}

// Init a bvh tree.
BVHTreeNode::BVHTreeNode(std::vector<Triangle *> &objs) {
  int num = (int)objs.size();
  if (num == 0) {
    this->triangle = NULL;
    this->left = this->right = NULL;
  } else if (num == 1) {
    this->triangle = objs.at(0);
    this->left = this->right = NULL;
    this->bbox = this->triangle->GetBBox();
  } else if (num == 2) {
    this->triangle = NULL;
    this->left = new BVHTreeNode(objs[0]);
    this->right = new BVHTreeNode(objs[1]);
    this->bbox = BBox::Combine(this->left->bbox, this->right->bbox);
  } else {
    BBox bound;
    for (int i = 0; i < num; i++) {
      bound = BBox::Combine(bound, objs[i]->GetBBox());
    }
    int id = bound.GetMaxExtentId();
    switch (id) {
      case 0:
        std::sort(objs.begin(), objs.end(), CompareX);
        break;
      case 1:
        std::sort(objs.begin(), objs.end(), CompareY);
        break;
      case 2:
      default:
        std::sort(objs.begin(), objs.end(), CompareZ);
        break;
    }
    std::vector<Triangle *> lobjs;
    std::vector<Triangle *> robjs;
    for (int i = 0; i < num / 2; i++)
      lobjs.push_back(objs[i]);
    for (int i = num / 2; i < num; i++)
      robjs.push_back(objs[i]);
 
   this->triangle = NULL;
   this->left = new BVHTreeNode(lobjs);
   this->right = new BVHTreeNode(robjs);
   this->bbox = BBox::Combine(this->left->bbox, this->right->bbox);
  }
}

// Delete a bvh tree node.
BVHTreeNode::~BVHTreeNode() {
  if (left)
    delete left;
  if (right)
    delete right;
}

Intersection BVHTreeNode::GetIntersection(const Line &l) const {
  if (triangle) {
    // Leaf node.
    return triangle->GetIntersection(l);
  } else {
    // Interior node.
    if (this->bbox.DoesIntersect(l)) {
      // Test left and right.
      Intersection iLeft = left->GetIntersection(l);
      Intersection iRight = right->GetIntersection(l);
      // Decide which one is closer.
      if (iLeft.t == DBL_MAX)
        return iRight;
      else if (iRight.t == DBL_MAX)
        return iLeft;
      else
        return iLeft.t < iRight.t ? iLeft : iRight;
    } else {
      // no intersection
      return Intersection(
        Vector3(DBL_MAX, DBL_MAX, DBL_MAX),
        DBL_MAX
      );
    }
  }
}

bool BVHTreeNode::DoesIntersect(const Line &l) const {
  return GetIntersectionT(l) != DBL_MAX;
}

double BVHTreeNode::GetIntersectionT(const Line &l) const {
  if (triangle) {
    // Leaf node.
    return triangle->GetIntersectionT(l);
  } else {
    // Interior node.
    if (this->bbox.DoesIntersect(l)) {
      double tLeft = this->left->GetIntersectionT(l);
      double tRight = this->right->GetIntersectionT(l);
      if (tLeft == DBL_MAX)
        return tRight;
      else if (tRight == DBL_MAX)
        return tLeft;
      else
        return tLeft < tRight ? tLeft : tRight;
    } else {
      return DBL_MAX;
    }
  }
}
