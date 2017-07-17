// Handles position vector
abstract class GameObject {
  PVector loc;
  PVector centre;
}

// Gameobjects that will not move
abstract class StaticGameObject extends GameObject {
  float radius;
  Sprite sprite;

  public StaticGameObject (PVector locin, float radin) {
    loc = locin;
    radius = radin; 
  }
}


// Game objects that will move
abstract class DynamicGameObject extends GameObject {
  
  // Handle vertical movement
  boolean isGrounded;
  boolean isJumping;
  boolean isFalling;
  int jumpCounter; // Number of frames since jump began
  
  // Handle additional movement
  PVector movement;
  final float speed;
  
  
  public DynamicGameObject (PVector locin, PVector movein, float velin) {
    isGrounded = true;
    isJumping = false;
    isFalling = false;
    movement = movein;
    loc = locin;
    speed = velin;
    jumpCounter = 0;
  }
  
  public void update () {
    // Add the movement to the position vector
    loc.add(movement.mult(speed));
  }
}


// Objects that can be picked up by the player
abstract class Pickup extends StaticGameObject {
  
  public Pickup (PVector locin, float radin) {
    super(locin, radin);
    centre = new PVector (loc.x + radin, loc.y + radin);
  }
  
  // Used to determine if the player is in range of the gameObject
  boolean touchingPlayer () {    
    if (sq(player.centre.x - centre.x) + sq(player.centre.y - centre.y) <= sq(radius)) { // Distance calculation
      return true;
    }
    return false;
  }
  
  // Used for handling pickup events
  abstract void onPickup ();
  
  abstract void display(int lowestX);
}

class Coin extends Pickup {
  
  Sprite sprite = gameObjectSprites[0];
  static final int defaultRad = 34; // The radius of the coin graphic
  
  
  // Two instance methods for specific purposes
  public Coin (PVector locin, float radin) {
    super(locin, radin);
    sprite = gameObjectSprites[0];
  }
  
  public Coin (PVector locin) {
    super(locin, defaultRad);
    sprite = gameObjectSprites[0];
  }
  
  // Handle when a coin is pickup up
  void onPickup () {
    playCoin();
    gameState.numCoins++;
  }
  
  // Display the coin by offsetting using the lowest on screen x-value and the player's distance from their closest (left) column line
  void display(int lowestX) {
    gameObjectSprites[0].display(loc.x - (lowestX * TILE_SIZE) - player.dx, loc.y);
  }
}

// Function to account for multiple subclasses existing in the gameObject array
public Pickup getObjectType(int input, PVector locin) {
  switch (input) {
     case 1: return new Coin(locin);
  }
  return null;
}

// Small powerball contained in the player's hand.
//   Also used in determining the starting location for fired balls
class Orb extends GameObject {
  
  float diameter = 10;
  
  void update (PVector pPos, int pDir/*, int pState*/) {
    loc = new PVector();
    
    // Modify draw location for more accurate representation
    if (pDir == 1) { 
      loc.x = pPos.x + 65;
    } else {
      loc.x = pPos.x - 6;
    }
    loc.y = pPos.y-20;
    
    display(pPos, pDir);
  }
  
  void display (PVector pPos, int pDir) {
    ellipseMode(CENTER);
    stroke(0);
    strokeWeight(1);
    
    // Orb changes with currently equiped power
    switch (player.getCurrentPower()) {
      case (FIRE_POWER): fill(255, 0, 0); break;
      case (ICE_POWER) : fill(0, 255, 255); break;
    }
    
    // Draw
    ellipse(player.screenPos.x - (pPos.x - loc.x)*pDir, loc.y, diameter, diameter); 
  }
}