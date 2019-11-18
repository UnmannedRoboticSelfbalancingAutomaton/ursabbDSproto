import ketai.ui.*;
class Slider {
  float x;
  float y;
  float w;
  color c;
  String t;
  float val;
  float min;
  float max;
  boolean m=false;
  boolean n=false;
  String valStr="";
  float size=10.0;
  Slider(float X, float Y, float W, color C, String T, float VAL, float MIN, float MAX, float Size) {
    x=X;
    y=Y;
    w=W;
    c=C;
    t=T;
    val=VAL;
    min=MIN;
    max=MAX;
    size=Size;
  }
  float display(float V) {
    pushStyle();
    val=V;
    noStroke();
    fill(red(c)/1.5, green(c)/1.5, blue(c)/1.5);
    rect(x-5, y-2, w+10, 4);
    textSize(13);
    fill(c);
    text(t, x+w+size, y+3);
    if (!n) {
      text((nf(val, 2, 4)), x-70, y+3);
    }
    if (mouseX>=x-73&&mouseX<=x-10&&mouseY<=y+size/2&&mouseY>=y-size/2&&mousePushed) {
      n=true;
      valStr="";
      try {
        KetaiKeyboard.show(ursabbDSproto.this);
      }
      catch(NoSuchMethodError e) {
      }
    } else if (n==true&&(mousePushed||(keyPressed&&key==ENTER))) {
      n=false;
      try {
        KetaiKeyboard.hide(ursabbDSproto.this);
      }
      catch(NoSuchMethodError e) {
      }
      if (float(valStr)==float(valStr)) {//NaN check!
        val=float(valStr);
      }
    }
    if (n) {
      text(valStr, x-70, y+3);
      stroke(red(c)/2, green(c)/2, blue(c)/2);
      strokeWeight(1);
      noFill();
      rect(x-70, y-size/2, 65, size);
      if (((key==45||key ==46||(key>=48&&key<=57)) && (key != CODED)&&keyPushed&&textWidth(valStr)<60)) {
        valStr+=key;
      }
      if (keyPushed&&key==BACKSPACE&&valStr.length()>0) {
        valStr=valStr.substring(0, valStr.length()-1);
      }
    }
    noStroke();
    fill(255);
    if (mousePushed) {
      if ((mouseX>=x-5&&mouseX<=x+w+5&&mouseY>=y-size/2&&mouseY<=y+size/2)) {
        m=true;
      } else {
        m=false;
      }
    }
    if (!mousePressed) {
      m=false;
    }
    if (m) {
      val=constrain(map(mouseX-x, 0, w, min, max), min, max);
      fill(100);
    }
    rect(x-5+constrain(map(val, min, max, 0, w), 0, w), y-5, size/2, size/2);  
    popStyle();
    return val;
  }
}
