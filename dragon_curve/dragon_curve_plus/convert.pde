String t(String s) {
  if (mode1) {
    //MODE 1
    if (s.equalsIgnoreCase("L")) {
      return "D";
    } else if (s.equalsIgnoreCase("D")) {
      return "R";
    } else if (s.equalsIgnoreCase("R")) {
      return "U";
    } else if (s.equalsIgnoreCase("U")) {
      return "L";
    } else if (s.equalsIgnoreCase("1")) {
      return "4";
    } else if (s.equalsIgnoreCase("2")) {
      return "1";
    } else if (s.equalsIgnoreCase("3")) {
      return "2";
    } else if (s.equalsIgnoreCase("4")) {
      return "3";
    }
    //
  } else if (mode2) {
    //MODE 2
    if (s.equalsIgnoreCase("1")) {
      return "2";
    } else if (s.equalsIgnoreCase("2")) {
      return "3";
    } else if (s.equalsIgnoreCase("3")) {
      return "1";
    }
    //
  } else if (mode3) {
    //MODE 3
    if (s.equalsIgnoreCase("1")) {
      return "2";
    } else if (s.equalsIgnoreCase("2")) {
      return "3";
    } else if (s.equalsIgnoreCase("3")) {
      return "4";
    } else if (s.equalsIgnoreCase("4")) {
      return "5";
    } else if (s.equalsIgnoreCase("5")) {
      return "6";
    } else if (s.equalsIgnoreCase("6")) {
      return "1";
    }
    //
  }
  return "";
}
String convert(String s) {
  if (alt) {
    return t(s);
  } else {
    return t(t(t(s)));
  }
}
void T(String s) {
  if (mode1) {
    //MODE 1
    if (s.equalsIgnoreCase("L")) {
      x2 = x1-sp;
    } else if (s.equalsIgnoreCase("D")) {
      y2 = y1+sp;
    } else if (s.equalsIgnoreCase("R")) {
      x2 = x1+sp;
    } else if (s.equalsIgnoreCase("U")) {
      y2 = y1-sp;
    } else if (s.equalsIgnoreCase("1")) {
      x2 = x1-sp;
      y2 = y1-sp;
    } else if (s.equalsIgnoreCase("2")) {
      x2 = x1+sp;
      y2 = y1-sp;
    } else if (s.equalsIgnoreCase("3")) {
      x2 = x1+sp;
      y2 = y1+sp;
    } else if (s.equalsIgnoreCase("4")) {
      x2 = x1-sp;
      y2 = y1+sp;
    }
    //
  } else if (mode2) {
    //MODE 2
    if (s.equalsIgnoreCase("1")) {
      x2 = x1+sp;
    } else if (s.equalsIgnoreCase("2")) {
      x2 = x1+cos(TWO_PI/3)*sp;
      y2 = y1-sin(TWO_PI/3)*sp;
    } else if (s.equalsIgnoreCase("3")) {
      x2 = x1+cos(TWO_PI/3)*sp;
      y2 = y1+sin(TWO_PI/3)*sp;
    }
    //
  } else if (mode3) {
    //MODE 3
    if (s.equalsIgnoreCase("1")) {
      x2 = x1+cos(PI/3)*sp;
      y2 = y1-sin(PI/3)*sp;
    } else if (s.equalsIgnoreCase("2")) {
      x2 = x1+cos(TWO_PI/3)*sp;
      y2 = y1-sin(TWO_PI/3)*sp;
    } else if (s.equalsIgnoreCase("3")) {
      x2 = x1-sp;
    } else if (s.equalsIgnoreCase("4")) {
      x2 = x1+cos(TWO_PI/3)*sp;
      y2 = y1+sin(TWO_PI/3)*sp;
    } else if (s.equalsIgnoreCase("5")) {
      x2 = x1+cos(PI/3)*sp;
      y2 = y1+sin(PI/3)*sp;
    } else if (s.equalsIgnoreCase("6")) {
      x2 = x1+sp;
    }
    //
  }
}
