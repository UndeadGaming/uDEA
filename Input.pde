// Flags for assorted keys
boolean keyLeft, keyRight, keyUp, keyDown, keyCtrl, keyEntr, keyShift;

void keyPressed () {
  setMove(keyCode, true); // Flag key presses
}

void keyReleased() {
  setMove(keyCode, false); // Flag key releases
}

// Rather than input directly affecting movement or firing, 
//   simply indicate what the player wants to do and handle
//   the events elsewhere
boolean setMove(int keyIn, boolean pressed) {
  switch (keyIn) {   
    case LEFT:     return keyLeft  = pressed;
    case RIGHT:    return keyRight = pressed;
    case UP:       return keyUp    = pressed;
    case DOWN:     return keyDown  = pressed;
    case CONTROL:  return keyCtrl  = pressed;
    case ENTER:    return keyEntr  = pressed;
    case SHIFT:    return keyShift = pressed;
    default:       return            pressed;
  }
}