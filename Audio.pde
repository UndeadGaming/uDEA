// Minim audio library
import ddf.minim.*;

// Instantiate minim library
Minim minim;

// AudioPLayer handles audio sources
AudioPlayer BGM, coin, bloodSplatter, explosionSound, fire, hit, ice, iceBreak, hurt; 

void setupAudio () {
  
  // Minim instance
  minim = new Minim(this);
 
  // Loads the audio file from the data folder
  BGM = minim.loadFile("awesomeness.wav");
  bloodSplatter = minim.loadFile("bloodSplatter1.mp3");
  explosionSound = minim.loadFile("explosion.mp3");
  fire = minim.loadFile("fire.mp3");
  hit = minim.loadFile("punch.mp3");
  ice = minim.loadFile("ice.wav");
  iceBreak = minim.loadFile("Bottle_Break.wav");
  hurt = minim.loadFile("pain6.wav");
  coin = minim.loadFile("powerUp9.mp3");
  
  // Play and loop the background music
  BGM.play();
  BGM.loop();  
}

// Play coin sound when this function is called
void playCoin () {
  coin.pause();
  coin.play(0);
}

// Enemy death
void playBlood(){
  bloodSplatter.pause();
  bloodSplatter.play(0);
}

// Explosive box
void playExplosion(){
  explosionSound.pause();
  explosionSound.play(0);
}

// When player shoots
void playFire(){
  fire.pause();
  fire.play(0);
}

// Player hurt
void playPunch(){
  hit.pause();
  hit.play(0);
  hurt.pause();
  hurt.play(0);
}

// Sound when enemy freezes
void playIce(){
  ice.pause();
  ice.play(0);
}

// Sound when enemy becomes unfrozen
void playIceBreak(){
  iceBreak.pause();
  iceBreak.play(0);
}