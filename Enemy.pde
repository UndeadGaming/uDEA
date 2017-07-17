interface Enemy {
  void update(int lowestX);      // Update
  PVector getCentre();           // Get the centre position
  int getWidth();                // Get the size of the object
  void updateHealth (int damIn); // Modify its health
  int getHealth();               // Get the health
  void stopMovement();           // Freeze the object
  void hurt();                   // Damage the object
  float getLocX();               // Get the x location
  float getLocY();               // Get the y location
  void checkExplosion();         // Check if the enmy is in range of an explosion
}