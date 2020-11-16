// 6491-2020-P4 
// Base-code: Jarek ROSSIGNAC
// Student 1: Chen Liu
// Student 2: Thong Nguyen
import processing.pdf.*; // to save screen shots as PDFs, does not always work: accuracy problems, stops drawing or messes up some curves !!!
import java.awt.Toolkit;
import java.awt.datatransfer.*;
//  ******************* Basecode for P2 ***********************
Boolean
  animating = false, 
  tracking = true, 
  PickedFocus = false, 
  showBentLegs = false, 
  showControls = true, 
  center = false;

float t = -1;

void settings() {
  // Fixes "Profile GL4bc not available" error on my computer
  System.setProperty("jogl.disable.openglcore", "true");
  size(1200, 1200, P3D); // P3D means that we will do 3D graphics
  //size(800, 800, P3D); // P3D means that we will do 3D graphics
}

int n = 3;
BUG[] bugs;
BUG bug;
void setup() {
  myFace = loadImage("data/pic.jpg"); // load image from file pic.jpg in folder data *** replace that file with your pic of your own face
  textureMode(NORMAL);
  noSmooth();
  frameRate(30);
  
  
  bugs = new BUG[n];
  for (int i = 0; i < n; i++){
    System.out.println(n);
    BUG b = new BUG();
    bugs[i] = b;
    b.reset();
    if (i != 0) {
      b.shadowOfCenterOfRingOfHips = P(b.shadowOfCenterOfRingOfHips.x + 800*i, b.shadowOfCenterOfRingOfHips.y + 800*i, b.shadowOfCenterOfRingOfHips.z); // floor projection of the center of the body of the bug
      b.centerOfRingOfDownFeet = P(b.centerOfRingOfDownFeet.x + 800*i, b.centerOfRingOfDownFeet.y + 800*i, b.centerOfRingOfDownFeet.z); // remembers the floor projection of the centtoid of the 3 support feet
      b.centerOfBody = P(b.centerOfBody.x + 800*i, b.centerOfBody.y + 800*i, b.centerOfBody.z); 
      b.centerOfRingOfHips = P(b.centerOfRingOfHips.x + 800*i, b.centerOfRingOfHips.y + 800*i, b.centerOfRingOfHips.z); 
      b.shadowOfCenterOfRingOfUpFeet = P(b.shadowOfCenterOfRingOfUpFeet.x + 800*i, b.shadowOfCenterOfRingOfUpFeet.y + 800*i, b.shadowOfCenterOfRingOfUpFeet.z); 
      b.centerOfRingOfUpFeet = P(b.centerOfRingOfUpFeet.x + 800*i, b.centerOfRingOfUpFeet.y + 800*i, b.centerOfRingOfUpFeet.z);
      b.target = bugs[i-1].shadowOfCenterOfRingOfHips;
    }
   
    b.declare();
    b.updateConfiguration();
    
    _LookAtPt.reset(b.centerOfRingOfDownFeet, 10);
  }
}

void draw() {
  background(255);
  hint(ENABLE_DEPTH_TEST);
  pushMatrix(); // to ensure that we can restore the standard view before writing on the canvas
  setView(); // see pick tab
  showFloor(); // draws dance floor as yellow mat
  doPick(); // sets Of and axes for 3D GUI (see pick Tab)

  if (keyPressed) {
    if (key == ',' || key == '.') {
      if (key == ',' && n > 1) {
        n = n-1;
        setup();
      } else if (key == '.' && n < 5){
        n = n+1;
        setup();
      }
    }
  }

  for (int i = 0; i < n; i++){
    BUG b = bugs[i];
    
    
    if (mousePressed && keyPressed && (key == 'm' || key == 'r' || key == 't')) // when mouse is pressed (but no key), show red ball at surface point under the mouse (and its shadow)
    {
      if (i > 0) {
        float keepDistance = 800;
        VCT targetVct = V(b.shadowOfCenterOfRingOfHips, bugs[i-1].shadowOfCenterOfRingOfHips);
        float currentDistance = targetVct.norm();
        float validDistance = currentDistance - keepDistance;
        targetVct = U(targetVct).mul(validDistance);
        PNT targetPoint = P(b.shadowOfCenterOfRingOfHips, targetVct);
        
        b.target = L(targetPoint, 0.01, Of);
        if (key == 'm') b.moveTowardsTarget(b.target);
        b.updateConfiguration();
      } else {
        b.target = L(b.target, 0.01, Of);
        if (key == 'm') b.moveTowardsTarget(b.target);
        b.updateConfiguration(); 
      }
    }
    b.display();
  }
  

  popMatrix(); // done with 3D drawing. Restore front view for writing text on canvas
  hint(DISABLE_DEPTH_TEST); // no z-buffer test to ensure that help text is visible
  if (bug != null) scribeHeader("dz=" + dz + ", " + "angle=" + nf(bug.rotationAngle * 180 / PI, 1, 0), 1);

  // used for demos to show red circle when mouse/key is pressed and what key (disk may be hidden by the 3D model)
  if (mousePressed) {
    stroke(cyan);
    strokeWeight(3);
    noFill();
    ellipse(mouseX, mouseY, 20, 20);
    strokeWeight(1);
  }
  if (keyPressed) {
    stroke(red);
    fill(white);
    ellipse(mouseX + 14, mouseY + 20, 26, 26);
    fill(red);
    text(key, mouseX - 5 + 14, mouseY + 4 + 20);
    strokeWeight(1);
  }
  if (scribeText) {
    fill(black);
    displayHeader();
  } // dispalys header on canvas, including my face
  if (scribeText && !filming) displayFooter(); // shows menu at bottom, only if not filming
  if (filming && (animating || change)) saveFrame("FRAMES/F" + nf(frameCounter++, 4) + ".tif"); // save next frame to make a movie
  change = false; // to avoid capturing frames when nothing happens (change is set uppn action)
  change = true;
}
