// Functions for handling time-related variables

class Time {
  int time, lastTime;
  float deltaTime;
  
  public Time () {
   lastTime = millis();
   time = millis();
  }
  
  void newTime () {
    time = millis();
  }
  
  void oldTime () {
    lastTime = time;
  }
  
  void updateDT () {
    deltaTime = time - lastTime; 
  }
}