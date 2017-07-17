// ***Check EnemyFly for more detailed commenting

class EnemySlime extends DynamicGameObject implements Enemy {
  static final int eWidth = 51;  // The width of the player sprite
  static final int eHeight = 51; // The height of the player sprite
  int state;                     // Which state (walking, jumping, etc. the player is in)
  int orientation;               // Which direction the player is currently facing
  Sprite sprites;                //Sprite of the enemy
  static final float eSpeed = 8f;// The ememies's speed
  private int health;            // Enemy health level
  static final int footOffset = 4;// Offset to better approximate player foot position
  Player p;                       // Player reference for collision detection
  int radius = 25;                // Sprite Radius
  
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
  
  public EnemySlime (Player player, int xin, int yin) {
      super(new PVector(xin, yin), new PVector(0,0), eSpeed);
      p = player;
      orientation = -1;    // Set to face right
      state = 1;
      sprites = new Sprite(enemySpriteData[0][0], enemySpriteData[0][1]); // Set sprites
      isJumping = false;
      isGrounded = true;
      health = 25;
      centre = new PVector(loc.x + (eWidth/2), loc.y - (eHeight/2)); // The centre position of the enemy sprite
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
    if (isJumping) {
      jump();
    }
    
    // If the enemy touches the player, damage them
    if (touchingPlayer()) {
      p.updateHealth(-10);
    }
    
    centre = new PVector(loc.x + (eWidth/2), loc.y - (eHeight/2)); // Update sprite centre position
    
  }
  
  
  
  void display (int lowestX) {
    imageMode(CORNERS);
    
    if (frozen) {
      tint(0, 255, 255, 200);
    } else if (burned) {
      tint(255, 0, 0, 200); 
    }
    
    sprites.display(loc.x - (lowestX * TILE_SIZE) - player.dx, loc.y, loc.x - (lowestX * TILE_SIZE) - player.dx + eWidth, loc.y - eHeight, orientation);
    
    noTint();
  }
  
  void loadSprites(){
    sprites = new Sprite (enemySpriteData[0][0], enemySpriteData[0][1]);
  }
  
  void handleMovement () {
    int HMoveTo; // Where the enemy is attempting to go to horizontally
    int yBox1, yBox2; // Vertical collision boxes
    
    // Calculate the block the enemy is attempting to move to/into
    if (orientation == -1) {
      HMoveTo = ((int)(loc.x + 1))/TILE_SIZE;
      loc.x += -1;
    } else {
      HMoveTo = ((int)(loc.x + eWidth + 2))/TILE_SIZE;
      loc.x += 1;
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
  
  void flipOrientation () {
    orientation = orientation * -1; // If left, set right/if right, set left
  }
  
  void jump() {
    // Handle checks before jumping/continuing to jump
    if ((!isGrounded || jumpCounter == 0) && jumpCounter < 30 && loc.y != eHeight) {
       movement.y = -1;
       jumpCounter++;
    } else {
       // End jumping, begin falling
       jumpCounter = 0;
       isJumping = false;
       isFalling = true;
    }
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