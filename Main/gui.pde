void keyPressed() 
  {
  if(key=='!') snapPicture();
  if(key=='~') filming=!filming;
  if(key=='?') scribeText=!scribeText;
  if(key=='b') showBentLegs=!showBentLegs;
  if(key=='x') {Bug.swapFeet(); Bug.updateConfiguration();}
  if(key=='C') showControls=!showControls;
  if(key=='a') {animating=!animating; }// toggle animation
  if(key=='z') {Bug.reset(); Bug.updateConfiguration();}
  change=true;   // to save a frame for the movie when user pressed a key 
  }

void mouseWheel(MouseEvent event) 
  {
  dz -= event.getAmount() * 60; 
  change=true;
  }

void mousePressed() 
  {
  change=true;
  }
  
void mouseMoved() 
  {
  //if (!keyPressed) 
  if (keyPressed && key==' ') {rx-=PI*(mouseY-pmouseY)/height; ry+=PI*(mouseX-pmouseX)/width;};
  if (keyPressed && key=='`') dz+=(float)(mouseY-pmouseY); // approach view (same as wheel)
  if (keyPressed && key=='.') t+=(float)(mouseX-pmouseX)/width; // change time
  change=true;
  }
  
void mouseDragged() 
  {
  if (keyPressed && key=='f')  // move focus point on plane
    {
    if(center) F.sub(ToIJ(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0))); 
    else F.add(ToIJ(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0))); 
    }
  if (keyPressed && key=='F')  // move focus point vertically
    {
    if(center) F.sub(ToK(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0))); 
    else F.add(ToK(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0))); 
    }
  change=true;
  }  

// **** Header, footer, help text on canvas
void displayHeader()  // Displays title and authors face on screen
    {
    scribeHeader(title,0); scribeHeaderRight(name); 
    fill(white); image(myFace, width-myFace.width/2,25,myFace.width/2,myFace.height/2); 
    }
void displayFooter()  // Displays help text at the bottom
    {
    scribeFooter(guide,1); 
    scribeFooter(menu,0); 
    }

String title ="CS6491-2020-P4: Bug", name ="Student ONE, Student TWO", // STUDENT: PUT YOUR NAMES HERE !!!
       menu="?:help, !:picture, ~:(start/stop)filming, space:rotate, `/wheel:closer, f/F:focus, v:tracking, </>:slower/faster",
       guide="Hold m and press&drag mouse:to move, b:bend legs, z:reset, C:show controls, a:animation"; // user's guide
