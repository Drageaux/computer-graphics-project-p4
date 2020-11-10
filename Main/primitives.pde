// **************************** DISPLAY PRIMITIVES (spheres, cylinders, cones, arrows) from 3D Pts, Vecs *********
// procedures for showing balls and lines are in tab "pv3D" (for example "show(P,r)")

void sphere(PNT P, float r) {pushMatrix(); translate(P.x,P.y,P.z); sphere(r); popMatrix();}; // render sphere of radius r and center P (same as show(P,r))

// **************************** PRIMITIVE FROM POINT, VECTOR, RADIUS PARAMETER
void caplet(PNT A, float a, PNT B, float b) { // cone section surface that is tangent to Sphere(A,a) and to Sphere(B,b)
  VCT I = U(A,B);
  float d = d(A,B), s=b/a;
  float x=(a-b)*a/d, y = sqrt(sq(a)-sq(x));
  PNT PA = P(A,x,I), PB = P(B,s*x,I); 
  coneSection(PA,PB,y,y*s);
  }  

void coneSection(PNT P, PNT Q, float p, float q) { // surface
  VCT V = V(P,Q);
  VCT I = U(Normal(V));
  VCT J = U(N(I,V));
  collar(P,V,I,J,p,q);
  }

void collar(PNT P, VCT V, VCT I, VCT J, float r, float rd) {
  float da = TWO_PI/36;
  beginShape(QUAD_STRIP);
    for(float a=0; a<=TWO_PI+da; a+=da) {v(P(P,r*cos(a),I,r*sin(a),J,0,V)); v(P(P,rd*cos(a),I,rd*sin(a),J,1,V));}
  endShape();
  }

// FANS, CONES, AND ARROWS
void arrow(PNT A, PNT B, float r) {
  VCT V=V(A,B);
  stub(A,V(.8,V),r*2/3,r/3); 
  cone(P(A,V(.8,V)),V(.2,V),r); 
  }  

void arrow(PNT P, float s, VCT V, float r) {arrow(P,V(s,V),r);}

void arrow(PNT P, VCT V, float r) {
  stub(P,V(.8,V),r*2/3,r/3); 
  cone(P(P,V(.8,V)),V(.2,V),r); 
  }  
  
void cone(PNT P, VCT V, float r) {fan(P,V,r); disk(P,V,r);}


void stub(PNT P, VCT V, float r, float rd) // cone section
  {
  collar(P,V,r,rd); disk(P,V,r); disk(P(P,V),V,rd); 
  }

void collar(PNT P, VCT V, float r, float rd) {
  VCT I = U(Normal(V));
  VCT J = U(N(I,V));
  collar(P,V,I,J,r,rd);
  }
 
void disk(PNT P, VCT I, VCT J, float r) {
  float da = TWO_PI/36;
  beginShape(TRIANGLE_FAN);
    v(P);
    for(float a=0; a<=TWO_PI+da; a+=da) v(P(P,r*cos(a),I,r*sin(a),J));
  endShape();
  }
  
void disk(PNT P, VCT V, float r) {  
  VCT I = U(Normal(V));
  VCT J = U(N(I,V));
  disk(P,I,J,r);
  }

void fan(PNT P, VCT V, VCT I, VCT J, float r) {
  float da = TWO_PI/36;
  beginShape(TRIANGLE_FAN);
    v(P(P,V));
    for(float a=0; a<=TWO_PI+da; a+=da) v(P(P,r*cos(a),I,r*sin(a),J));
  endShape();
  }
  
void fan(PNT P, VCT V, float r) {  
  VCT I = U(Normal(V));
  VCT J = U(N(I,V));
  fan(P,V,I,J,r);
  }

void showFloor() 
    {
    //fill(yellow); 
    pushMatrix(); 
      translate(0,0,-1.5); 
      float d=100;
      int n=20;
      pushMatrix();
        translate(0,-d*n/2,0);
          for(int j=0; j<n; j++)
            {
            pushMatrix();
              translate(-d*n/2,0,0);
              for(int i=0; i<n; i++)
                {
                fill(lightWood); box(d,d,1);  pushMatrix(); translate(d,d,0);  box(d,d,1); popMatrix();
                fill(darkWood); pushMatrix(); translate(d,0,0); box(d,d,1); translate(-d,d,0); box(d,d,1); popMatrix();
                translate(2*d,0,0);
                }
            popMatrix();
            translate(0,2*d,0);
            }
      popMatrix(); // draws floor as thin plate
    popMatrix(); // draws floor as thin plate
    }
  
