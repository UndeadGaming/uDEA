// Used to handle game-related states (coin count, win/loss, etc.)

// Constants for power type
static final byte FIRE_POWER = 1;
static final byte ICE_POWER = 2;

class GameState {
  int numCoins;
  int winLose;
  int level;
  
  // Win/Lose state constants
  static final byte NULL = 0;
  static final byte WIN = 1;
  static final byte LOSE = 2;
  static final byte NEXTLVL = 3;
  
  boolean enterGame, backstoryOver;
  
  float lastBallSpawn; // When the last ball was spawned (for delaying)
  
  public GameState (int lvl) {
    level = lvl;
    numCoins = 0;
    winLose = NULL;
    enterGame = backstoryOver = (level != 0);
  }
  
  // Mark the lose flag
  void die () {
    winLose = LOSE;  
  }
  
  // Mark the win flag
  void win () {
    winLose = WIN;
  }
  
  // Lose screen
  void lose () {
    background(0);
    textMode(CENTER);
    fill(150, 0, 0);
    textSize(50);
    text("You Lose", width/2, 120); 
    textSize(30);
    
    // Display the number of coins
    text("Number of coins: " + gameState.numCoins, width/2, 370);
    textSize(40);
    
 
    text("Press Enter to play again", width/2, 470);
    if (keyEntr) {
      BGM.pause(); // Used to prevent mulitple instances of the background music
      setup();    // Reset the game
    }
  }
  
  // Win screen
  void end () {
    background(0);
    textMode(CENTER);
    fill(150, 0, 0);
    textSize(50);
    text("Congratulations!", width/2, 120); 
    textSize(30);
    
    // Number of coins
    text("Number of coins: " + gameState.numCoins, width/2, 370);
    textSize(40);
    
    text("Press Enter to play again", width/2, 470);
    if (keyEntr) {
      BGM.pause();  
      setup(); // Reset game
    }
  }
  
  void nextLevel () {
    if (level != 2) {
      loadLevel(level + 1); // Load the next level...
    } else {                // Unless there is none...
      win();                // Then mark the win flag
    }
  }
}

// Import maps from external txt files
int[][] fileRead(String filename) {  

  String[] rowData = loadStrings(filename);        // Each line
  int[][] thisMapData = new int[rowData.length][0];  // For temp storage
  
  for (int i = 0; i < rowData.length; i++) {
     String[] colString = rowData[i].split(","); // Split at each comma
     int[] colInt = new int[colString.length];   // The number of cells in the row
     for (int j = 0; j < colString.length; j++) {
         colInt[j] = Integer.parseInt(trim(colString[j])); // Trim any whitepace and convert the string to an integer
     }
     thisMapData[i] = colInt; // Store the integer
  }
  return thisMapData; // Return the temp map to be stored for the game
}