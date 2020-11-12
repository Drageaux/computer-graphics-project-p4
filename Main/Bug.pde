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
  float upFeetMaxHeight = 0; // !! change and control

  // legs
  float limbLength = 200;

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
  
  float velocity = 2.0;
  float distSinceLastSwap = 0; // Distance traveled since last time feet are swapped
  float swapDistThreshold = 40; // Threshold of distSinceLastSwap to swap feet

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
    
    VCT xAxis = V(1, 0, 0);
    VCT yAxis = V(0, 1, 0);
    PNT ringOfHipsCenter = P(centerOfBody.x, centerOfBody.y, heightOfRingOfHips);
    
    VCT hip0Direction = V(radiusOfRingOfHips, U(R(newDirection)));
    
    hips[0] = P(centerOfBody, hip0Direction);
    
    for (int i = 1; i < 6; i++) {
      hips[i] = R(hips[i - 1], PI / 3, xAxis, yAxis, ringOfHipsCenter);
    }
    
    int startIdx;
    PNT ringOfFeetCenter = P(centerOfBody.x, centerOfBody.y, 0);
    VCT foot0Direction = V(radiusOfRingOfFeet, U(R(newDirection)));
    
    PNT foot0Point = P(shadowOfCenterOfRingOfHips, foot0Direction);
    
    if (evenFeetAreSupporting) {
      // Even indices stay the same; update odd indices
      startIdx = 3;
      feet[1] = R(foot0Point, PI / 3, xAxis, yAxis, ringOfFeetCenter);
    } else {
      // Odd indices stay the same; update even ones
      startIdx = 2;
      feet[0] = foot0Point;
    }
    
    for (int i = startIdx; i < 6; i += 2) {
      feet[i] = R(feet[i - 2], PI * 2 / 3, xAxis, yAxis, ringOfFeetCenter);
    }
  }

  void swapFeet() {
    distSinceLastSwap = 0;
    evenFeetAreSupporting = !evenFeetAreSupporting;
    print("Swapping\n");
  }

  void display() {
    fill(brown);
    show(centerOfBody, radiusOfBody);
    //.....
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
} // end of BUG



void showBentLeg(PNT A, PNT B, float l, float r) {
  //.....
}
