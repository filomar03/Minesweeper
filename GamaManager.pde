class GameManager {
  //scoreboard
  int scoreBoardHeight, maxScoreBoardHeight = 85; 
  int scoreBoardX, scoreBoardY;
  float scoreBoardHeightRatio = 0.125, scoreBoardRestartButtonSizeRatio = 0.8, scoreBoardDisplaySizeRatio = 0.7;
  Button restartButton;
  DigitDisplay bombsDisplay, timeDisplay;
  int timeElapsed = 0, stoppedTime;
  boolean startedGame = false;
  
  //gameboard
  int gameBoardSize, minGameBoardSize = 400, maxGameBoardSize = 800;
  int gameBoardX, gameBoardY;
  int minCellsPerSide = 9, maxCellsPerSide = 64;
  int cellSize, minCellSize = 14;
  int cellsPerSide, totalCells;
  int totalBombs;
  int availableCells;
  float bombsRatio;
  int[] bombIndices;
  Cell[][] cells;
  
  //border
  int borderSize, maxBorderSize = 20;
  float borderSizeRatio = 0.025;
  
  //shadow
  int shadowSize;
  float shadowSizeRatio = 0.25, cellMaxShadowSizeRatio = 0.125;
  
  //game state
  boolean gameOver = false, victory = false;
  
  GameManager(int gameBoardSize, int cellsPerSide, float bombsPercentage) { //delete unused variables at the end
    //gameboard variables initialization
    this.cellsPerSide = constrain(cellsPerSide, minCellsPerSide, maxCellsPerSide);
    cellSize = constrain(floor(constrain(gameBoardSize, minGameBoardSize, maxGameBoardSize) / this.cellsPerSide), minCellSize, maxGameBoardSize / this.cellsPerSide);
    this.gameBoardSize = cellSize * this.cellsPerSide;
    
    //scoreboard variables initialization
    scoreBoardHeight = constrain(round(this.gameBoardSize * scoreBoardHeightRatio), round(minGameBoardSize * scoreBoardHeightRatio), maxScoreBoardHeight);
     
    //border e shadow variables initialization
    borderSize = constrain(round(this.gameBoardSize * borderSizeRatio), round(minGameBoardSize * borderSizeRatio), maxBorderSize);
    shadowSize = round(borderSize * shadowSizeRatio);
    
    //set window dimension as game needs
    surface.setSize(borderSize * 2 + this.gameBoardSize, borderSize * 3 + scoreBoardHeight + this.gameBoardSize);
    
    //initializating GUI variables/objects (require essential dimensions such as gameBoardSize to be already computed)
    gameBoardX = borderSize;
    gameBoardY = 2 * borderSize + scoreBoardHeight;
    
    scoreBoardX = borderSize;
    scoreBoardY = borderSize;
    
    restartButton = new RestartButton(scoreBoardX + round(this.gameBoardSize / 2), scoreBoardY + round(scoreBoardHeight / 2), round(scoreBoardHeight * scoreBoardRestartButtonSizeRatio), round(scoreBoardHeight * scoreBoardRestartButtonSizeRatio), color(Palette.main));
    bombsDisplay = new DigitDisplay(scoreBoardX + borderSize, scoreBoardY + round(scoreBoardHeight / 2), 4, round(scoreBoardHeight * scoreBoardDisplaySizeRatio), borderSize, Palette.displayBackground, Palette.displayText);
    textSize(round(scoreBoardHeight * scoreBoardRestartButtonSizeRatio) / 3 * 2);
    timeDisplay = new DigitDisplay(width - scoreBoardX - borderSize * 2 - round(textWidth(nf(9, 4))), scoreBoardY + round(scoreBoardHeight / 2), 4, round(scoreBoardHeight * scoreBoardDisplaySizeRatio), borderSize, Palette.displayBackground, Palette.displayText);
   
    //game logic variables initialization
    bombsRatio = bombsPercentage / 100;
    startGameLogic();
  }
  
  void updateGame() {
    drawBoard();
    
    restartButton.handleClick();
    if (gameOver || victory) {
      showBombs();
    } else {
      handleCellsClick();
    }
    
    drawScoreBoard();
    
    drawGameBoard();
  }

  void drawBoard() {
    fill(175);
    rect(0, 0, width, height);
    drawShadows(0, 0, width, height, shadowSize, Palette.light, Palette.dark);
  }

  void handleCellsClick() {
    //didn't use Cell native handleClick() method to avoid using a loop
    if ((MouseCoords.x >= gameBoardX && MouseCoords.x < gameBoardX + gameBoardSize) && (MouseCoords.y >= gameBoardY && MouseCoords.y < gameBoardY + gameBoardSize) && MouseCoords.isClicking) {
      int rowClicked = (MouseCoords.y - gameBoardY) / cellSize;
      int columnClicked = (MouseCoords.x - gameBoardX) / cellSize;
      
      startedGame = true;
      
      MouseCoords.isClicking = false;
      if (MouseCoords.leftClick) {
        MouseCoords.leftClick = false;
        cells[rowClicked][columnClicked].onClick();
      } else if (MouseCoords.rightClick) {
        MouseCoords.rightClick = false;
        cells[rowClicked][columnClicked].onRightClick();
      }
    }
  }
  
  void drawScoreBoard() {
    fill(175);
    rect(scoreBoardX, scoreBoardY, gameBoardSize, scoreBoardHeight);
    drawShadows(scoreBoardX - shadowSize, scoreBoardY - shadowSize, gameBoardSize + shadowSize * 2, scoreBoardHeight + shadowSize * 2, shadowSize, Palette.dark, Palette.light);
    restartButton.show();
    bombsDisplay.show();
    if (!startedGame) {
      timeElapsed = round(float(millis()) / 1000);
    }
    if (gameOver || victory) {
      timeDisplay.data = stoppedTime;
    } else {
      timeDisplay.data = round(float(millis()) / 1000) - timeElapsed;
      stoppedTime = timeDisplay.data; 
    }
    timeDisplay.show();
  }
  
  void drawGameBoard() {
    fill(175);
    rect(gameBoardX, gameBoardY, gameBoardSize, gameBoardSize);
    drawShadows(gameBoardX - shadowSize, gameBoardY - shadowSize, gameBoardSize + shadowSize * 2, gameBoardSize + shadowSize * 2, shadowSize, Palette.dark, Palette.light);
    drawCells();  
  }
  
  void drawCells() {
    for (int r = 0; r < cellsPerSide; r++) {
      for (int c = 0; c < cellsPerSide; c++) {
        cells[r][c].show(); 
      }
    }
  }
  
  void showBombs() {
    for (int i : bombIndices) {
      cells[int(float(i) / cellsPerSide)][int(float(i) % cellsPerSide)].show = true;
    }
  }
  
  void drawShadows(int x, int y, int _width, int _height, int _shadowSize, int color1, int color2) {
      pushMatrix();
      
      translate(x, y);
      fill(color1);
      
      beginShape();
      vertex(0, 0);
      vertex(_width, 0);
      vertex(_width - _shadowSize, _shadowSize);
      vertex(_shadowSize, _shadowSize);
      vertex(_shadowSize, _height - _shadowSize);
      vertex(0,_height);
      endShape();
      
      translate(_width, _height);
      rotate(PI);
      fill(color2);
      
      beginShape();
      vertex(0, 0);
      vertex(_width, 0);
      vertex(_width - _shadowSize, _shadowSize);
      vertex(_shadowSize, _shadowSize);
      vertex(_shadowSize, _height - _shadowSize);
      vertex(0,_height);
      endShape();
      
      popMatrix(); 
  }
  
  int[] generateNonRepeatingRandoms(int min, int max, int n) { //inclusive min, exclusive max
    int[] pool = new int[max - min];
    int[] generatedNumbers = new int[n];
    
    for (int i = 0; i < pool.length; i++) {
      pool[i] = min + i;
    }
    
    for (int i = 0; i < n; i++) {
      int randomIndex = floor(random(max - min - (i + 1)));
      generatedNumbers[i] = pool[randomIndex];
      swap(pool, randomIndex, max - min - 1 - i);
    }
    
    return generatedNumbers;
  }
  
  void swap(int[] array, int index1, int index2) {
    int t = array[index1];
    array[index1] = array[index2];
    array[index2] = t;
  }
  
  void startGameLogic() {
    totalCells = int(pow(cellsPerSide, 2));
    totalBombs = round(totalCells * bombsRatio);
    bombsDisplay.data = totalBombs;
    availableCells = totalCells - totalBombs;
    
    //initialize gameboard cells
    cells = new Cell[cellsPerSide][cellsPerSide];
    for (int r = 0; r < cellsPerSide; r++) {
      for (int c = 0; c < cellsPerSide; c++) {
        cells[r][c] = new Cell(gameBoardX + c * cellSize, gameBoardY + r * cellSize, cellSize, cellSize, Palette.main, r, c); 
      }
    }
    
    //set a defined amount of cells as bombs
    bombIndices = generateNonRepeatingRandoms(0, totalCells, totalBombs);
    
    for (int i : bombIndices) {
      cells[int(float(i) / cellsPerSide)][int(float(i) % cellsPerSide)].isBomb = true;
    } 
  }
  
  void restartGame() {
    startedGame = false;
    
    gameOver = false;
    victory = false;
    startGameLogic();
  }
}
