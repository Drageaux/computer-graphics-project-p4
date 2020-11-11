// points, vectors, frames in 3D
class VCT {
  float x = 0, 
    y = 0, 
    z = 0;
  // creation    
  VCT() {
  };
  VCT(float px, float py, float pz) {
    x = px;
    y = py;
    z = pz;
  };
  VCT(float px, float py) {
    x = px;
    y = py;
  };
  VCT set(float px, float py, float pz) {
    x = px;
    y = py;
    z = pz;
    return this;
  };
  VCT setTo(VCT V) {
    x = V.x;
    y = V.y;
    z = V.z;
    return this;
  };
  VCT set(VCT V) {
    x = V.x;
    y = V.y;
    z = V.z;
    return this;
  };

  // measure
  float norm() {
    return (sqrt(sq(x) + sq(y) + sq(z)));
  };

  //alteration
  VCT add(VCT V) {
    x += V.x;
    y += V.y;
    z += V.z;
    return this;
  };
  VCT add(float s, VCT V) {
    x += s * V.x;
    y += s * V.y;
    z += s * V.z;
    return this;
  };
  VCT sub(VCT V) {
    x -= V.x;
    y -= V.y;
    z -= V.z;
    return this;
  };
  VCT mul(float f) {
    x *= f;
    y *= f;
    z *= f;
    return this;
  };
  VCT div(float f) {
    x /= f;
    y /= f;
    z /= f;
    return this;
  };
  VCT div(int f) {
    x /= f;
    y /= f;
    z /= f;
    return this;
  };
  VCT rev() {
    x = -x;
    y = -y;
    z = -z;
    return this;
  };
  VCT normalize() {
    float n = norm();
    if (n > 0.000001) {
      div(n);
    };
    return this;
  };
  VCT rotate(float a, VCT I, VCT J) // Rotate this by angle a parallel in plane (I,J) Assumes I and J are orthogonal
  {
    float x = d(this, I), 
      y = d(this, J); // dot products
    float c = cos(a), 
      s = sin(a);
    add(x * c - x - y * s, I);
    add(x * s + y * c - y, J);
    return this;
  }
  VCT rotate(float a, VCT U) {
    setTo(R(this, a, U));
    return this;
  } // rotate this V by a around U, assuming|U|==1 and V*U==0
} // end class vec
class PNT {
  float x = 0, 
    y = 0, 
    z = 0;
  PNT() {
  };
  PNT(float px, float py) {
    x = px;
    y = py;
  };
  PNT(float px, float py, float pz) {
    x = px;
    y = py;
    z = pz;
  };
  PNT set(float px, float py, float pz) {
    x = px;
    y = py;
    z = pz;
    return this;
  };
  PNT set(PNT P) {
    x = P.x;
    y = P.y;
    z = P.z;
    return this;
  };
  PNT setTo(PNT P) {
    x = P.x;
    y = P.y;
    z = P.z;
    return this;
  };
  PNT setTo(float px, float py, float pz) {
    x = px;
    y = py;
    z = pz;
    return this;
  };
  PNT add(PNT P) {
    x += P.x;
    y += P.y;
    z += P.z;
    return this;
  };
  PNT add(VCT V) {
    x += V.x;
    y += V.y;
    z += V.z;
    return this;
  };
  PNT sub(VCT V) {
    x -= V.x;
    y -= V.y;
    z -= V.z;
    return this;
  };
  PNT add(float s, VCT V) {
    x += s * V.x;
    y += s * V.y;
    z += s * V.z;
    return this;
  };
  PNT sub(PNT P) {
    x -= P.x;
    y -= P.y;
    z -= P.z;
    return this;
  };
  PNT mul(float f) {
    x *= f;
    y *= f;
    z *= f;
    return this;
  };
  PNT div(float f) {
    x /= f;
    y /= f;
    z /= f;
    return this;
  };
  PNT div(int f) {
    x /= f;
    y /= f;
    z /= f;
    return this;
  };
}

// =====  vector functions
VCT V() {
  return new VCT();
}; // make vector (x,y,z)
VCT V(float x, float y, float z) {
  return new VCT(x, y, z);
}; // make vector (x,y,z)
VCT V(VCT V) {
  return new VCT(V.x, V.y, V.z);
}; // make copy of vector V
VCT A(VCT A, VCT B) {
  return new VCT(A.x + B.x, A.y + B.y, A.z + B.z);
}; // A+B
VCT A(VCT U, float s, VCT V) {
  return V(U.x + s * V.x, U.y + s * V.y, U.z + s * V.z);
}; // U+sV
VCT M(VCT U, VCT V) {
  return V(U.x - V.x, U.y - V.y, U.z - V.z);
}; // U-V
VCT M(VCT V) {
  return V( - V.x, -V.y, -V.z);
}; // -V
VCT V(VCT A, VCT B) {
  return new VCT((A.x + B.x) / 2.0, (A.y + B.y) / 2.0, (A.z + B.z) / 2.0);
} // (A+B)/2
VCT V(VCT A, float s, VCT B) {
  return new VCT(A.x + s * (B.x - A.x), A.y + s * (B.y - A.y), A.z + s * (B.z - A.z));
}; // (1-s)A+sB
VCT V(VCT A, VCT B, VCT C) {
  return new VCT((A.x + B.x + C.x) / 3.0, (A.y + B.y + C.y) / 3.0, (A.z + B.z + C.z) / 3.0);
}; // (A+B+C)/3
VCT V(VCT A, VCT B, VCT C, VCT D) {
  return V(V(A, B), V(C, D));
}; // (A+B+C+D)/4
VCT V(float s, VCT A) {
  return new VCT(s * A.x, s * A.y, s * A.z);
}; // sA
VCT S(VCT U, float s, VCT V) {
  return V(U.x + s * V.x, U.y + s * V.y, U.z + s * V.z);
}; // U+sV
VCT V(float a, VCT A, float b, VCT B) {
  return A(V(a, A), V(b, B));
} // aA+bB 
VCT V(float a, VCT A, float b, VCT B, float c, VCT C) {
  return A(V(a, A, b, B), V(c, C));
} // aA+bB+cC
VCT V(PNT P, PNT Q) {
  return new VCT(Q.x - P.x, Q.y - P.y, Q.z - P.z);
}; // PQ
VCT U(VCT V) {
  float n = V.norm();
  if (n < 0.0000001) return V(0, 0, 0);
  else return V(1. / n, V);
}; // V/||V||
VCT U(PNT P, PNT Q) {
  return U(V(P, Q));
}; // PQ/||PQ||
VCT U(float x, float y, float z) {
  return U(V(x, y, z));
}; // make vector (x,y,z)
VCT N(VCT U, VCT V) {
  return V(U.y * V.z - U.z * V.y, U.z * V.x - U.x * V.z, U.x * V.y - U.y * V.x);
}; // UxV cross product (normal to both)
VCT cross(VCT U, VCT V) {
  return V(U.y * V.z - U.z * V.y, U.z * V.x - U.x * V.z, U.x * V.y - U.y * V.x);
}; // UxV cross product (normal to both)
VCT N(PNT A, PNT B, PNT C) {
  return N(V(A, B), V(A, C));
}; // normal to triangle (A,B,C), not normalized (proportional to area)
VCT B(VCT U, VCT V) {
  return U(N(N(U, V), U));
} // normal to U in plane (U,V)
VCT Normal(VCT V) { // vector orthogonal to V
  if (abs(V.z) <= min(abs(V.x), abs(V.y))) return V( - V.y, V.x, 0);
  if (abs(V.x) <= min(abs(V.z), abs(V.y))) return V(0, -V.z, V.y);
  return V(V.z, 0, -V.x);
}
float mixed(VCT U, VCT V, VCT W) {
  return dot(U, cross(V, W));
}

// ===== point functions
PNT P() {
  return new PNT();
}; // point (x,y,z)
PNT P(float x, float y, float z) {
  return new PNT(x, y, z);
}; // point (x,y,z)
PNT P(float x, float y) {
  return new PNT(x, y);
}; // make point (x,y)
PNT P(PNT A) {
  return new PNT(A.x, A.y, A.z);
}; // copy of point P
PNT P(PNT A, float s, PNT B) {
  return new PNT(A.x + s * (B.x - A.x), A.y + s * (B.y - A.y), A.z + s * (B.z - A.z));
}; // A+sAB
PNT L(PNT A, float s, PNT B) {
  return new PNT(A.x + s * (B.x - A.x), A.y + s * (B.y - A.y), A.z + s * (B.z - A.z));
}; // A+sAB
PNT P(PNT A, PNT B) {
  return P((A.x + B.x) / 2.0, (A.y + B.y) / 2.0, (A.z + B.z) / 2.0);
} // (A+B)/2
PNT P(PNT A, PNT B, PNT C) {
  return new PNT((A.x + B.x + C.x) / 3.0, (A.y + B.y + C.y) / 3.0, (A.z + B.z + C.z) / 3.0);
}; // (A+B+C)/3
PNT P(PNT A, PNT B, PNT C, PNT D) {
  return P(P(A, B), P(C, D));
}; // (A+B+C+D)/4
PNT P(float s, PNT A) {
  return new PNT(s * A.x, s * A.y, s * A.z);
}; // sA
PNT A(PNT A, PNT B) {
  return new PNT(A.x + B.x, A.y + B.y, A.z + B.z);
}; // A+B
PNT P(float a, PNT A, float b, PNT B) {
  return A(P(a, A), P(b, B));
} // aA+bB 
PNT P(float a, PNT A, float b, PNT B, float c, PNT C) {
  return A(P(a, A), P(b, B, c, C));
} // aA+bB+cC 
PNT P(float a, PNT A, float b, PNT B, float c, PNT C, float d, PNT D) {
  return A(P(a, A, b, B), P(c, C, d, D));
} // aA+bB+cC+dD
PNT P(PNT P, VCT V) {
  return new PNT(P.x + V.x, P.y + V.y, P.z + V.z);
} // P+V
PNT P(PNT P, float s, VCT V) {
  return new PNT(P.x + s * V.x, P.y + s * V.y, P.z + s * V.z);
} // P+sV
PNT P(PNT O, float x, VCT I, float y, VCT J) {
  return P(O.x + x * I.x + y * J.x, O.y + x * I.y + y * J.y, O.z + x * I.z + y * J.z);
} // O+xI+yJ
PNT P(PNT O, float x, VCT I, float y, VCT J, float z, VCT K) {
  return P(O.x + x * I.x + y * J.x + z * K.x, O.y + x * I.y + y * J.y + z * K.y, O.z + x * I.z + y * J.z + z * K.z);
} // O+xI+yJ+kZ
void makePts(PNT[] C) {
  for (int i = 0; i < C.length; i++) C[i] = P();
}
PNT Bezier(PNT A, PNT B, PNT C, float t) {
  return L(L(A, t, B), t, L(B, t, C));
}

// ===== mouse
PNT Mouse() {
  return P(mouseX, mouseY, 0);
}; // current mouse location
PNT Pmouse() {
  return P(pmouseX, pmouseY, 0);
};
VCT MouseDrag() {
  return V(mouseX - pmouseX, mouseY - pmouseY, 0);
}; // vector representing recent mouse displacement
PNT ScreenCenter() {
  return P(width / 2, height / 2);
} //  point in center of  canvas
// ===== measures
float d(VCT U, VCT V) {
  return U.x * V.x + U.y * V.y + U.z * V.z;
}; //U*V dot product
float dot(VCT U, VCT V) {
  return U.x * V.x + U.y * V.y + U.z * V.z;
}; //U*V dot product
float det2(VCT U, VCT V) {
  return - U.y * V.x + U.x * V.y;
}; // U:V det product of (x,y) components
float det3(VCT U, VCT V) {
  return sqrt(d(U, U) * d(V, V) - sq(d(U, V)));
}; // U:V det product (norm of UxV)
float m(VCT U, VCT V, VCT W) {
  return d(U, N(V, W));
}; // U*(VxW)  mixed product, determinant
float m(PNT E, PNT A, PNT B, PNT C) {
  return m(V(E, A), V(E, B), V(E, C));
} // det (EA EB EC) is >0 when E sees (A,B,C) clockwise
float n2(VCT V) {
  return sq(V.x) + sq(V.y) + sq(V.z);
}; // V*V    norm squared
float n(VCT V) {
  return sqrt(n2(V));
}; // ||V||  norm
float norm(VCT V) {
  return sqrt(n2(V));
}; // ||V||  norm
float d(PNT P, PNT Q) {
  return sqrt(sq(Q.x - P.x) + sq(Q.y - P.y) + sq(Q.z - P.z));
}; // ||AB|| distance
float area(PNT A, PNT B, PNT C) {
  return n(N(A, B, C)) / 2;
}; // (positive) area of triangle in 3D
float volume(PNT A, PNT B, PNT C, PNT D) {
  return m(V(A, B), V(A, C), V(A, D)) / 6;
}; // (signed) volume of tetrahedron
boolean parallel(VCT U, VCT V) {
  return n(N(U, V)) < n(U) * n(V) * 0.00001;
} // true if U and V are almost parallel
float angle(VCT U, VCT V) {
  return acos(d(U, V) / n(V) / n(U));
}; // angle(U,V) positive  (in 0,PI)
float angleAroundVertical(VCT U, VCT V) {
  return atan2(mixed(upDirection, U, V), d(U, V));
}; // angle(U,V) positive  (in 0,PI)
boolean cw(VCT U, VCT V, VCT W) {
  return m(U, V, W) > 0;
}; // U*(VxW)>0  U,V,W are clockwise in 3D
boolean cw(PNT A, PNT B, PNT C, PNT D) {
  return volume(A, B, C, D) > 0;
}; // tet is oriented so that A sees B, C, D clockwise 
boolean projectsBetween(PNT P, PNT A, PNT B) {
  return dot(V(A, P), V(A, B)) > 0 && dot(V(B, P), V(B, A)) > 0;
};
float disToLine(PNT P, PNT A, PNT B) {
  return det3(U(A, B), V(A, P));
};
PNT projectionOnLine(PNT P, PNT A, PNT B) {
  return P(A, dot(V(A, B), V(A, P)) / dot(V(A, B), V(A, B)), V(A, B));
}

// ===== rotations 
VCT R(VCT V) {
  return V( - V.y, V.x, V.z);
} // rotated 90 degrees in XY plane
PNT R(PNT P, float a, VCT I, VCT J, PNT G) {
  float x = d(V(G, P), I), 
    y = d(V(G, P), J);
  float c = cos(a), 
    s = sin(a);
  return P(P, x * c - x - y * s, I, x * s + y * c - y, J);
}; // Rotated P by a around G in plane (I,J)
VCT R(VCT V, float a, VCT U) {
  VCT W = cross(U, V);
  return V(cos(a), V, sin(a), W);
} // rotate V by a around U, assuming|U|==1 and V*U==0
VCT LPM(VCT U, float t, VCT V) // log-polar morph between U and V
{
  VCT B = U(cross(U, V));
  VCT N = cross(B, U);
  float a = angle(U, V);
  VCT W = V(cos(a * t), U, sin(a * t), N);
  float m = n(V) / n(U);
  return V(pow(m, t), W);
}
VCT R(VCT V, float a, VCT I, VCT J) {
  float x = d(V, I), 
    y = d(V, J);
  float c = cos(a), 
    s = sin(a);
  return A(V, V(x * c - x - y * s, I, x * s + y * c - y, J));
}; // Rotated V by a parallel to plane (I,J)
PNT R(PNT Q, float a) {
  float dx = Q.x, 
    dy = Q.y, 
    c = cos(a), 
    s = sin(a);
  return P(c * dx + s * dy, -s * dx + c * dy, Q.z);
}; // Q rotated by angle a around the origin
PNT R(PNT Q, float a, PNT C) {
  float dx = Q.x - C.x, 
    dy = Q.y - C.y, 
    c = cos(a), 
    s = sin(a);
  return P(C.x + c * dx - s * dy, C.y + s * dx + c * dy, Q.z);
}; // Q rotated by angle a around point P
PNT R(PNT Q, PNT C, PNT P, PNT R) // returns rotated version of Q by angle(CP,CR) parallel to plane (C,P,R)
{
  VCT I0 = U(C, P), 
    I1 = U(C, R), 
    V = V(C, Q);
  float c = d(I0, I1), 
    s = sqrt(1. - sq(c));
  if (abs(s) < 0.00001) return Q; // singular cAW
  VCT J0 = V(1. / s, I1, -c / s, I0);
  VCT J1 = V( - s, I0, c, J0);
  float x = d(V, I0), 
    y = d(V, J0);
  return P(Q, x, M(I1, I0), y, M(J1, J0));
}

// ===== rending functions
void normal(VCT V) {
  normal(V.x, V.y, V.z);
}; // changes current normal vector for subsequent smooth shading
void vertex(PNT P) {
  vertex(P.x, P.y, P.z);
}; // vertex for shading or drawing
void v(PNT P) {
  vertex(P.x, P.y, P.z);
}; // vertex for shading or drawing (between BeginShape() ; and endShape();)
void vTextured(PNT P, float u, float v) {
  vertex(P.x, P.y, P.z, u, v);
}; // vertex with texture coordinates
void show(PNT P, PNT Q) {
  line(Q.x, Q.y, Q.z, P.x, P.y, P.z);
}; // render edge (P,Q)
void show(PNT P, VCT V) {
  line(P.x, P.y, P.z, P.x + V.x, P.y + V.y, P.z + V.z);
}; // render edge from P to P+V
void show(PNT P, float d, VCT V) {
  line(P.x, P.y, P.z, P.x + d * V.x, P.y + d * V.y, P.z + d * V.z);
}; // render edge from P to P+dV
void show(PNT A, PNT B, PNT C) {
  beginShape();
  vertex(A);
  vertex(B);
  vertex(C);
  endShape(CLOSE);
}; // render Triangle(A,B,C)
void show(PNT A, PNT B, PNT C, PNT D) {
  beginShape();
  vertex(A);
  vertex(B);
  vertex(C);
  vertex(D);
  endShape(CLOSE);
}; // render Quad(A,B,C,D)
void show(PNT P, float s, VCT I, VCT J, VCT K) {
  noStroke();
  fill(yellow);
  show(P, 5);
  stroke(red);
  show(P, s, I);
  stroke(green);
  show(P, s, J);
  stroke(blue);
  show(P, s, K);
}; // render coordinate system
void show(PNT P, String s) {
  text(s, P.x, P.y, P.z);
}; // prints string s in 3D at P
void show(PNT P, String s, VCT D) {
  text(s, P.x + D.x, P.y + D.y, P.z + D.z);
}; // prints string s in 3D at P+D (offset vector)
void show(PNT P, float r) {
  pushMatrix();
  translate(P.x, P.y, P.z);
  sphere(r);
  popMatrix();
}; // render sphere of radius r and center P
void showSquashedBall(PNT P, float r, float s) {
  pushMatrix();
  translate(P.x, P.y, P.z);
  scale(1, 1, s);
  sphere(r);
  popMatrix();
}; // render sphere of radius r and center P
void showShadow(PNT P, float r) {
  pushMatrix();
  translate(P.x, P.y, 0);
  scale(1, 1, 0.01);
  sphere(r);
  popMatrix();
} // render shadow on the floot of sphere of radius r and center P
//===== SUBDIVISION
PNT B(PNT A, PNT B, PNT C, float s) {
  return (P(P(B, s / 4., A), 0.5, P(B, s / 4., C)));
}; // returns a tucked B towards its neighbors
PNT F(PNT A, PNT B, PNT C, PNT D, float s) {
  return (P(P(A, 1. + (1. - s) / 8., B), 0.5, P(D, 1. + (1. - s) / 8., C)));
}; // returns a bulged mid-edge point 
