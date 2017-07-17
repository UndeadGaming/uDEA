////////////////////////////////////
//////////// Game Loop /////////////
///////////////////////////////////

// Declarations //

// Lists of assorted sprites
Sprite[] tileSprites, fxSprites, bgSprites;
Sprite[] gameObjectSprites;

int[][] mapData, objectMapData;

// Declare player
Player player;
HUD hud;


// Arraylists to handle resizable groups
ArrayList<Enemy> enemies;
ArrayList<Explosion> explosions;  // Explosion animations
ArrayList<BloodSplat> bloodSplats;  // Blood animations

// Debug Variable
boolean movementDisabled;

// Used to handle time-related functions
Time time;

// Power Balls
ArrayList<Ball> balls;
int numBalls;

// Handle game variables such as number of coins
GameState gameState;

// Objects that can be picked up by the player
ArrayList<Pickup> gameObjects;

static final int TILE_SIZE = 70;
static final int V_TILES = 10; // Number of vertical tiles
static final int H_TILES = 15; // Number of horizontal tiles

// The worldspace x-coordinate that exists as x-coordinate on the leftmost column of onscreen pixels
int lowestX;

ArrayList<FX> effects;

void setup () {
  
  
  // INITIALIZE EVERYTHING!!!
  
  
  // Display Settings
  size(1050, 700);
  smooth();
  frameRate(120);
  
  // Instantiate Classes
  
  // Sprites
  tileSprites = new Sprite[tileData.length];
  gameObjectSprites  = new Sprite[objectData.length];
  fxSprites = new Sprite[fxData.length];
  bgSprites = new Sprite[bgData.length];
  
  // Import sprites for tiles
  for (int i = 0; i < tileData.length; i++) {
      tileSprites[i] = new Sprite (tileData[i][0], tileData[i][1]);
  }
  
  // Import sprites for gameobjects
  for (int i = 0; i < objectData.length; i++) {
     gameObjectSprites[i] = new Sprite(objectData[i][0], objectData[i][1]);
     //println(image(gameObjectSprites[0].sprite));
  }
  
  // Import sprites for fx
  for (int i = 0; i < fxData.length; i++) {
     fxSprites[i] = new Sprite(fxData[i][0], fxData[i][1]);
  }
  
  // Import sprites for background images
  for (int i = 0; i < bgData.length; i++) {
     bgSprites[i] = new Sprite(bgData[i][0], bgData[i][1]);
  }
  
  //Setup Audio i.e. import audio files
  setupAudio();
  
  // Prepare title screen
  font = createFont("Imprint MT Shadow", 20);
  textFont(font);
  
  // Reset player controls
  keyLeft = keyRight = keyUp = keyDown = keyCtrl = keyEntr = false; 
  
  // The HUD for the player (constant across levels)
  hud = new HUD();
  
  // Load the first level
  loadLevel(0);
  
  // Instantiate "clock" for handling time
  time = new Time();
}



void draw () {
 
  if (!gameState.enterGame) { // The title screen, which will display on startup
     titleScreen(); 
     if (keyEntr) {           // Wait until the player presses ENTER before continuing
       gameState.enterGame = true;
     }
  } else if (!gameState.backstoryOver) { // Narrative screen to appear after the title screen (only on startup)
     narrative();
     if (keyShift) {
       gameState.backstoryOver = true;
     }
  } else if (gameState.winLose == GameState.LOSE) { // Lose Screen
    gameState.lose();
  } else if (gameState.winLose == GameState.NEXTLVL) { // Load next level
    gameState.nextLevel();
  } else if (gameState.winLose == GameState.WIN) {  // Win screen
    gameState.end();
  } else {
    
    // Update the time and recalculate the change in time since the last call to the millis() function
    time.newTime();
    time.updateDT();
    
    // Set to draw from the corner of each world grid space
    imageMode(CORNER);
    
    // Draw sprites to screen
    drawBackground();
    player.update();; 
    lowestX = int(player.loc.x / TILE_SIZE) - 7; // Save the leftmost x tile coordinate
    
    // Update game objects (posiiton, drawing, etc.)
    updateTiles(); 
    updateGameObjects();
    updateEnemies();
    updateFX();
    
  
    
  
    // Update ball positions
    for (int i = 0; i < numBalls; i++) {
       Ball b = (Ball)balls.get(i);    
       b.update();
       
       // Remove the ball if it goes of screen or collides with an enemy
       if ((b.loc.x < player.centre.x - (width/2) || b.loc.x > player.centre.x + (width/2) || b.loc.y < 0 || b.loc.y > height) || b.collided || b.collidedEnemy) {
         if (i == numBalls - 1) {
           gameState.lastBallSpawn = b.spawnTime; // Prevent the player from rapid firing 
         }
         balls.remove(b);
         numBalls--;
       }
    }
    
    // Draw HUD components
    hud.display();
    
    // Draw the indicator for being bloodthirsted
    if (player.isBloodthirsted) {
      drawIndicator();
    }
    
    // Update time
    time.oldTime();
  }
}



// Draw a backdrop of background tiles
void drawBackground() {
  for (int y = 0; y < mapData.length; y++) {
     for (int x = 0; x < mapData[0].length; x++) {
        image(tileSprites[0].sprite, x * TILE_SIZE, y * TILE_SIZE);
     }
  }
}



// Refresh the tiles on screen
void updateTiles () {

  int leftMostTile = int(player.loc.x / TILE_SIZE) - 7;

  for (int y = 0; y < V_TILES; y++) {
     for (int x = leftMostTile; x < leftMostTile + H_TILES + 1; x++) {
         if (mapData[y][x] != 0) {
            stroke(0);
            tileSprites[mapData[y][x]].display((x - leftMostTile) * TILE_SIZE - player.dx, y * TILE_SIZE);
         }
     }
  }
}

void updateGameObjects () {
  
  // List for handling concurrent modification exception
  ArrayList<Pickup> toRemove = new ArrayList<Pickup>();
  
  for (Pickup item : gameObjects) {
    if (item.touchingPlayer()) {
       item.onPickup(); // Pickup object
       toRemove.add(item);
    }
    // Display each instance of gameObjects
    item.display(lowestX);
  }
  
  // Remove all picked-up objects
  for (Pickup pickedUp : toRemove) {
    gameObjects.remove(pickedUp); 
  }
}

// Update explosions and bloodspirts
void updateFX () {
  for(int i = 0; i < explosions.size();i++){
    explosions.get(i).update();
    
    if(explosions.get(i).currentFrame == 8){ // If the end of the animation has been reached, remove it
      explosions.remove(i);
    }
  }
  
  for(int i = 0; i < bloodSplats.size(); i++){
    bloodSplats.get(i).update();
    
    if(bloodSplats.get(i).currentFrame == 5){
      bloodSplats.remove(i);
    }
  }
}

void updateEnemies () {
  
  ArrayList<Enemy> toRemove = new ArrayList<Enemy>();
  
  float enemyX, enemyY; // store enemy coordinates in order to place the bloodspurt on death
  
  for (Enemy enemy : enemies){
    enemyX = enemy.getLocX();
    enemyY = enemy.getLocY();
    if (enemy.getHealth() <= 0) {
      toRemove.add(enemy);
      bloodSplats.add(new BloodSplat(new PVector(int(enemyX),int(enemyY -50)))); // After enemy has been killed, play its animation
      playBlood();   // Play SFX                   
    } else {
      enemy.update(lowestX); // If not dead, update as usual
    }
  }
  
  for (Enemy slain : toRemove) {
    enemies.remove(slain);
  }
}

// At startup or at the end of any level (aside from the last), this function will handle
//   the required tasks
void loadLevel(int level) {
  
    // Import map
    mapData = fileRead("data/mapData" + level + ".txt");
    objectMapData = fileRead("data/objectMapData" + level + ".txt");
    
    // Game State and Objects
    gameState = new GameState(level);    
    gameObjects = new ArrayList<Pickup>(objectMapData[0].length * objectMapData.length);
    
    // Spawn Player
    player = new Player(17 * TILE_SIZE, height - (2*TILE_SIZE));
    
    
    // Spawn Enemies
    enemies = new ArrayList<Enemy>();
    
    if (level == 0) {
      enemies.add(new EnemySlime(player,15*TILE_SIZE,height - (2*TILE_SIZE)));
      enemies.add(new EnemySlime(player,30*TILE_SIZE,height - (2*TILE_SIZE)));
      
      enemies.add(new EnemyFly(player, 50*TILE_SIZE, height - (5*TILE_SIZE+40)));
      enemies.add(new EnemyFly(player, 30*TILE_SIZE, height - (5*TILE_SIZE+40)));
      
      enemies.add(new EnemySpider(player, 51*TILE_SIZE, height - (2*TILE_SIZE)));
      enemies.add(new EnemySpider(player, 61*TILE_SIZE, height - (2*TILE_SIZE)));
      enemies.add(new EnemySpider(player, 75*TILE_SIZE, height - (2*TILE_SIZE)));
      enemies.add(new EnemySpider(player, 69*TILE_SIZE, height - (2*TILE_SIZE)));
    } else if (level == 1) {
      enemies.clear();
      enemies.add(new EnemySlime(player, 48*TILE_SIZE, height-(2*TILE_SIZE)));
      enemies.add(new EnemySlime(player, 55*TILE_SIZE, height-(2*TILE_SIZE)));
      
      enemies.add(new EnemySpider(player, 70*TILE_SIZE, height-(2*TILE_SIZE)));
      enemies.add(new EnemySpider(player, 75*TILE_SIZE, height-(2*TILE_SIZE)));
      enemies.add(new EnemySpider(player, 82*TILE_SIZE, height-(2*TILE_SIZE)));
      enemies.add(new EnemySpider(player, 86*TILE_SIZE, height-(2*TILE_SIZE)));
      
      enemies.add(new EnemySlime(player, 110*TILE_SIZE, height-(2*TILE_SIZE)));
      enemies.add(new EnemySlime(player, 99*TILE_SIZE, height-(8*TILE_SIZE)));
      
      enemies.add(new EnemyFly(player, 30*TILE_SIZE, height-(5*TILE_SIZE+20)));
    } else {
      
      enemies.add(new EnemySlime(player, 51*TILE_SIZE, height-(7*TILE_SIZE)));
      enemies.add(new EnemySlime(player, 50*TILE_SIZE, height-(7*TILE_SIZE)));
      
      enemies.add(new EnemySpider(player, 61*TILE_SIZE, height-(4*TILE_SIZE)));
      enemies.add(new EnemySpider(player, 58*TILE_SIZE, height-(4*TILE_SIZE)));
      enemies.add(new EnemySpider(player, 60*TILE_SIZE, height-(4*TILE_SIZE)));
      enemies.add(new EnemySpider(player, 73*TILE_SIZE, height-(3*TILE_SIZE)));
      enemies.add(new EnemySpider(player, 75*TILE_SIZE, height-(3*TILE_SIZE)));
      enemies.add(new EnemySpider(player, 76*TILE_SIZE, height-(3*TILE_SIZE)));
      enemies.add(new EnemySpider(player, 78*TILE_SIZE, height-(3*TILE_SIZE)));
      enemies.add(new EnemySpider(player, 84*TILE_SIZE, height-(3*TILE_SIZE)));
      enemies.add(new EnemySpider(player, 87*TILE_SIZE, height-(3*TILE_SIZE)));
      enemies.add(new EnemySpider(player, 89*TILE_SIZE, height-(3*TILE_SIZE)));
      enemies.add(new EnemySpider(player, 95*TILE_SIZE, height-(3*TILE_SIZE)));
      enemies.add(new EnemySpider(player, 99*TILE_SIZE, height-(3*TILE_SIZE)));
      
      enemies.add(new EnemySlime(player, 42*TILE_SIZE, height-(2*TILE_SIZE)));
      enemies.add(new EnemySlime(player, 39*TILE_SIZE, height-(2*TILE_SIZE)));
      
      enemies.add(new EnemyFly(player, 30*TILE_SIZE, height-(4*TILE_SIZE+40)));
      enemies.add(new EnemyFly(player, 40*TILE_SIZE, height-(4*TILE_SIZE+40)));
      enemies.add(new EnemyFly(player, 87*TILE_SIZE, height-(5*TILE_SIZE+40)));
      enemies.add(new EnemyFly(player, 90*TILE_SIZE, height-(5*TILE_SIZE+40)));
      enemies.add(new EnemyFly(player, 95*TILE_SIZE, height-(5*TILE_SIZE+40)));
      enemies.add(new EnemyFly(player, 79*TILE_SIZE, height-(5*TILE_SIZE+40)));
    }
    
    // Create arraylist of balls
    balls = new ArrayList();
    numBalls  = 0;
    
      // Keep track of game objects
    for (int y = 0; y < objectMapData.length; y++) {
      for (int x = 0; x < objectMapData[0].length; x++) {
         if (objectMapData[y][x] != 0) {
            gameObjects.add(getObjectType(objectMapData[y][x], new PVector (x * TILE_SIZE, y * TILE_SIZE)));
         }
      }
    }
    
    // Reset lists for FX
    explosions = new ArrayList<Explosion>();
    bloodSplats = new ArrayList<BloodSplat>();
}


// Used to indicate bloodthirst
void drawIndicator () {
  int indicatorSize = 30;
      
  noFill();
  stroke(200, 80, 60, 200);
  
  strokeWeight(indicatorSize);
  
  // Draw an aura (rectangle outline) around the edge of the screen
  rect(width/2, height/2, width /*- indicatorSize*/, height /*- indicatorSize*/);
}
  