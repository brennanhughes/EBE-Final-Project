class Slime extends Entity{
  Slime parent;
  
  Slime() {}
  
  Slime(Slime parent) {
    this.parent = parent;
  }
  
  void reproduce(Tile[][] cur, Tile[][] future) {
    float[] randoms = new float[4];
    for (int i = 0; i < 4; i++) {
      randoms[i] = random(1);
    }
    
    if (randoms[0] < reproduceChance && pos.y > 0 && cur[pos.x][pos.y-1].entity == null) {
      //up
      future[pos.x][pos.y-1].setEntity(new Slime());
    }
    
    if (randoms[1] < reproduceChance && pos.y < tilesHigh-1 && cur[pos.x][pos.y+1].entity == null) {
      //down
      future[pos.x][pos.y+1].setEntity(new Slime());
    }
    
    if (randoms[2] < reproduceChance && pos.x > 0 && cur[pos.x-1][pos.y].entity == null) {
      //left
      future[pos.x-1][pos.y].setEntity(new Slime());
    }
    
    if (randoms[3] < reproduceChance && pos.x < tilesWide-1 && cur[pos.x+1][pos.y].entity == null) {
      //right
      future[pos.x+1][pos.y].setEntity(new Slime());
    }
  }
}
