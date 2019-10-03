//todo write run()
class OnScreenJoystick {
  private int XPos;
  private int YPos;
  private int Width;
  private int Height;
  private color BackgroundColor;
  private color ForegroundColor;
  private float x=0;
  private float y=0;
  OnScreenJoystick(int _XPos, int _YPos, int _Width, int _Height, color _BackgroundColor, color _ForgroundColor) {
    XPos=_XPos;
    YPos=_YPos;
    Width=_Width;
    Height=_Height;
    BackgroundColor=_BackgroundColor;
    ForegroundColor=_ForgroundColor;
  }
  PVector run() {
    pushStyle();
    noStroke();
    fill(BackgroundColor);
    rect(XPos, YPos, Width, Height);
    fill(ForegroundColor);
    strokeWeight(1);
    stroke(255);
    if (mousePressed&&mouseX>XPos&&mouseY>YPos&&mouseX<XPos+Width&&mouseY<YPos+Height) {
      x=map(mouseX-XPos, 0, Width, -1.00, 1.00);
      y=map(mouseY-YPos, 0, Height, -1.00, 1.00);
      fill(ForegroundColor, 180);
    } else {
      x=0;
      y=0;
    }
    line(map(x, -1, 1, 0, Width)+XPos, YPos, map(x, -1, 1, 0, Width)+XPos, Height+YPos);
    line(XPos, map(y, -1, 1, 0, Height)+YPos, Width+XPos, map(y, -1, 1, 0, Height)+YPos );
    ellipse(map(x, -1, 1, 0, Width)+XPos, map(y, -1, 1, 0, Height)+YPos, Width/20, Width/20);
    popStyle();
    return new PVector(x, -y);
  }
}
