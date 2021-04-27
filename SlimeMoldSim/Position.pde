class Position {
  int x;
  int y;
  Position(int x, int y) {
    this.x = x;
    this.y = y;
  }
  
  @Override
  boolean equals(Object o){
    if (o instanceof Position) {
      Position p = (Position) o;
      if (p.x == this.x && p.y == this.y) {
        return true;
      } else return false;
    } else return false;
  }
}
