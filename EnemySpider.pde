// ***Check EnemyFly for more detailed commenting

class EnemySpider extends DynamicGameObject implements Enemy {
  static final int eWidth = 77;  // The width of the player sprite
  static final int eHeight = 53; // The height of the player sprite
  int state;                     // Which state (walking, jumping, etc. the player is in)
  int orientation;               // Which direction the player is currently facing
  Sprite[] sprites = new Sprite[3];                //Sprite of the enemy
  static final float eSpeed = 10f;// The ememies's speed
  private int health;            // Enemy health level
  static final int footOffset = 4;// Offset to better approximate player foot position
  Player p;                       // Player reference for collision detection
  int radius = 25;                // Sprite Radius
  int frame;
  int count;
  int random;
  
  int freezeStart;
  boolean frozen;
  static final int freezeDuration = 3000;
  
  int burnStart;
  boolean burned;
  static final int burnDuration = 400;
  
  int getWidth () {
    return eWidth;
  }
  
  PVector getCentre () {
    return centre;
  }
  
  public EnemySpider (Player player, int xin, int yin) {
      super(new PVector(xin, yin), new PVector(0,0), eSpeed);
      p = player;
      random = int(random(1,10));
      if(random%2 == 0){
      orientation = -1;    // Set to face right
      }
      else{
      orientation = 1;
      }
      
      state = 1;
      loadSprites();
      isJumping = false;
      isGrounded = true;
      health = 45;
      centre = new PVector(loc.x + (eWidth/2), loc.y - (eHeight/2)); // The centre position of the enemy sprite
      int count = 0;
      int frame = 0;
  }
  
  void update(int lowestX){
    
    if (frozen && millis() - freezeStart > freezeDuration) {
       frozen = false;
    }
        
    if (burned && millis() - burnStart > burnDuration) {
      burned = false;
    }
    
    checkExplosion();
    
    if (!frozen) {
      handleMovement(); // Check collisions and add movement
    } 

    display(lowestX);
    isGrounded = checkGrounded();
    
    if (isGrounded) {
      isFalling = false; 
    }
    
    // If the enemy touches the player, damage them
    if (touchingPlayer()) {
      p.updateHealth(-10);
    }
    
    centre = new PVector(loc.x + (eWidth/2), loc.y - (eHeight/2)); // Update sprite centre position
    
  }
  
  
  
  void display (int lowestX) {
    imageMode(CORNERS);
    if(count >=2){
      frame++;
      if(frame >=3){
        frame = 0;
      }
      count = 0;
    }
    
    if (frozen) {
      tint(0, 255, 255, 200);
    } else if (burned) {
      tint(255, 0, 0, 200); 
    }
    
    sprites[frame].display(loc.x - (lowestX * TILE_SIZE) - player.dx, loc.y, loc.x - (lowestX * TILE_SIZE) - player.dx + eWidth, loc.y - eHeight, orientation*-1);
    
    if (!frozen) {
      count++;
    }
    
    noTint();
  }
  
  void loadSprites(){
    sprites[0] = new Sprite (enemySpriteData[3][0], enemySpriteData[3][1]);
    sprites[1] = new Sprite (enemySpriteData[4][0], enemySpriteData[4][1]);
    sprites[2] = new Sprite (enemySpriteData[5][0], enemySpriteData[5][1]);
  }
  
  void handleMovement () {
    int HMoveTo; // Where the enemy is attempting to go to horizontally
    int yBox1, yBox2; // Vertical collision boxes
    
    // Calculate the block the enemy is attempting to move to/into
    if (orientation == -1) {
      HMoveTo = ((int)(loc.x + 1))/TILE_SIZE;
      loc.x += -5;
    } else {
      HMoveTo = ((int)(loc.x + eWidth + 2))/TILE_SIZE;
      loc.x += 5;
    }
    
    // Generate collision boxes
    yBox1 = (int((loc.y-1)/TILE_SIZE));
    yBox2 = int((loc.y - TILE_SIZE)/TILE_SIZE) - 1;
    
    // Reset collision boxes as necessary  
    if (!isJumping && !isFalling) {
      if (yBox1 - yBox2 > 1) {
         yBox1--;
      }
    }
    
    // Constrain the upper box as to not exceed the screen
    yBox2 = constrain(yBox2, 0, 10);
    
    if (mapData[yBox1][HMoveTo] != 0 || mapData[yBox2][HMoveTo] != 0) { // Check if a block exists at that location
       loc.add(new PVector (0, movement.y * speed)); // Prevent horizontal movement as necessary
       flipOrientation();
    } else {
       loc.add(movement.mult(speed)); // Else move normally
    }
  }
  
  boolean checkGrounded () {
          // Check if a block exists immediately under any spot on or bewtween the player's feet
    for (int i = footOffset; i < eWidth - footOffset; i++) {
      if (mapData[ceil(player.loc.y)/TILE_SIZE][floor(player.loc.x + i)/TILE_SIZE] != 0) { 
        return true;
      }
    }
    return false;
  }
  
  // Constrain the player to the edge of the screen
  void checkEdges () {
    
    //PVector tempMove = movement;
    
    if (loc.x + eWidth > width) {
      loc.x = width - eWidth; 
      flipOrientation();
    } else if (loc.x < 0) {
      loc.x = 0;
      //flipOrientation();
    } 
    
    if (loc.y > height) {
      loc.y = height; 
    } else if (loc.y - eHeight < 0) {
      loc.y = eHeight; 
    }
  }
  
  void flipOrientation () {
    orientation = orientation * -1; // If left, set right/if right, set left
  }
  
  
  // Used to determine if the player is in range of the gameObject
  boolean touchingPlayer () {    
    if (sq(player.centre.x - centre.x) + sq(player.centre.y - centre.y) <= sq(radius)) {
      return true;
    }
    return false;
  }
  
  void updateHealth (int damIn) {
    health -= damIn; 
  }
  
  int getHealth () {
    return health;
  }
  
  void stopMovement () {
    frozen = true;
    freezeStart = millis(); 
    
  }
  
  void hurt () {
    burned = true;
    burnStart = millis();
  }
  
  
  float getLocX(){
    return loc.x;
  }
  
  float getLocY(){
    return loc.y;
  }
  
  void checkExplosion(){                          
    for(int i = 0; i <explosions.size(); i++){
      println(dist(explosions.get(i).loc.x,explosions.get(i).loc.y,loc.x,loc.y));
     
      if(dist(explosions.get(i).loc.x,explosions.get(i).loc.y,loc.x,loc.y) <= 170){
        health = 0;
        println(dist(explosions.get(i).loc.x,explosions.get(i).loc.y,loc.x,loc.y) <= 50);
      }
      
    }
  }
}