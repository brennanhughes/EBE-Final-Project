class Tile {
  // FIELDS ********************************************************************
  Position pos;
  color col;
  boolean isStart;
  boolean isFrontier;
  boolean isInterior;
  boolean isFood;
  boolean isWall;
  boolean isAgar;
  // ***************************************************************************
  
  // CONSTRUCTORS **************************************************************
  Tile(Position pos) {
    this.pos = pos;
    setAgar();
  }
  // ***************************************************************************
  
  // FUNCTIONS *****************************************************************
  void setFood() {
    isStart = false;
    isAgar = false;
    isWall = false;
    isFood = true;
  }
  
  void setStart() {
    isFood = false;
    isAgar = false;
    isWall = false;
    isStart = true;
  }
  
  void toggleWall() {
    isStart = false;
    isFood = false;
    if (!isWall) {
      isAgar = false;
      isWall = true;
    } else {
      isAgar = true;
      isWall = false;
    }
  }
  
  boolean isWall(){
    return isWall;
  }
  
  boolean isFood() {
    return isFood;
  }
  
  void setAgar() {
    isStart = false;
    isFrontier = false;
    isInterior = false;
    isFood= false;
    isWall = false;
    isAgar = true;
  }
  
  void setFrontier() {
    isInterior = false;
    isFrontier = true;
  }
  
  void setInterior() {
    isFrontier = false;
    isInterior = true;
  }
  
  void drawTile() {
    setColor();
    fill(getColor());
    square(pos.x * sidelength, pos.y * sidelength, sidelength);
  }
  
  void setColor() {
    int slimeAlpha;
    if (texture) {
      noiseSeed(int(random(INT_MAX)));
      slimeAlpha = floor(255 * (0.1 * sin(time)*sin(pos.x)*sin(pos.y)*(0.5*noise(pos.x,pos.y)+0.5) + 0.9));
    } else slimeAlpha = 255;
    // isFrontier/isInterior (only color if not covering vital info)
    if (isFrontier && !isStart && !isFood && !isWall) {
      col = color(245, 184, 46, slimeAlpha); // maximum yellow red
    } else if (isInterior && !isStart && !isFood && !isWall) {
      col = color(255, 209, 49, slimeAlpha); // cyber yellow
    }
    // types
    if (isStart) { // always color start
      col = color(244, 172, 50); // marigold
    } else if (isFood) { // always color food
      col = color(255, 210, 137); // deep champagne
    } else if (isAgar && !isFrontier && !isInterior) { // only color if not part of plasmodium
      col = color(42); // dark gray
    } else if (isWall) { // always color walls
      if (colorWalls) col = color(213); // light gray
      else col = color(42);
    }
  }
  
  color getColor() {
    return col;
  }
  // ***************************************************************************
}
