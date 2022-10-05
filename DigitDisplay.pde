class DigitDisplay {
  int x, y, maxDigits, tHeight, tBorder;
  color backgroundColor, textColor;
  int data = 0;
  
  DigitDisplay (int x, int y, int maxDigits, int tHeight, int tBorder, color backgroundColor, color textColor) {
    this.x = x;
    this.y = y;
    this.maxDigits = maxDigits;
    this.tHeight = tHeight;
    this.tBorder = tBorder;
    this.backgroundColor = backgroundColor;
    this.textColor = textColor;
  }
  
  void show() {
    String dataString = nf(constrain(data, 0, int(pow(10, maxDigits) - 1)), maxDigits);
    textSize(tHeight / 3 * 2);
    
    fill(backgroundColor);
    rect(x, y - tHeight / 2, textWidth(nf(0, maxDigits)) + tBorder * 2, tHeight);
    
    fill(textColor);
    text(dataString, x + tBorder, y + textAscent() / 2);
  }
}
