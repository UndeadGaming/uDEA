class HUD {
  
  HealthBar health;
  PowerBar power;
  Bloodthirst bloodthirst;
  
  public HUD () {
    health = new HealthBar();
    power = new PowerBar();
    bloodthirst = new Bloodthirst();
  }
  
  // Display the separate components
  void display () {
    health.display();
    power.display();
    bloodthirst.display();
  }
}

class HealthBar {
  PVector loc = new PVector(30, 650);
  int barWidth = 102; // An extra pixel on each side of the bar
  int barHeight = 20; // The size of the bar
  
  public HealthBar () {
  }
  
  void display() {
     noFill();
     rectMode(CORNER);
     strokeWeight(1);
     stroke(0);
     rect(loc.x, loc.y, barWidth, barHeight);
     
     if (player.health > 0) {
       fill(255, 0, 0);
       noStroke();
       
       // Fill the bar up to the amount of health the player has
       rect(loc.x + 1, loc.y + 1, player.health + 1, barHeight - 1);
     }
  }
}

// Handled similar to healthbar
class PowerBar {
  
  PVector loc = new PVector (918, 650);
  int barWidth = 102;
  int barHeight = 20;
  
  public PowerBar () {
  }
  
  void display () {
     noFill();
     rectMode(CORNER);
     strokeWeight(1);
     stroke(0);
     rect(loc.x, loc.y, barWidth, barHeight);
     
     // Only fill if there is power in the first place
     if (player.power > 0) {
       fill(0, 0, 255);
       noStroke();
       rect(loc.x + 1, loc.y + 1, player.power + 1, barHeight - 1);
     }
  }
}

// A vertical, two directional metre to indicate bloodthirst
class Bloodthirst {
  
  PVector loc = new PVector (40, 350);
  int barWidth = 21;
  int barHeight = 202;
  
  public Bloodthirst () {
  }
  
  void display () {
     noFill();
     rectMode(CENTER);
     strokeWeight(1);
     stroke(0);
     rect(loc.x, loc.y, barWidth, barHeight);
     
     
     if (player.bloodthirst > 0) {
       fill(240, 80, 20);
       noStroke();
       rect(loc.x, loc.y, barWidth - 2, player.bloodthirst * 2); // Increases in two directions
     }
     
     // Bloodthirst mode indicator
     if (player.isBloodthirsted) {
       drawIndicator();
     }
  }
  
  // Used to draw a red aura around the player's hand
  void drawIndicator() {
    strokeWeight(25);
    stroke(255, 0, 0, 150);
    noFill();
  }
}