void AdvButton(int X, int Y, int W, int H) {
  pushStyle();
  if (advanced) {
    fill(255, 0, 50);
  } else {
    fill(100);
  }
  noStroke();
  rect(X, Y, W, H);
  if (mousePushed&&mouseX>X&&mouseX<X+W&&mouseY>Y&&mouseY<Y+H) {
    advanced=!advanced;
  }
  popStyle();
}
boolean enableButton(boolean isEnabled, int x, int y, int w, int h) {
  boolean en=isEnabled;
  pushStyle();
  noStroke();
  if (!isEnabled) {
    fill(255, 0, 0);
  } else {
    fill(55, 0, 0);
  }
  rect(x, y, w/2, h);
  if (isEnabled) {
    fill(0, 255, 0);
  } else {
    fill(0, 55, 0);
  }
  rect(x+w/2, y, w/2, h);
  if (mousePushed&&mouseX>x&&mouseY>y&&mouseX<x+w/2&&mouseY<y+h) {
    en=false;
  }
  if (mousePushed&&mouseX>x+w/2&&mouseY>y&&mouseX<x+w&&mouseY<y+h) {
    en=true;
  }
  popStyle();
  return en;
}
class Button {
  int x;
  int y;
  int w;
  int h;
  color c;
  boolean l;
  String msg;
  boolean t=false;
  boolean lp=false;
  boolean JP=false;
  Button(int X, int Y, int W, int H, color C, boolean L, String MSG) {
    x=X;
    y=Y;
    w=W;
    h=H;
    c=C;
    l=L;
    msg=MSG;
  }
  boolean display(boolean v) {
    t=v;
    pushStyle();
    strokeWeight(4);
    stroke(c);
    textLeading(15);
    JP=false;
    if (mouseX>x&&mouseX<x+w&&mouseY>y&&mouseY<y+h&&mousePressed) {
      stroke(red(c)/2, green(c)/2, blue(c));
      if (lp==false) {
        if (l) {
          t=!t;
          JP=true;
        } else {
          t=true;
        }
      }
      lp=true;
    } else {
      if (!l) {
        t=false;
      }
      lp=false;
    }
    if (t) {
      fill(255);
    } else {
      fill(0);
    }
    rect(x, y, w, h);
    textSize(14);
    fill(155);
    text(msg, x, y, w, h);
    popStyle();
    return t;
  }
}
