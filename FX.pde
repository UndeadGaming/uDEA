//Explosion animation frames
static String[][] fxData = new String[][] {
  
  /* 000 */ {"bubble_explo1", "/Assets/Bubble_Explo/bubble_explo1.png"},
  /* 001 */ {"bubble_explo2", "/Assets/Bubble_Explo/bubble_explo2.png"},
  /* 002 */ {"bubble_explo3", "/Assets/Bubble_Explo/bubble_explo3.png"},
  /* 003 */ {"bubble_explo4", "/Assets/Bubble_Explo/bubble_explo4.png"},
  /* 004 */ {"bubble_explo5", "/Assets/Bubble_Explo/bubble_explo5.png"},
  /* 005 */ {"bubble_explo6", "/Assets/Bubble_Explo/bubble_explo6.png"},
  /* 006 */ {"bubble_explo7", "/Assets/Bubble_Explo/bubble_explo7.png"},
  /* 007 */ {"bubble_explo8", "/Assets/Bubble_Explo/bubble_explo8.png"},
  /* 008 */ {"bubble_explo9", "/Assets/Bubble_Explo/bubble_explo9.png"},
  /* 009 */ {"bubble_explo10", "/Assets/Bubble_Explo/bubble_explo10.png"}
};

// Enemy death anim frames
static String[][] bloodData = new String[][] {
  /* 000 */ {"blood1", "/Assets/blood/blood1.png"},
  /* 001 */ {"blood2", "/Assets/blood/blood2.png"},
  /* 002 */ {"blood3", "/Assets/blood/blood3.png"},
  /* 003 */ {"blood4", "/Assets/blood/blood4.png"},
  /* 004 */ {"blood5", "/Assets/blood/blood5.png"},
  /* 005 */ {"blood6", "/Assets/blood/blood6.png"}
};

Sprite[] explosionSprites = new Sprite[10];
Sprite[] bloodSprites = new Sprite[6];

// Abstract contatining bloodspurts and explosion
abstract class FX extends GameObject {
  
  int currentFrame;
  int count;
  
  public FX (PVector locin) {
    loc = locin;
    currentFrame = 0;
  }
  
  abstract void update();
  
  abstract void display();
}



class Explosion extends FX {
  static final int numFrames = 10; //
  
  public Explosion (PVector locin) {
    super(locin);
    loadSprites();
  }
  void update () {
    if(count == 3){
      currentFrame++; // Iterate frames
      if(currentFrame == 9){
        currentFrame = 8;
      }
      count = 0;
    }
    
    count++; // Delay for frame update

    display();
  }
  
  // Associated sprites
  void loadSprites(){
    explosionSprites[0] = new Sprite(fxData[0][0],fxData[0][1]);
    explosionSprites[1] = new Sprite(fxData[1][0],fxData[1][1]);
    explosionSprites[2] = new Sprite(fxData[2][0],fxData[2][1]);
    explosionSprites[3] = new Sprite(fxData[3][0],fxData[3][1]);
    explosionSprites[4] = new Sprite(fxData[4][0],fxData[4][1]);
    explosionSprites[5] = new Sprite(fxData[5][0],fxData[5][1]);
    explosionSprites[6] = new Sprite(fxData[6][0],fxData[6][1]);
    explosionSprites[7] = new Sprite(fxData[7][0],fxData[7][1]);
    explosionSprites[8] = new Sprite(fxData[8][0],fxData[8][1]);
    explosionSprites[9] = new Sprite(fxData[9][0],fxData[9][1]);
  }
  
  void display () {
    
    // Modify the spawn location to ensure centralization
    float cornerX = loc.x - (lowestX * TILE_SIZE) - player.dx - 150 + (TILE_SIZE/2);
    float cornerY = loc.y + 150 + (TILE_SIZE/2);
    explosionSprites[currentFrame].display(cornerX, cornerY, cornerX + 300, cornerY - 300, 1);
  }

}

class BloodSplat extends FX {

  public BloodSplat (PVector locin){
    super(locin);
    loadSprites();
  }
  
  void update(){
    if(count == 2){
      currentFrame++; // Iterate frames
      if(currentFrame == 5){
        currentFrame = 5;
      }
      count = 0;
    }
    
  count++; // Delay for frame update
  
  display();
  }
  
  // Associated sprites
  void loadSprites(){
    bloodSprites[0] = new Sprite(bloodData[0][0],bloodData[0][1]);
    bloodSprites[1] = new Sprite(bloodData[1][0],bloodData[1][1]);
    bloodSprites[2] = new Sprite(bloodData[2][0],bloodData[2][1]);
    bloodSprites[3] = new Sprite(bloodData[3][0],bloodData[3][1]);
    bloodSprites[4] = new Sprite(bloodData[4][0],bloodData[4][1]);
    bloodSprites[5] = new Sprite(bloodData[5][0],bloodData[5][1]);
  }
  
  void display() {
    
    // Modify the spawn location to ensure centralization
    float cornerX = loc.x - (lowestX * TILE_SIZE) - player.dx - 150 + (TILE_SIZE/2);
    float cornerY = loc.y + 150 + (TILE_SIZE/2);
    
    // And display
    bloodSprites[currentFrame].display(cornerX, cornerY, cornerX + 300, cornerY - 300, 1);
  }
}