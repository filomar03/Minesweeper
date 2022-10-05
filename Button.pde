class Button {
  int x, y, bWidth, bHeight;
  color bColor;
  
  Button(int x, int y, int bWidth, int bHeight, color bColor) {
    this.x = x - bWidth / 2;
    this.y = y - bHeight / 2;
    this.bWidth = bWidth;
    this.bHeight = bHeight;
    this.bColor = bColor;
  }
  
  void show() {
    fill(bColor);
    rect(x, y, bWidth, bHeight);
  }
  
  void onClick() {
    println("click : " + millis()); 
  }
  
  void handleClick() {
    if ((MouseCoords.x >= x && MouseCoords.x < x + bWidth) && (MouseCoords.y >= y && MouseCoords.y < y + bHeight ) && MouseCoords.isClicking && MouseCoords.leftClick) {
      MouseCoords.isClicking = false;
      MouseCoords.leftClick = false;
      onClick();
    }
  }
}
