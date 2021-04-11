class Tile{
  Position pos;
  Entity entity;
  
  Tile(int x, int y) {
    pos = new Position(x,y);
  }
  
  void setEntity(Entity e) {
    entity = e;
    entity.pos = this.pos;
    entity.tile = this;
  }
  
  void show(){
    if (entity == null) {
      noFill();
      stroke(40);
    }
    else if (entity instanceof Slime) {
      fill(237, 202, 0);
      noStroke();
    }
    rect(pos.x*tileSize, pos.y*tileSize, tileSize, tileSize);
  }
}
