class Slime extends Entity{
  Slime parent;
  float reproduceChance;
  
  Slime() {
  }
  
  Slime(int x, int y, Slime parent) {
    this();
    pos = new Position(x,y);
    reproduceChance = noise(indexHash(pos.x, pos.y))*0.1;
    this.parent = parent;
  }
  
  void reproduce(Tile[][] cur, Tile[][] future) {
    float[] randoms = new float[4];
    for (int i = 0; i < 4; i++) {
      randoms[i] = random(1);
    }
    
    //float reproduceChance = 0.1;
    
    if (randoms[0] < reproduceChance && pos.y > 0 && cur[pos.x][pos.y-1].entity == null) {
      //up
      future[pos.x][pos.y-1].setEntity(new Slime(pos.x, pos.y-1, this));
    }
    
    if (randoms[1] < reproduceChance && pos.y < tilesHigh-1 && cur[pos.x][pos.y+1].entity == null) {
      //down
      future[pos.x][pos.y+1].setEntity(new Slime(pos.x, pos.y+1, this));
    }
    
    if (randoms[2] < reproduceChance && pos.x > 0 && cur[pos.x-1][pos.y].entity == null) {
      //left
      future[pos.x-1][pos.y].setEntity(new Slime(pos.x-1, pos.y, this));
    }
    
    if (randoms[3] < reproduceChance && pos.x < tilesWide-1 && cur[pos.x+1][pos.y].entity == null) {
      //right
      future[pos.x+1][pos.y].setEntity(new Slime(pos.x+1, pos.y, this));
    }
  }
  
  int intHash(int a){
    a = (a+0x7ed55d16) + (a<<12);
    a = (a^0xc761c23c) ^ (a>>19);
    a = (a+0x165667b1) + (a<<5);
    a = (a+0xd3a2646c) ^ (a<<9);
    a = (a+0xfd7046c5) + (a<<3);
    a = (a^0xb55a4f09) ^ (a>>16);
    return a;
  }
  
  int indexHash(int row, int col) {
    return (514229 + intHash(row)) * 514229 + intHash(col);
  }
}
