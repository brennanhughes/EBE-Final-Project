class Tile {
  // FIELDS ********************************************************************
  Index pos;
  boolean start;
  boolean end;
  boolean def;
  boolean wall;
  boolean open;
  boolean closed;
  boolean path;
  color col;
  // ***************************************************************************
  // CONSTRUCTORS **************************************************************
  Tile(Index pos) {
    this.pos = pos;
    setDefault();
  }
  // ***************************************************************************
  // FUNCTIONS *****************************************************************
  boolean isDiagonal(Tile t) { // only call on neighbors
    int xdiff = abs(t.pos.x - this.pos.x);
    int ydiff = abs(t.pos.y - this.pos.y);
    if (xdiff+ydiff == 2) {
      return true;
    }
    return false;
  }
  void setColor() {
    // open/closed (only color if not covering vital info)
    if (open && !start && !end && !wall) {
      col = color(245, 184, 46); // maximum yellow red
    } else if (closed && !start && !end && !wall) {
      col = color(255, 209, 49); // cyber yellow
    }
    // types
    if (start) { // always color start
      col = color(244, 172, 50); // marigold
    } else if (end) { // always color end
      col = color(255, 210, 137); // deep champagne
    } else if (def && !open && !closed) { // only color white if not in open/closed
      col = color(0, 0, 0); // black
    } else if (wall) { // always color walls
      col = color(255, 255, 255); // white
    }
    // path
    if(path && !start && !end){ // only color if not start or end
      col = color(255,255,0); // yellow
    }
  }
  void setPath(){
    path = true;
  }
  void setOpen() {
    closed = false;
    open = true;
  }
  void setClosed() {
    open = false;
    closed = true;
  }
  void setStart() {
    end = false;
    def = false;
    wall = false;
    start = true;
  }
  void setEnd() {
    start = false;
    def = false;
    wall = false;
    end = true;
  }
  void setDefault() {
    start = false;
    end = false;
    wall = false;
    open = false;
    closed = false;
    path = false;
    def = true;
  }
  void toggleWall() {
    start = false;
    end = false;
    if (!wall) {
      def = false;
      wall = true;
    } else {
      def = true;
      wall = false;
    }
  }
  void setWall(){
    start = false;
    end = false;
    wall = true;
    open = false;
    closed = false;
    path = false;
    def = false;
  }
  boolean isStart() {
    return start;
  }
  boolean isEnd() {
    return end;
  }
  boolean isWall() {
    return wall;
  }
  void drawTile() {
    setColor();
    fill(col);
    square(pos.x * sidelength, pos.y * sidelength, sidelength);
  }
  // ***************************************************************************
}
