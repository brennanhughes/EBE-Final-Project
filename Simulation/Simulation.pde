Position startingPoint;
int tileSize = 10;
int tilesWide;
int tilesHigh;
Tile[][] tiles;
float reproduceChance = 0.1;

void setup() {
  // initialize canvas
  size(800, 600);
  background(42);
  // initialize tile array
  tilesWide = width/tileSize;
  tilesHigh = height/tileSize;
  tiles = new Tile[tilesWide][tilesHigh];
  for (int x = 0; x < tiles.length; x++){
    for (int y = 0; y < tiles[0].length; y++) {
      tiles[x][y] = new Tile(x, y);
    }
  }
  // choose starting point
  //TODO: have user input starting position with mouse click
  startingPoint = new Position(tilesWide/2, tilesHigh/2);
  tiles[startingPoint.x][startingPoint.y].setEntity(new Slime());
  
  //TODO: place food
}

void draw() {
  for (int x = 0; x < tilesWide; x++){
    for (int y = 0; y < tilesHigh; y++) {
      tiles[x][y].show();
    }
  }
  // copy over tiles so that updates can be made iteratively based on previous state
  Tile[][] previousState = tileCopy(tiles);
  // update tiles, store in tiles array (done in method)
  tileUpdate(previousState);
}

Tile[][] tileCopy(Tile[][] arr){
  Tile[][] copy = new Tile[tiles.length][tiles[0].length];
  for (int i = 0; i < arr.length; i++) {
    for (int j = 0; j < arr[0].length; j++) {
      copy[i][j] = arr[i][j];
    }
  }
  return copy;
}

void tileUpdate(Tile[][] prev){
  for (int x = 0; x < tilesWide; x++) {
    for (int y = 0; y < tilesHigh; y++) {
      if (prev[x][y].entity instanceof Slime) {
        Slime s = (Slime) prev[x][y].entity;
        s.reproduce(prev, tiles);
      }
    }
  }
}
