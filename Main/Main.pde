// 6491-2020-P4 
// Base-code: Jarek ROSSIGNAC
// Student 1: ??? ????
// Student 2: ??? ????
import processing.pdf.*;    // to save screen shots as PDFs, does not always work: accuracy problems, stops drawing or messes up some curves !!!
import java.awt.Toolkit;
import java.awt.datatransfer.*;
//  ******************* Basecode for P2 ***********************
Boolean 
  animating=false, 
  tracking=true,
  PickedFocus=false, 
  showBentLegs=false,
  showControls=true,
  center=false;

float t=-1;
  
void settings() {
  // Fixes "Profile GL4bc not available" error on my computer
  System.setProperty("jogl.disable.openglcore", "true");
  size(1200, 1200, P3D); // P3D means that we will do 3D graphics
  //size(800, 800, P3D); // P3D means that we will do 3D graphics
}
  
void setup() {
  myFace = loadImage("data/pic.jpg");  // load image from file pic.jpg in folder data *** replace that file with your pic of your own face
  textureMode(NORMAL);          
  noSmooth();
  frameRate(30);
    
  Bug.declare(); 
  Bug.reset(); 
  Bug.updateConfiguration(); 
  
  _LookAtPt.reset(Bug.CenterOfRingOfDownFeet,10);
  }

void draw() {
  background(255);
  hint(ENABLE_DEPTH_TEST); 
  pushMatrix();   // to ensure that we can restore the standard view before writing on the canvas
  setView();  // see pick tab
  showFloor(); // draws dance floor as yellow mat
  doPick(); // sets Of and axes for 3D GUI (see pick Tab)

 
  if(mousePressed&&keyPressed&&(key=='m'||key=='r'||key=='t')) // when mouse is pressed (but no key), show red ball at surface point under the mouse (and its shadow)
     {
     Target = L(Target,0.01,Of);
     if(key=='m') Bug.moveTowardsTarget(Target); 
     Bug.updateConfiguration(); 
     }
 
  Bug.display(); 
   
  popMatrix(); // done with 3D drawing. Restore front view for writing text on canvas
  hint(DISABLE_DEPTH_TEST); // no z-buffer test to ensure that help text is visible
  scribeHeader("dz="+dz+", "+"angle="+nf(Bug.rotationAngle*180/PI,1,0),1);

  // used for demos to show red circle when mouse/key is pressed and what key (disk may be hidden by the 3D model)
  if(mousePressed) {stroke(cyan); strokeWeight(3); noFill(); ellipse(mouseX,mouseY,20,20); strokeWeight(1);}
  if(keyPressed) {stroke(red); fill(white); ellipse(mouseX+14,mouseY+20,26,26); fill(red); text(key,mouseX-5+14,mouseY+4+20); strokeWeight(1); }
  if(scribeText) {fill(black); displayHeader();} // dispalys header on canvas, including my face
  if(scribeText && !filming) displayFooter(); // shows menu at bottom, only if not filming
  if(filming && (animating || change)) saveFrame("FRAMES/F"+nf(frameCounter++,4)+".tif");  // save next frame to make a movie
  change=false; // to avoid capturing frames when nothing happens (change is set uppn action)
  change=true;
  }
