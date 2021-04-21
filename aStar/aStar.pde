// GLOBAL **********************************************************************
boolean allowDiagonal = true; // if true, heuristic is euclidian-ish (no sqrt), else manhattan
int defaultSL = 50;
int sidelength;
int tilesWide;
int tilesTall;
Tile[][] tiles;
boolean startSet;
boolean endSet;
Index start;
Index end;
boolean find;
boolean startAdded;
ArrayList<Tile> open;
ArrayList<Tile> closed;
HashMap<Tile, Float> fCost;
HashMap<Tile, Float> gCost;
HashMap<Tile, Tile> cameFrom;
boolean found;
final int INT_MAX = 2147483647;
// *****************************************************************************
// SETUP ***********************************************************************
void setup() {
  noStroke();
  size(1400, 800);
  background(255);
  open = new ArrayList<Tile>();
  closed = new ArrayList<Tile>();
  fCost = new HashMap<Tile, Float>();
  gCost = new HashMap<Tile, Float>();
  cameFrom = new HashMap<Tile, Tile>();
  // calculate dimensions
  // fill tiles
  setupBlank();
  start = new Index(0, 0);
  end = new Index(0, 0);
  find = false;
  startAdded = false;
  found = false;
}

void setupBlank() {
  sidelength = defaultSL;
  tilesWide = width/sidelength;
  tilesTall  = height/sidelength;
  tiles = new Tile[tilesTall][tilesWide];
  fillTiles();
}

// *****************************************************************************
// DRAW ************************************************************************
void draw() {
  // DRAW TILES
  for (Tile[] row : tiles) {
    for (Tile t : row) {
      t.drawTile();
    }
  }
  // if requested
  if (find) {
    // if not set up
    if (!startAdded) {
      setupAStar();
      startAdded = true;
    }
    // if open unempty and path not found, loop
    if (!open.isEmpty() && !found) {
      aStarLoop();
    }
    // if open empty and path not found
    if (open.isEmpty() && !found) {
      // path does not exist
    }
    // if found, draw path
    if (found) {
      drawPath();
    }
  }
  delay(100);
}
// *****************************************************************************
// FUNCTIONS *******************************************************************
void drawPath() {
  Tile dest = tiles[end.y][end.x];
  while (cameFrom.containsKey(dest)) {
    dest = cameFrom.get(dest);
    dest.setPath();
  }
}
void aStarLoop() {
  Tile cur = lowestF();
  if (cur == tiles[end.y][end.x]) {
    found = true;
  }
  addToClosed(cur);
  ArrayList<Tile> neighbors = getNeighbors(cur);
  for (Tile n : neighbors) {
    // if not walkable or in closed list, ignore
    if (n.isWall() || closed.contains(n)) continue;
    float addG = (n.isDiagonal(cur)) ? sqrt(2) : 1;
    if (!open.contains(n)) {
      addToOpen(n);
      cameFrom.put(n, cur);
      gCost.put(n, gCost.get(cur) + addG);
      fCost.put(n, gCost.get(n) + h(n));
    } else if (open.contains(n)) {
      float tentG = gCost.get(cur) + addG;
      if (tentG < gCost.get(n)) {
        cameFrom.put(n, cur);
        gCost.put(n, tentG);
        fCost.put(n, gCost.get(n) + h(n));
      }
    }
  }
}
float h(Tile t) {
  if (allowDiagonal) { // euclidian-ish
    return pow(end.x - t.pos.x, 2) + pow(end.y - t.pos.y, 2);
  } else { // manhattan
    return (abs(end.x - t.pos.x) + abs(end.y - t.pos.y));
  }
}
ArrayList<Tile> getNeighbors(Tile t) {
  ArrayList<Tile> neighbors = new ArrayList<Tile>();
  if (allowDiagonal) {
    for (int i = -1; i <= 1; i++) {
      for (int j = -1; j <= 1; j++) {
        // skip if self
        if (i == 0 && j == 0) continue;
        // skip if out of bounds
        if (t.pos.y + i < 0 || t.pos.y + i >= tilesTall|| t.pos.x + j < 0 || t.pos.x + j >= tilesWide) continue;
        // else add
        neighbors.add(tiles[t.pos.y + i][t.pos.x + j]);
      }
    }
  } else {
    if(t.pos.x + 1 < tilesWide) neighbors.add(tiles[t.pos.y][t.pos.x + 1]);
    if(t.pos.x - 1 >= 0) neighbors.add(tiles[t.pos.y][t.pos.x - 1]);
    if(t.pos.y + 1 < tilesTall) neighbors.add(tiles[t.pos.y + 1][t.pos.x]);
    if(t.pos.y - 1 >= 0) neighbors.add(tiles[t.pos.y - 1][t.pos.x]);
  }
  return neighbors;
}
Tile lowestF() {
  float minF = INT_MAX;
  float minH = INT_MAX;
  Tile best = null;
  for (Tile t : open) {
    if (fCost.get(t) < minF) {
      minF = fCost.get(t);
      minH = h(t);
      best = t;
    } else if (fCost.get(t) == minF) {
      if (gCost.get(t) < minH) {
        minF = fCost.get(t); //unnecessary
        minH = h(t);
        best = t;
      }
    }
  }
  return best;
}
void setupAStar() {
  addToOpen(tiles[start.y][start.x]);
  gCost.put(tiles[start.y][start.x], 0.0);
  fCost.put(tiles[start.y][start.x], h(tiles[start.y][start.x]));
}
void addToOpen(Tile t) {
  open.add(t);
  t.setOpen();
}
void addToClosed(Tile t) {
  open.remove(t);
  t.setClosed();
  closed.add(t);
}
void fillTiles() {
  for (int y = 0; y < tilesTall; y++) {
    for (int x = 0; x < tilesWide; x++) {
      tiles[y][x] = new Tile(new Index(x, y));
    }
  }
}
// *****************************************************************************
// USER INPUT ******************************************************************
void keyPressed() {
  if (!find) {
    if (keyCode == 'S') {
      if (startSet) {
        tiles[start.y][start.x].setDefault();
      }
      start.y = mouseY/sidelength;
      start.x = mouseX/sidelength;
      tiles[start.y][start.x].setStart();
      startSet = true;
    } else if (keyCode == 'E') {
      if (endSet) {
        tiles[end.y][end.x].setDefault();
      }
      end.y = mouseY/sidelength;
      end.x = mouseX/sidelength;
      tiles[end.y][end.x].setEnd();
      endSet = true;
    } else if (keyCode == ENTER && startSet && endSet) {
      find = true;
    }
  }
  if (keyCode == BACKSPACE) {
    setup();
  }
}

void mousePressed() {
  if (!find) {
    tiles[mouseY/sidelength][mouseX/sidelength].toggleWall();
  }
}
// *****************************************************************************
