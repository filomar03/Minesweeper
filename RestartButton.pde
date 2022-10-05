class RestartButton extends Button {
  PImage btnImage = ImageLoader.normalSmileImg;
  
  RestartButton(int x, int y, int bWidth, int bHeight, color bColor) {
    super(x, y, bWidth, bHeight, bColor);
  }
  
  @Override
  void show() {
    if (manager.victory)
      btnImage = ImageLoader.winSmileImg;
    else if (manager.gameOver)
      btnImage = ImageLoader.loseSmileImg;
    else
      btnImage = ImageLoader.normalSmileImg;
      
    super.show();
    manager.drawShadows(x, y, bWidth, bHeight, manager.shadowSize, Palette.light, Palette.dark);
    image(btnImage, x + bWidth / 2, y + bHeight / 2, bWidth / 3 * 2, bHeight / 3 * 2);
  }
  
  @Override
  void onClick() {
    manager.restartGame(); 
  }
}
