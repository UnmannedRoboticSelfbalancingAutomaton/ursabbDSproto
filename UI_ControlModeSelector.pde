int ControlModeSelector(int CtrlModeVal, int XPos, int YPos, int Width, int Height, String[] Modes, boolean[] Ok) {
  int mode=CtrlModeVal;
  if (Modes.length!=Ok.length) {
    return 0;
  } else {
    pushStyle();
    colorMode(HSB);
    noStroke();
    if (mousePushed&&mouseX>XPos&&mouseY>YPos&&mouseX<XPos+Width&&mouseY<YPos+Height/Modes.length) {
      mode=0;
    }
    if (mode==0) {
      fill(0, 255, 255);
    } else {
      fill(0, 255, 185);
    }
    rect(XPos, YPos, Width, Height/Modes.length);
    if (mode==0) {
      fill(255);
    } else {
      fill(0);
    }
    textSize(Width/10);
    text("STOP", XPos, YPos, Width, Height/Modes.length);
    for (int i=1; i<=Modes.length; i++) {
      if (Ok[i-1]) {
        if (mousePushed&&mouseX>XPos&&mouseY>YPos+Height*i/Modes.length&&mouseX<XPos+Width&&mouseY<YPos+Height*i/Modes.length+Height/Modes.length) {
          mode=i;
        }
        if (mode==i) {
          fill(map(i, 0, Modes.length, 0, 220), 255, 255);
        } else {
          fill(map(i, 0, Modes.length, 0, 220), 255, 185);
        }
      } else {
        fill(map(i, 0, Modes.length, 0, 220), 2, 50);
      }
      rect(XPos, YPos+Height*i/Modes.length, Width, Height/Modes.length);
      if (mode==i) {
        fill(255);
      } else {
        fill(0);
      }
      textSize(Width/10);
      text(Modes[i-1], XPos, YPos+Height*i/Modes.length, Width, Height/Modes.length);
    }
    popStyle();
    return mode;
  }
}
