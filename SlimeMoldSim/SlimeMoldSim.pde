import java.util.HashSet;

// GLOBAL **********************************************************************
boolean setupRandom = true;
boolean randomWalls = true;
boolean colorWalls = true;
boolean texture = false;
int sidelength = 2;
int tilesWide;
int tilesTall;
Tile[][] tiles;
boolean startSet;
Position start;
ArrayList<Position> foodPositions;
boolean run;
boolean startAdded;
ArrayList<Tile> frontier;
ArrayList<Tile> interior;
HashMap<Tile, Float> distanceFromFood;
HashMap<Tile,Tile> parent;
final int INT_MAX = 2147483647;
float time;
// *****************************************************************************

// SETUP ***********************************************************************
void setup(){
  // canvas creation
  size(600,600);
  background(42);
  noStroke();
  // collection initialization
  frontier = new ArrayList<Tile>();
  interior = new ArrayList<Tile>();
  distanceFromFood = new HashMap<Tile, Float>();
  parent = new HashMap<Tile, Tile>();
  // initialize tiles
  tilesWide = width/sidelength;
  tilesTall = height/sidelength;
  tiles = new Tile[tilesTall][tilesWide];
  fillTiles();
  start = new Position(0, 0);
  foodPositions = new ArrayList<Position>();
  run = false;
  startAdded = false;
  time = 0;
  if (setupRandom) {
    setupRandom();
  }
  if (randomWalls) {
    randomWalls();
  }
}

void fillTiles() {
  for (int y = 0; y < tilesTall; y++) {
    for (int x = 0; x < tilesWide; x++) {
      tiles[y][x] = new Tile(new Position(x,y));
    }
  }
}

void setupRandom() {
  HashSet<Position> randomFood = new HashSet<Position>();
  int numFood = tilesWide;
  for(int i = 0; i < numFood; i++) {
    randomFood.add(new Position(int(random(0,tilesWide)), int(random(0,tilesTall))));
  }
  
  for(Position pos : randomFood) {
    foodPositions.add(pos);
    tiles[pos.y][pos.x].setFood();
  }
  start.x = int(random(0,tilesWide));
  start.y = int(random(0,tilesTall));
  tiles[start.y][start.x].setStart();
  startSet = true;
}

void randomWalls() {
  HashSet<Position> randomWall = new HashSet<Position>();
  int numWall = tilesWide*50;
  for(int i = 0; i < numWall; i++) {
    randomWall.add(new Position(int(random(0,tilesWide)), int(random(0,tilesTall))));
  }
  
  for(Position pos : randomWall) {
    if (!foodPositions.contains(pos)){
      tiles[pos.y][pos.x].toggleWall();
    }
  }
}
// *****************************************************************************

// DRAW ************************************************************************
void draw() {
  background(42);
  for (Tile[] row : tiles) {
    for (Tile t : row) {
      t.drawTile();
    }
  }
  if (run) {
    // initial setup, only runs on first loop
    if (!startAdded) {
      setupAStar();
      startAdded = true;
    }
    // if open unempty and path not found, loop
    if (!frontier.isEmpty()){ // && !found) {
      pathFindLoop();
    }
    // no more fresh food end here
    if (foodPositions.isEmpty()) {
      run = false;
    }
  }
  time += 0.1;
  if(time > 2*PI){
    time = 0;
  }
}
// *****************************************************************************

// HELPER FUNCTIONS ************************************************************
void setupAStar(){
  addToFrontier(tiles[start.y][start.x]);
  distanceFromFood.put(tiles[start.y][start.x], getDistanceFromFood(tiles[start.y][start.x]));
}

void pathFindLoop() {
  Tile cur = lowestDistance();
  addToInterior(cur);
  if (cur.isFood()) {
    removeFood(cur);
  }
  ArrayList<Tile> neighbors = getNeighbors(cur);
  for (Tile n : neighbors) {
    // if not walkable or if interior, ignore
    if (n.isWall() || interior.contains(n)) continue;
    if (!frontier.contains(n)) {
      addToFrontier(n);
      parent.put(n, cur);
      distanceFromFood.put(n, getDistanceFromFood(n));
    }
  }
}

void removeFood(Tile t){
  int indexMatch = -1;
  int foodCount = foodPositions.size();
  for (int i = 0; i < foodCount; i++) {
    Position pos = foodPositions.get(i);
    if (pos.x == t.pos.x && pos.y == t.pos.y) {
      indexMatch = i;
    }
  }
  foodPositions.remove(indexMatch);
}

ArrayList<Tile> getNeighbors(Tile t){
  ArrayList<Tile> neighbors = new ArrayList<Tile>();
  if(t.pos.x + 1 < tilesWide) neighbors.add(tiles[t.pos.y][t.pos.x + 1]);
  if(t.pos.x - 1 >= 0) neighbors.add(tiles[t.pos.y][t.pos.x - 1]);
  if(t.pos.y + 1 < tilesTall) neighbors.add(tiles[t.pos.y + 1][t.pos.x]);
  if(t.pos.y - 1 >= 0) neighbors.add(tiles[t.pos.y - 1][t.pos.x]);
  return neighbors;
}

Tile lowestDistance() {
  float minDistance = distanceFromFood.get(frontier.get(0));
  Tile best = frontier.get(0);
  for (Tile t : frontier) {
    if (distanceFromFood.get(t) < minDistance) {
      minDistance = distanceFromFood.get(t);
      best = t;
    }
  }
  return best;
}

Float getDistanceFromFood(Tile t){
  // looking for distance from closest food particle
  int foodCount = foodPositions.size();
  float minDistance = INT_MAX;
  for (int i = 0; i < foodCount; i++) {
    float curDistance = sqrt((float) (Math.pow(t.pos.x - foodPositions.get(i).x,2) + Math.pow(t.pos.y - foodPositions.get(i).y, 2)));
    if (curDistance < minDistance) {
      minDistance = curDistance;
    }
  }
  
  return minDistance;
}

void addToFrontier(Tile t){
  frontier.add(t);
  t.setFrontier();
}

void addToInterior(Tile t) {
  frontier.remove(t);
  t.setInterior();
  interior.add(t);
}
// *****************************************************************************

// USER INPUT ******************************************************************
void keyPressed() {
  if (!run) {
    if (keyCode == 'S') {
      if (startSet) {
        tiles[start.y][start.x].setAgar();
      }
      start.y = mouseY/sidelength;
      start.x = mouseX/sidelength;
      tiles[start.y][start.x].setStart();
      startSet = true;
    } else if (keyCode == 'F') {
      Position p = new Position(mouseX/sidelength, mouseY/sidelength);
      tiles[p.y][p.x].setFood();
      foodPositions.add(p);
    } else if (keyCode == ENTER && startSet) {
      run = true;
    }
  }
  if (keyCode == BACKSPACE) {
    setup();
  }
  if (keyCode == 'H') {
    colorWalls = !colorWalls;
  }
}

void mousePressed() {
  //if (!run) {
    tiles[mouseY/sidelength][mouseX/sidelength].toggleWall();
  //}
}
// *****************************************************************************
