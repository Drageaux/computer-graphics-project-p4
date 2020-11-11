// ************************************ IMAGES & VIDEO 
int pictureCounter=0, frameCounter=0;
Boolean filming=false, change=false;
PImage myFace; // picture of author's face, should be: data/pic.jpg in sketch folder
void snapPicture() {
  saveFrame("PICTURES/P"+nf(pictureCounter++, 3)+".jpg");
}

// ******************************************COLORS 
color black=#000000, white=#FFFFFF, // set more colors using Menu >  Tools > Color Selector
  red=#FF0000, green=#00FF01, blue=#0300FF, yellow=#FEFF00, cyan=#00FDFF, magenta=#FF00FB, 
  grey=#818181, orange=#FFA600, brown=#B46005, metal=#B5CCDE, 
  lime=#A4FA83, pink=#FCC4FA, dgreen=#057103, 
  lightWood=#F5DEA6, darkWood=#D8BE7A, 
  gold=#CEB466, aqua=#66CE81, slate=#667FCE, orchid=#CE66B3;
void pen(color c, float w) {
  stroke(c); 
  strokeWeight(w);
}

// ******************************** TEXT , TITLE, and USER's GUIDE
Boolean scribeText=true; // toggle for displaying of help text
void scribe(String S, float x, float y) {
  fill(0); 
  text(S, x, y); 
  noFill();
} // writes on screen at (x,y) with current fill color
void scribeHeader(String S, int i) {
  fill(0); 
  text(S, 10, 20+i*20); 
  noFill();
} // writes black at line i
void scribeHeaderRight(String S) {
  fill(0); 
  text(S, width-7.5*S.length(), 20); 
  noFill();
} // writes black on screen top, right-aligned
void scribeFooter(String S, int i) {
  fill(0); 
  text(S, 10, height-10-i*20); 
  noFill();
} // writes black on screen at line i from bottom
void scribeAtMouse(String S) {
  fill(0); 
  text(S, mouseX, mouseY); 
  noFill();
} // writes on screen near mouse
void scribeMouseCoordinates() {
  fill(black); 
  text("("+mouseX+","+mouseY+")", mouseX+7, mouseY+25); 
  noFill();
}



FIFO _LookAtPt = new FIFO();

class FIFO // class for filtering camera motion
{   
  int n=0, maxn=200;
  PNT [] C = new PNT[maxn];

  FIFO() 
  {
    n=1;
    C[0]=P();
  }

  void reset(PNT A, int k) 
  {
    n=k;
    for (int i=0; i<n; i++) C[i]=P(A);
  }

  PNT move(PNT B) 
  {
    C[0]=P(B, C[0]);
    for (int i=1; i<n; i++) C[i]=P(C[i-1], C[i]);
    return C[n-1];
  }
}

// ************************** Clipboard utilities **************************

public static String getClipboard() {   // returns content of clipboard (if it contains text) or null
  Transferable t = Toolkit.getDefaultToolkit().getSystemClipboard().getContents(null);
  try {
    if (t != null && t.isDataFlavorSupported(DataFlavor.stringFlavor)) {
      String text = (String)t.getTransferData(DataFlavor.stringFlavor);
      return text;
    }
  } 
  catch (UnsupportedFlavorException e) {
  } 
  catch (IOException e) {
  }
  return null;
}
public static void setClipboard(String str) { // This method writes a string to the system clipboard.
  StringSelection ss = new StringSelection(str);
  Toolkit.getDefaultToolkit().getSystemClipboard().setContents(ss, null);
}
