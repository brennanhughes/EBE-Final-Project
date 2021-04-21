int tileSize = 10;

void setup() {
  size(800, 600);
  background(42);
  noStroke();
  for (int x = 0; x < width/tileSize; x++) {
    for (int y = 0; y < height/tileSize; y++) {
      fill(noise(indexHash(x,y))*255);
      rect(x*tileSize, y*tileSize, tileSize, tileSize);
    }
  }
}

void draw() {
  background(42);
  for (int x = 0; x < width/tileSize; x++) {
    for (int y = 0; y < height/tileSize; y++) {
      fill(noise(indexHash(x,y))*255);
      rect(x*tileSize, y*tileSize, tileSize, tileSize);
    }
  }
}

int intHash(int a) {
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
