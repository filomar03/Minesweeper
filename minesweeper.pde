GameManager manager;

void setup() {
  surface.setTitle("MINESWEEPER by filomar");
  size(400, 400);
  
  Palette.main = color(175);
  Palette.light = color(225);
  Palette.dark = color(125);
  Palette.error = color(255, 0, 0);
  Palette.text = new color[8];
  Palette.text[0] = color(0, 10, 255);
  Palette.text[1] = color(0, 145, 10);
  Palette.text[2] = color(255, 0, 0);
  Palette.text[3] = color(33, 0, 144);
  Palette.text[4] = color(152, 8, 3);
  Palette.text[5] = color(0, 141, 114);
  Palette.text[6] = color(95, 95, 95);
  Palette.text[7] = color(0, 0, 0);
  Palette.displayBackground = color(24);
  Palette.displayText = color(255, 50, 10);
  noStroke();
  
  ImageLoader.bombImg = loadImage("bomb.png");
  ImageLoader.normalSmileImg = loadImage("normal.png");
  ImageLoader.loseSmileImg = loadImage("lose.png");
  ImageLoader.winSmileImg = loadImage("win.png");
  ImageLoader.flagImg = loadImage("flag.png");
  imageMode(CENTER);
  
  manager = new GameManager(600, 24, 13); //desired pixel dimension of the game board, cells per side, percentage of bombs
}

void draw() {
  manager.updateGame();
}

void mouseReleased() {
  MouseCoords.x = mouseX;
  MouseCoords.y = mouseY;
  MouseCoords.isClicking = true;
  
  if (mouseButton == LEFT) {
    MouseCoords.leftClick = true;
    MouseCoords.rightClick = false;
  }
  
  if (mouseButton == RIGHT) {
    MouseCoords.rightClick = true;
    MouseCoords.leftClick = false;
  }
}
