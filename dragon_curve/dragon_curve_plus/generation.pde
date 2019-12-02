void generateNext() {
  active = true;
  done = false;
  genNext = true;
  temp = "";
  percent = 0;
  index = out.length()-1;
}

void generatePrev() {
  active = true;
  done = false;
  if (out.length()>origLength) {
    genPrev = true;
    temp = "";
    percent = 0;
    index = 0;
  }
}
