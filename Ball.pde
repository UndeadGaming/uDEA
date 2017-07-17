// Class to handle "Power Balls"
class Ball extends DynamicGameObject {
  
  float diameter = 10;
  static final float ballSpeed = 12;
  static final float cooldown = 600; // Cooldown time before being able to fire
  float spawnTime; // Time when the instance is spawned
  int orientation; // Which direction the player was facing upon fire
  float spawnX; // The horizontal coordinate on spawn
  static final int damage = 10; // The base damage dealt to enemies on hit
  boolean collided, collidedEnemy; // Booleans for deleting balls and calling enemy functions
  byte type; // Fire or Ice ball
  
  public Ball (PVector locin, int orientationIn, byte typeIn) {
    super(locin, new PVector(0,0), ballSpeed); // Call to the superclass
    orientation = orientationIn; // Which direction the ball should shoot
    loc.x -= 1;
    spawnTime = time.time; // Time the ball was instantiated at
    spawnX = locin.x;
    collided = collidedEnemy = false;
    type = typeIn;
  }
  
  void update() {
    
    // Location of the ball relative to its spawn point.
    // Used in favor of other methods to ensure screen independence.
    loc.x = spawnX + (abs(loc.x - spawnX) + speed) *  orientation;
    
    // Check if hitting enemy
    Enemy enemy = touchingEnemy();
    if (enemy != null && !collidedEnemy) {
      collidedEnemy = true;
      if (type == FIRE_POWER) {
        player.addBloodthirst(20); // Add to the bloodthirst metre on hit
        if (player.isBloodthirsted) {
          enemy.updateHealth(damage * 2); // Double damage if bloodthirsted
        } else {
          enemy.updateHealth(damage); 
        }
        enemy.hurt();
      } else if (type == ICE_POWER) {
        enemy.stopMovement(); // Freeze enemy
        playIce();            // Play freezing sound
      }
    } else {
      display();      // Use the specific draw function for this class
    }
    
    // Find the tile type that ball exists on
    int[] tileRef = new int [] {floor(loc.y/TILE_SIZE), floor(loc.x/TILE_SIZE)};
    int tile = mapData[tileRef[0]][tileRef[1]];
    
    if (tile != 0) {
      if (tile == 28 && type == FIRE_POWER) { // If the tile is an explosive barrel
        PVector tileLoc = new PVector(tileRef[1] * TILE_SIZE, tileRef[0] * TILE_SIZE);
        
        playExplosion(); // Explosion sound
        
        explosions.add(new Explosion(tileLoc)); // Spawn explosion on the tile

        mapData[tileRef[0]][tileRef[1]] = 0; // Remove the barrel
         
      } else if(tile == 37 && type == FIRE_POWER){
        mapData[tileRef[0]][tileRef[1]] = 0; // Remove the ice block
        playIce();

      }
      collided = true; 
    }
  }
  
  void display () {
    strokeWeight(1);
    stroke(0);
    
    // Draw fire/ice separate colours
    switch (type) {
      case (FIRE_POWER): fill(255, 0, 0); break;
      case (ICE_POWER) : fill(0, 255, 255); break;
    }
    ellipse(loc.x - (lowestX * TILE_SIZE) - player.dx, loc.y, diameter, diameter);
  }
  
  Enemy touchingEnemy () { 
    for (Enemy enemy : enemies) {
      if ( sq(enemy.getCentre().x - loc.x) + sq(enemy.getCentre().y - loc.y) <= sq(enemy.getWidth()/2) ) { // Hit detection
        return enemy;
      }
    }
    return null;
  }
}