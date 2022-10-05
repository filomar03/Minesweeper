class Cell extends Button {
  boolean clicked = false, isBomb = false, show = false;
  int nearBombs = 0;
  int row, column;
  boolean isFlag = false;

  Cell(int x, int y, int bWidth, int bHeight, color bColor, int row, int column) {
    super(x + bWidth / 2, y + bHeight / 2, bWidth, bHeight, bColor);
    this.row = row;
    this.column = column;
  }
  
  @Override
  void show() {
    if (clicked || show) {
      stroke(Palette.dark);
      strokeWeight(bWidth * 0.02);
      fill(bColor);
      rect(x, y, bWidth, bHeight);
      noStroke();
      
      if (!isBomb && nearBombs != 0) {
        fill(Palette.text[nearBombs - 1]);
        textSize(bWidth / 3 * 2);
        text(nearBombs, x - textWidth(str(nearBombs)) / 2 + bWidth / 2, y + textAscent() / 2 + bHeight / 2);
      }
      
      if (isBomb) {
        image(ImageLoader.bombImg, x + bWidth / 2, y + bHeight / 2, bWidth / 3 * 2, bHeight / 3 * 2);
      }
    } else {
      super.show();
      manager.drawShadows(x, y, bWidth, bHeight, round(constrain(manager.shadowSize, manager.shadowSize, bWidth * manager.cellMaxShadowSizeRatio)), Palette.light, Palette.dark);
      
      if (isFlag) {
        image(ImageLoader.flagImg, x + bWidth / 2, y + bHeight / 2, bWidth / 3 * 2, bHeight / 3 * 2);
      }
    }   
  }

  @Override
  void onClick() {
    if (clicked)
      return;
      
    clicked = true;
    
    if (isBomb && false) {
      manager.gameOver = true;
      bColor = Palette.error;
    } else {
        nearBombs = calculateNearBombs();
        
        manager.availableCells--;
        if (manager.availableCells == 0) {
          manager.victory = true;
          return;
        }
        
        if (nearBombs == 0) {
        for (int r = -1; r <= 1; r++) {
          for (int c = -1; c <= 1; c++) {
            if (!(r == 0 && c == 0) && !isOutOfBounds(manager.cells, row + r, column + c)) {
              manager.cells[row + r][column + c].onClick();
            }
          }
        }
      }
    }
  } //<>//
  
  int calculateNearBombs() {
    int nearBombs = 0;
    for (int r = -1; r <= 1; r++) {
      for (int c = -1; c <= 1; c++) {
        if (!(r == 0 && c == 0) && !isOutOfBounds(manager.cells, row + r, column + c)) {
          if (manager.cells[row + r][column + c].isBomb) {
            nearBombs++; 
          }
        }
      }
    }
    return nearBombs;
  }
  
  boolean isOutOfBounds(Cell[][] cells, int r, int c) {
    try {
      Cell cell = cells[r][c];
      return false;
    } catch (ArrayIndexOutOfBoundsException e) {
      return true;
    }
  }
  
  void onRightClick() {
    isFlag = !isFlag;
  }
}
