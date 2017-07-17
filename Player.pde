class Player extends DynamicGameObject {

  static final int pWidth = 72;  // The width of the player sprite
  static final int pHeight = 97; // The height of the player sprite
  
  int state;                     // Which state (walking, jumping, etc. the player is in)
  int orientation;               // Which direction the player is currently facing
  Sprite[] sprites;              // The list of sprites associated with the player
  
  static final float pSpeed = 8f;// The player's speed
  
  Orb orb;                       // The orb of energy held by the player
  
  private int health;              // Player health level
  private float power;               // Player power level
  float bloodthirst;                 // Player bloodthirst level
  boolean isBloodthirsted;         // Whether the player is in Bloodthirsted mode
  static final int powerCost = 5;  // How much it cost to fire a ball
  static final int footOffset = 4; // Offset to better approximate player foot position
  
  int H_WEIGHT;                    // The static x-component for the player's location
  PVector screenPos;               // The player's position on-screen
  int dx;                          // The difference between the player's x and their closest (left) x column line
  
  static final int damageCooldown = 1200; // Time before player may be hurt again
  boolean playerHurt;                     // Whether the player is currently in a hurt phase
  int lastDamage;                         // The last time the player took damage
  
  int animCount;            //counter for sprite animation  
  boolean isMoving;         //activates sprite animation
  int animFrame;            //frame for sprite animation
  
  int thirstCounter, thirstStart;  // When the bloodthirst is initiated and the counter from then on
  static final int thirstDuration = 5000;  // How long the thirst should last
  byte currentPower;      // The currently equipped power
  boolean switchingPower;  // Flag to show that the power is currently switching

  
  
  public Player (int xin, int yin) {
    super(new PVector(xin, yin), new PVector(0,0), pSpeed);
    
    H_WEIGHT = (width/2) - (Player.pWidth/2);                     // Permanent player x-coordinate on-screen
    screenPos = new PVector (H_WEIGHT, height - (2 * TILE_SIZE)); // Initial position
    dx = int(loc.x) % TILE_SIZE;                                  // Initial dx
    orientation = 1;                                              // Set player to face right
    state = 0;                                                    // Set the state to default
    sprites = new Sprite[playerSpriteData.length];                // Get the list of player sprites
    loadSprites();                                                // Load them to be used with the player
    isJumping = false;                                            // Initially static
    isGrounded = true;                                            // "        " on ground
    orb = new Orb();                                              // Power source
    
    // Player stats
    health = 100;
    power = 100;
    bloodthirst = 0;
    isBloodthirsted = false;
    
    // Centre location
    centre = new PVector(loc.x + (pWidth/2), loc.y - (pHeight/2)); // The centre position of the player sprite
    
    
    // Damage
    lastDamage = 0;
    playerHurt = false;
    
    // Animiation
    animCount = 0;
    isMoving = false;
    
    currentPower = FIRE_POWER;

  }
  
  
  // Load the sprites into memory for use in game
  void loadSprites() {
    for (int i = 0; i < playerSpriteData.length; i++) {
      sprites[i] = new Sprite (playerSpriteData[i][0], playerSpriteData[i][1]);
    }
  }
  
  void update () {
    movement = new PVector(0,0); // Assume the player is not moving
    input();                     // Handle keyboard input
    isGrounded = checkGrounded();
    
    // Handle vertical move states
    if (isGrounded) {
      isFalling = false; 
    }
    if (isJumping) {
      jump();
    }
    if (!isGrounded && !isJumping) {
      fall();
    }
    
    handleMovement(); // Check collisions and add movement
    checkEdges();   // check screen bounds
    
    // Update difference in x from left column
    dx = int(loc.x) % TILE_SIZE;
    
    // Screen y will always equal loc.y (no vertical scrolling)
    screenPos.y = loc.y;
   
    // Check to see if the player should still be hurt
    if (playerHurt & millis() - lastDamage > damageCooldown) {
      playerHurt = false; 
    }
    
    if (isBloodthirsted) {
      if (thirstCounter - thirstStart > thirstDuration) {
        isBloodthirsted = false;
      } else {
        thirstCounter = millis();
      }
    } else if (bloodthirst < 100) {
      bloodthirst -= 0.05; // Called due to incompatibility with function
    }
    
    updatePower(0.025); // Regenerate power slowly over time
    
    display();      // Display the player sprite
    orb.update(loc, orientation); // Update the power orb
    
    centre = new PVector(loc.x + (pWidth/2), loc.y - (pHeight/2)); // Update sprite centre position
  }
  
  void display () {
    imageMode(CORNERS);
    
    // Tint the sprite if the player is hurt
    if (playerHurt) {
       tint(255, 0, 0, 200);
    }
    
    //Animate jumping if player is jumping
    if((isFalling)){
      sprites[12].display(screenPos.x, screenPos.y, screenPos.x + pWidth, screenPos.y - pHeight, orientation);
    }
    
    // Animate if the player is moving left/right
    else if (isMoving){
        if(animFrame >= 11){
            animFrame = 0; // Reset to first frame after last
        }
        animFrame++; // Iterate frame
        sprites[animFrame].display(screenPos.x, screenPos.y, screenPos.x + pWidth, screenPos.y - pHeight, orientation);  // Running player sprite
     } else {
        sprites[state].display(screenPos.x, screenPos.y, screenPos.x + pWidth, screenPos.y - pHeight, orientation); // Still player sprite
     }
     
     // Refresh tint at end (for safety and simplicity)
     noTint();
  }
  
  void handleMovement () {
    int HMoveTo; // Where the player is attempting to go to horizontally
    int yBox1, yBox2;
    
    int yBox1Draw, yBox2Draw;
    
    // Where the player is attempting to move (x)
    if (orientation == -1) {
      HMoveTo = ((int)(loc.x + (movement.x * speed)))/TILE_SIZE;
    } else {
      HMoveTo = ((int)(loc.x + pWidth + 1 + (movement.x * speed)))/TILE_SIZE;
    }
    
    // Generate collision boxes
    yBox1 = int((loc.y - 1)/TILE_SIZE);
    yBox2 = int((loc.y - TILE_SIZE)/TILE_SIZE) - 1;
    
    
    // Reset collision boxes as necessary  
    if (!isJumping && !isFalling) {
      if (yBox1 - yBox2 > 1) {
         yBox1--;
      }
    }
    
    // Constrain the upper box to not go offscreen
    yBox2 = constrain(yBox2, 0, 10);
    
    
    
    if (mapData[yBox1][HMoveTo] == 36 || mapData[yBox2][HMoveTo] == 36 || mapData[yBox1][HMoveTo] == 38 || mapData[yBox2][HMoveTo] == 38) {
      
       // If the pllayer has reached the door, move to the next level
       background(0);
       gameState.winLose = GameState.NEXTLVL;
       
    } else if (mapData[yBox1][HMoveTo] != 0 || mapData[yBox2][HMoveTo] != 0) {
      
       loc.add(new PVector (0, movement.y * speed)); // Prevent horizontal movement as necessary
       
    } else if (isJumping && (mapData[floor((loc.y - pHeight)/TILE_SIZE)][floor(loc.x/TILE_SIZE)] != 0 || mapData[floor((loc.y - pHeight)/TILE_SIZE)][floor((loc.x+pWidth)/TILE_SIZE)] != 0)) {
      
       // Stop the player from clipping vertically
       movement.y = 0;
       isJumping = false;
       fall();
       
    } else {
       loc.add(movement.mult(speed)); // Else move normally
    }
  }
  
  // Get the current direction of the player
  int getOrientation () {
    return orientation;
  }
  
  // Set the current player state
  void setState (int statein) {
    state = statein;
  }
  
  // Return the opposing horizontal element
  void flipOrientation () {
    orientation = orientation * -1; // If left, set right/if right, set left
  }
  
  // Check if the player is currently grounded
  boolean checkGrounded () {
    for (int i = footOffset; i < pWidth - footOffset; i++) {
      if (mapData[ceil(player.loc.y)/TILE_SIZE][floor(player.loc.x + i)/TILE_SIZE] != 0) { // If there is a tile underneath the player
        return true;
      }
    }
    return false;
  }
  
  // Check screen edges
  void checkEdges () {
    
    if (loc.y > height) {
      loc.y = height; 
    } else if (loc.y - pHeight < 0) {
      loc.y = pHeight; 
    }
  }
  
  // Handle movement from input
  void input () {
    
    // Go left
    if (keyLeft) {
      if (getOrientation() == 1) {
        flipOrientation();
      }
      if (!movementDisabled) {
        isMoving = true;
        movement.x = -1;
      }
    } else 
    
    // Go right
    if (keyRight) {
      if (getOrientation() == -1) {    
        flipOrientation();
      }
      if (!movementDisabled) {
        isMoving = true;
        movement.x = 1;
      }
    } else {
      isMoving = false; 
    }
    
    // Fire ball
    if (keyCtrl) {
      if (power >= powerCost) {
        if (numBalls > 0) {
          Ball b = (Ball)balls.get(numBalls - 1);
          if (b.spawnTime + Ball.cooldown <= time.time) {
            balls.add(new Ball(orb.loc, orientation, currentPower)); // Spawn ball
            if (currentPower == ICE_POWER) {
              playIce();   // Play SFX
            } else {
              playFire();
            }
            numBalls++;
            power-= powerCost; // Decrease power
          }
  
        } else if (millis() - gameState.lastBallSpawn > Ball.cooldown) { // To handle an empty array
            balls.add(new Ball(orb.loc, orientation, currentPower));
                        if (currentPower == ICE_POWER) {
              playIce();   // Play SFX
            } else {
              playFire();
            } 
            numBalls++;
            power-= powerCost;
        }   
      }
    }
    
    // Jump as long as the player holds up
    if (keyUp) {
      if (!isJumping && checkGrounded()) {
        isJumping = true;
      }
    } else {  
      if (isJumping && !checkGrounded()) {
        jumpCounter = 30; // Max out jump (begin fall) if player lets go of UP
      }
    }
    
    if (keyShift) {
      if (!switchingPower) { // To prevent player from rapidly toggling back and forth
        switchingPower = true;
        if (currentPower == FIRE_POWER) {
           currentPower = ICE_POWER;
        } else if (currentPower == ICE_POWER) {
           currentPower = FIRE_POWER; 
        }
      } 
    } else {
      switchingPower = false; 
    }
    
    if (keyDown && !isBloodthirsted && bloodthirst == 100) {
      isBloodthirsted  = true; 
      bloodthirst = 0;
      thirstCounter = thirstStart = millis(); 
    }
  }
  
  void jump() {
    // Handle checks before jumping/continuing to jump
    if ((!isGrounded || jumpCounter == 0) && jumpCounter < 30 && loc.y != pHeight) {
       movement.y = -1;
       jumpCounter++;
    } else {
       jumpCounter = 0;
       isJumping = false;
       isFalling = true;
    }
  }
  
  void fall() {
    movement.y += 1;
  }
  
  // Change the player health value
  void updateHealth (int change) {
    // If the player is not currently recovering, damage them
    int now = millis();
    
    // If the player has not been damaged recently...
    if (now - lastDamage > damageCooldown) {
      
      playPunch(); // Play hurt SFX
      playerHurt = true;  // flag that the player is hurt
      lastDamage = now;
      health += change;
      
      // Fix negative/overclocked health
      if (health < 0) {
        health = 0;
      } else if (health > 100) {
        health = 100; 
      }
      
      // Flag the lose state
      if (health == 0) {
        gameState.die(); 
      }
    }
  }
  
  // Change the player power value
  void updatePower (float change) {
    power += change;
    if (power > 100) {
      power = 100; 
    }
  }
  
  // Change the player bloodthrist value
  void addBloodthirst (float add) {
    if (!isBloodthirsted) {
      bloodthirst += add;
      if (bloodthirst > 100) {
        bloodthirst = 100;
      }
    }
  }
  
  int getCurrentPower () {
    return currentPower; 
  }
 
}