VCT UpDirection = V(0,0,1);
PNT Target = P(800,0,0);
BUG Bug = new BUG();
class BUG // class for manipulaitng a bug
  // BUG is degined by a ring of hips, a ring of down-feet and a ring of up-feet
  {
    
  // STUDENTS: FEEL FREE TO CHANGE THE VARIABLES AND METHODS BELOW
  
  
  // ***** FIXED PARAMETERS *****
  float heightOfRingOfHips=100; // height of ring of hips
  float radiusOfRingOfHips=60; // radius of ring of hips
  float radiusOfHips=20; // hip ball radius

  // body sphere
  float bodyElevartionAboveRingOfHips=5; //20
  float radiusOfBody=60; // 50
  
  // knees
  float radiusOfKnees=15; // knee ball radius

  // feet
  float radiusOfRingOfFeet=300; // radius of ring of hips
  float radiusOfFeet=10; 
  float upFeetMaxHeight=0;    // !! change and control

  // legs
  float limbLength=200;
  
  // motion
  float stepLength=3;  // controls translation speed towards Target

  // ***** CONTROL PARAMETERS *****
  VCT ForwardDirection=V(); // where the bug is facing
  PNT ShadowOfCenterOfRingOfHips=P(); // floor projection of the center of the body of the bug
  PNT CenterOfRingOfDownFeet=P(); // remembers the floor projection of the centtoid of the 3 support feet
  float rotationAngle=0;
  boolean evenFeetAreSupporting=true; // used to toggle which are the fixed (support) feet
  
  // ***** COMPUTED PARAMETERS *****
  PNT CenterOfRingOfHips=P();
  PNT CenterOfBody=P();
  PNT ShadowOfCenterOfRingOfUpFeet=P();
  PNT CenterOfRingOfUpFeet=P();
  PNT[] Hip = new PNT[6]; 
  PNT[] Foot = new PNT[6]; 
    
  BUG() {}

  void declare() 
    {
    for (int i=0; i<6; i++) Hip[i]=P();
    for (int i=0; i<6; i++) Foot[i]=P();
    }     
  
  void reset() 
    {
    ShadowOfCenterOfRingOfHips=P();
    CenterOfRingOfDownFeet=P();
    ForwardDirection=V(1,0,0);
    rotationAngle=0;
    }     
  
  void moveTowardsTarget(PNT Target) 
    {
    //**REMOVE**
    float d=d(ShadowOfCenterOfRingOfHips,Target); // distace to Target
    VCT NewDirection=U(V(ShadowOfCenterOfRingOfHips,Target));
    //.....
    }     
  
   void updateConfiguration() 
    {
    CenterOfBody=P(ShadowOfCenterOfRingOfHips,heightOfRingOfHips+bodyElevartionAboveRingOfHips,UpDirection);
    //.....
    }     

  void swapFeet() 
    {
    //.....
    }

  void display() 
    {
    fill(brown); 
    show(CenterOfBody,radiusOfBody);
    //.....
    for (int i=0; i<6; i++) show(Hip[i],radiusOfHips);
    for (int i=0; i<6; i++) caplet(CenterOfBody,radiusOfBody,Hip[i],radiusOfHips);
    if(showBentLegs) for (int i=0; i<6; i++) {showBentLeg(Hip[i],Foot[i],limbLength,radiusOfHips);}
    else for (int i=0; i<6; i++) {caplet(Hip[i],radiusOfHips,Foot[i],radiusOfFeet);}
    if(showControls)
      {
      fill(blue); show(Target,20); arrow(CenterOfRingOfHips,Target,10);
      fill(magenta); show(ShadowOfCenterOfRingOfHips,20); arrow(ShadowOfCenterOfRingOfHips,400,ForwardDirection,10);
      fill(dgreen); show(CenterOfRingOfDownFeet,20);
      fill(red);    show(CenterOfRingOfUpFeet,20);
      }
    }     

  } // end of BUG



void showBentLeg(PNT A, PNT B, float l, float r) 
  {
  //.....
  }  
  
