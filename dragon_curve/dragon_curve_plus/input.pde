void mousePressed() {
  if (!intro) {
    mx1 = mouseX;
    my1 = mouseY;
  }
}

void mouseReleased() {
  if (!intro) {
    mx2 = mouseX;
    my2 = mouseY;
    w += (mx2-mx1);
    h += (my2-my1);
    fullDisplay();
  }
}

void keyPressed() {
  active = true;

  if (mode1 && (key == 'a' || key == 'A')) {
    alternating = !alternating;
    alt = true;
  }
  if (key == 'r' || key == 'R') {
    if (!intro) {
      intro = true;
      alt = true;
      out = "R";
    } else if(mode1) {
      out+="R";
    }
  }
  if (key == 'q' || key == 'Q' || keyCode == ESC) {
    exit();
  }

  if (intro) {
    if(keyCode == LEFT) {
      alt = true;
      if(mode1) {
        mode1 = false;
        mode2 = false;
        mode3 = true;
      } else if(mode2) {
        mode1 = true;
        mode2 = false;
        mode3 = false;
      } else if(mode3) {
        mode1 = false;
        mode2 = true;
        mode3 = false;
      }
    }
    if(keyCode == RIGHT) {
      alt = true;
      if(mode1) {
        mode1 = false;
        mode2 = true;
        mode3 = false;
      } else if(mode2) {
        mode1 = false;
        mode2 = false;
        mode3 = true;
      } else if(mode3) {
        mode1 = true;
        mode2 = false;
        mode3 = false;
      }
    }
    if (keyCode == BACKSPACE && out.length()>0) {
      temp = "";
      for (int i = 0; i<out.length()-1; i++) {
        temp += (out.charAt(i)+"");
      }
      out = "";
      out += temp;
    }
    if (key == '\n' && out.length()>0) {
      intro = false;
      background(0);
      w = width/2;
      h = height/2;
      sp = height/20;
      origLength = out.length();
      introDone = true;
    }
    if (key == '1') {
      out+="1";
    }
    if (key == '2') {
      out+="2";
    }
    if (key == '3') {
      out+="3";
    }
    if (key == '4' && (mode1||mode3)) {
      out+="4";
    }
    if (key == '5' && mode3) {
      out+="5";
    }
    if (key == '6' && mode3) {
      out+="6";
    }
    if ((key == 'd' || key == 'D')&&mode1) {
      out+="D";
    }
    if ((key == 'u' || key == 'U')&&mode1) {
      out+="U";
    }
    if ((key == 'l' || key == 'L')&&mode1) {
      out+="L";
    }
    //
  } else {
    if (keyCode == UP) {
      generateNext();
      C = random(1);
    }
    if (keyCode == DOWN) {
      generatePrev();
      C = random(1);
    }
    if (key == ' ') {
      dispLen = !dispLen;
      if (!dispLen) {
        fullDisplay();
      }
    }
    if (key == 'z') {
      zoom(1.25);
      fullDisplay();
    }
    if (key == 'x') {
      zoom(0.8);
      fullDisplay();
    }
    if (key == 'c') {
      w = width/2;
      h = height/2;
      fullDisplay();
    }
  }
}
