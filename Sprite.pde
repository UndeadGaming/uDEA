// Handles PImage and information regarding the sprite

class Sprite {
  String name, fileLocation;
  PImage sprite;
  
  public Sprite (String n, String loc) {
     name = n;
     sprite = loadImage(loc); // Load the image from the source folder
  }
  
  // Generic image drawing
  void display (float x, float y) {
    image(sprite, x, y);
  }
  
  // Method for drawing player
  void display (float x, float y, float w, float h, int dir) {
    pushMatrix(); // Push matrix for scaling
    scale(dir, 1); // "Scale" according to player direction
    image(sprite, x * dir, y, w * dir, h);
    popMatrix();
  }
}