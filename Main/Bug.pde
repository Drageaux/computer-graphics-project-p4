VCT upDirection = V(0, 0, 1);
PNT target = P(800, 0, 0);
BUG bug = new BUG();
class BUG // class for manipulaitng a bug
  // BUG is degined by a ring of hips, a ring of down-feet and a ring of up-feet
{

  // STUDENTS: FEEL FREE TO CHANGE THE VARIABLES AND METHODS BELOW


  // ***** FIXED PARAMETERS *****
  float heightOfRingOfHips = 100; // height of ring of hips
  float radiusOfRingOfHips = 60; // radius of ring of hips
  float radiusOfHips = 20; // hip ball radius

  // body sphere
  float bodyElevationAboveRingOfHips = 5; //20
  float radiusOfBody = 60; // 50

  // knees
  float radiusOfKnees = 15; // knee ball radius

  // feet
  float radiusOfRingOfFeet = 300; // radius of ring of hips
  float radiusOfFeet = 10;
  float upFeetMaxHeight = 150; // !! change and control

  // legs
  float limbLength = 400;

  // motion
  float stepLength = 3; // controls translation speed towards Target

  // ***** CONTROL PARAMETERS *****
  VCT forwardDirection = V(); // where the bug is facing
  PNT shadowOfCenterOfRingOfHips = P(); // floor projection of the center of the body of the bug
  PNT centerOfRingOfDownFeet = P(); // remembers the floor projection of the centtoid of the 3 support feet
  float rotationAngle = 0;
  boolean evenFeetAreSupporting = true; // used to toggle which are the fixed (support) feet

  // ***** COMPUTED PARAMETERS *****
  PNT centerOfRingOfHips = P();
  PNT centerOfBody = P();
  PNT shadowOfCenterOfRingOfUpFeet = P();
  PNT centerOfRingOfUpFeet = P();
  PNT[] hips = new PNT[6];
  PNT[] feet = new PNT[6];

  BUG() {
  }

  void declare() {
    VCT bodyToHip = V(0, radiusOfRingOfHips, heightOfRingOfHips);
    PNT ringOfHipsCenter = P(centerOfBody.x, centerOfBody.y, heightOfRingOfHips);
    hips[0] = P(centerOfBody, bodyToHip);
    VCT xAxis = V(1, 0, 0);
    VCT yAxis = V(0, 1, 0);
    for (int i = 1; i < 6; i++) {
      hips[i] = R(hips[i - 1], PI / 3, xAxis, yAxis, ringOfHipsCenter);
    }

    VCT bodyToFoot = V(0, radiusOfRingOfFeet, 0);
    feet[0] = P(centerOfBody, bodyToFoot);
    PNT ringOfFeetCenter = P(centerOfBody.x, centerOfBody.y, 0);
    for (int i = 1; i < 6; i++) {
      feet[i] = R(feet[i - 1], PI / 3, xAxis, yAxis, ringOfFeetCenter);
    }
  }

  void reset() {
    shadowOfCenterOfRingOfHips = P();
    centerOfRingOfDownFeet = P();
    forwardDirection = V(1, 0, 0);
    rotationAngle = 0;
  }

  void moveTowardsTarget(PNT newTarget) {
    target = newTarget;
  }
  
  static final float velocity = 1.0;
  static final float angularVelocity = 0.01; // Max rotation per frame
  float distSinceLastSwap = 0; // Distance traveled since last time feet are swapped
  static final float swapDistThreshold = 20; // Threshold of distSinceLastSwap to swap feet
  
  final VCT xAxis = V(1, 0, 0);
  final VCT yAxis = V(0, 1, 0);
  final VCT zAxis = V(0, 0, 1);

  void updateConfiguration() {
    centerOfBody = P(shadowOfCenterOfRingOfHips, heightOfRingOfHips + bodyElevationAboveRingOfHips, upDirection);
    VCT newDirection = U(V(shadowOfCenterOfRingOfHips, target));
    shadowOfCenterOfRingOfHips = P(shadowOfCenterOfRingOfHips, velocity, newDirection);
    centerOfRingOfHips = P(centerOfRingOfHips, velocity, newDirection);
    centerOfRingOfUpFeet = P(centerOfRingOfUpFeet, velocity, newDirection);
    
    distSinceLastSwap += velocity;
    if (distSinceLastSwap > swapDistThreshold) {
      swapFeet();
    }
    
    VCT currentBodyToFoot0 = U(V(shadowOfCenterOfRingOfHips, feet[0]));
    //float angleToRotate;
    
    //if (!evenFeetAreSupporting) {
    //  // Final direction of hip0 after rotation completes
    //  VCT finalFoot0Direction = R(newDirection, PI / 2, zAxis);
    //  angleToRotate = min(angle(currentBodyToFoot0, finalFoot0Direction), angularVelocity);
    //  print("Angle: " + angle(currentBodyToFoot0, finalFoot0Direction) + "\n");
      
    //  // Check whether to rotate clockwise or counter-clockwise
    //  if (!cw(zAxis, currentBodyToFoot0, finalFoot0Direction)) {
    //    angleToRotate = -angleToRotate;
    //  }
    //} else {
    //  VCT currentBodyToFoot1 = U(V(shadowOfCenterOfRingOfHips, feet[1]));
    //  // Final direction of hip0 after rotation completes
    //  VCT finalFoot1Direction = R(newDirection, PI / 2 + PI / 3, zAxis);
    //  angleToRotate = min(angle(currentBodyToFoot1, finalFoot1Direction), angularVelocity);
      
    //  // Check whether to rotate clockwise or counter-clockwise
    //  if (!cw(zAxis, currentBodyToFoot1, finalFoot1Direction)) {
    //    angleToRotate = -angleToRotate;
    //  }
    //}
    
    // TODO: something wrong with angleToRotate causing it to oscillate
    //currentBodyToFoot0 = R(currentBodyToFoot0, 0, zAxis);
    
    VCT bodyToHip0 = V(currentBodyToFoot0);
    bodyToHip0.z = 0;
    hips[0] = P(centerOfBody, V(radiusOfRingOfHips, U(bodyToHip0)));
    
    for (int i = 1; i < 6; i++) {
      hips[i] = R(hips[i - 1], PI / 3, xAxis, yAxis, centerOfBody);
    }
    
    int startIdx;
    
    float percentageDiffFromMiddle = abs(distSinceLastSwap / swapDistThreshold - 0.5);
    // Taking power of 2 to smooth it out
    float feetHeight = upFeetMaxHeight * (1 - pow(percentageDiffFromMiddle / 0.5, 2));
    
    if (evenFeetAreSupporting) {
      // Even indices stay the same; update odd indices
      startIdx = 3;
      VCT currentBodyToFoot1 = U(V(shadowOfCenterOfRingOfHips, feet[1]));
      VCT finalFoot1Direction = U(V(shadowOfCenterOfRingOfHips, hips[1]));
      finalFoot1Direction.z = 0;
      // !! angle() doesn't work; have to use angleAroundVertical somehow
      float angleToRotateFoot1 = min(angleAroundVertical(currentBodyToFoot1, finalFoot1Direction), angularVelocity);
      currentBodyToFoot1 = R(currentBodyToFoot1, angleToRotateFoot1, zAxis);
      
      feet[1] = P(shadowOfCenterOfRingOfHips, V(radiusOfRingOfFeet, U(currentBodyToFoot1)));
      feet[1].z = feetHeight;
    } else {
      // Odd indices stay the same; update even ones
      startIdx = 2;
      
      feet[0] = P(shadowOfCenterOfRingOfHips, V(radiusOfRingOfFeet, U(currentBodyToFoot0)));
      feet[0].z = feetHeight;
    }
    
    for (int i = startIdx; i < 6; i += 2) {
      feet[i] = R(feet[i-2], PI * 2 / 3, xAxis, yAxis, shadowOfCenterOfRingOfHips);
    }
  }

  void swapFeet() {
    distSinceLastSwap = 0;
    evenFeetAreSupporting = !evenFeetAreSupporting;
  }

  void display() {
    fill(brown);
    show(centerOfBody, radiusOfBody);
    for (int i = 0; i < 6; i++) {
      show(hips[i], radiusOfHips);
    }
    for (int i = 0; i < 6; i++) {
      caplet(centerOfBody, radiusOfBody, hips[i], radiusOfHips);
    }
    if (showBentLegs) {
      for (int i = 0; i < 6; i++) {
        showBentLeg(hips[i], feet[i], limbLength, radiusOfHips);
      }
    } else {
      for (int i = 0; i < 6; i++) {
        //if (i == 0) {
        //  fill(magenta);
        //} else if (i == 1) {
        //  fill(dgreen);
        //} else {
        //  fill(blue);
        //}
        caplet(hips[i], radiusOfHips, feet[i], radiusOfFeet);
      }
    }
    if (showControls) {
      fill(blue);
      show(target, 20);
      arrow(centerOfRingOfHips, target, 10);
      fill(magenta);
      show(shadowOfCenterOfRingOfHips, 20);
      arrow(shadowOfCenterOfRingOfHips, 400, forwardDirection, 10);
      fill(dgreen);
      show(centerOfRingOfDownFeet, 20);
      fill(red);
      show(centerOfRingOfUpFeet, 20);
    }
  }
  
  void showBentLeg(PNT A, PNT B, float l, float r) { 
    VCT vertical = upDirection;
    VCT straightLeg = V(A, B); // original leg
    VCT orth = U(N(straightLeg, vertical)).mul(l);
  
    // use limb length divided by 2 as hypotenuse; use straight leg length divided by 2 as one side
    // to compute knee direction as well as its length from original leg's mid length
    float lengthFromOriginalMidToKnee = sqrt( sq(l/2) - sq(straightLeg.norm()/2) );
    VCT kneeDir = U(N(orth, straightLeg)).mul(lengthFromOriginalMidToKnee);
    PNT kneePos = P( P(A,B), kneeDir);
  
    Boolean test = true;
    if(test) {
      // green vector normal to knee is cross product of red and blue
      // blue is from feet at ground to hip
      // red is orthogonal at midpoint from feet at ground
      fill(blue);
      arrow(A, B, 10);
      fill(yellow);
      arrow(A, vertical, 10);
      fill(red);
      arrow(P(A,B), orth, 10);
      fill(dgreen);
      arrow(P(A,B), kneePos, 10);
      
      fill(brown);
      arrow(A, kneePos, 10);
      arrow(kneePos, B, 10);
    } else {
      caplet(A, r, kneePos, radiusOfKnees);
      sphere(kneePos, radiusOfKnees);
      caplet(kneePos, radiusOfKnees, B, radiusOfFeet);
    }    
  }
} // end of BUG
