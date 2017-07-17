
int alpha = 255;  // alpha value on the given frame
int messageDir = 1;  // whether the alpha value is increasing (+) or decreasing (-)
PFont font; // Import a font for use
public static int textSpeed = 4; // the rate at which the text changes alpha

void titleScreen() {
  
  background(255);
  
  // Draw menu components
  drawTitleBG();
  drawTitle();
  drawEnterButton();  
}

// The title image (backdrop)
void drawTitleBG() {
  pushMatrix();
  scale(0.7); // Scale the title image
  image(bgSprites[0].sprite, -250, 0);
  popMatrix();
}

// The title text
void drawTitle(){
   textSize(50);
   fill(200,0,0);
   textAlign(CENTER);
   text("uDEA", width/2 , 100);
}

// The "Press Enter" indicator
void drawEnterButton(){
  
  // Account for out of bounds values and flip whether 
  //   the text alpha is increasing or decreasing
  if (alpha >= 255){
    alpha = 255;
    messageDir = -1;
  } else if (alpha <= 35) {
    alpha = 50;
    messageDir = 1;
  }
  
  textSize(20);
  fill(255, 255, 255, alpha);
  textAlign(CENTER);
  text("PRESS ENTER", width/2, 650);
  alpha += textSpeed * messageDir; // Change shade
}

// Data for background image
static String[][] bgData = new String[][] {
  // Background //
  /* 000 */ {"Title", "/data/Title.png"}
};

// Function for post-title narrative breif
void narrative() {
  background(0);
  textAlign(CENTER);
  textSize(25);
  fill(200, 0, 0);
  text(narrativeText, width/2, 200);
}

// Text for the narrative
static String narrativeText = 
"Welcome to uDEA." + "\n" +
"You are king of all that you surveil, the land of uDEA. Many years of brutal wars has" + "\n" +
"begun to drive you insane. You begin by sacrificing your sons in the name of your god"+ "\n" +
"and you start practicing dark magic. Now, your powers are coming into fruition and your" + "\n" +
"thirst for blood becomes stronger everyday. " + 
"Go forth, my king, and" + "\n" + 
"SLAUGHTER" + "\n\n" +
"Press Shift to begin your rampage...";