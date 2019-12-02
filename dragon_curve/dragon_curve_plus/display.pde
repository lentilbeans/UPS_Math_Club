void display() {
  background(0);
  initialize();
  stroke(255);
  c = C;
  index = 0;
  percent = 0;
}

void loadingBar(float p) {
  translate(-w, -h);
  noStroke();
  fill(0);
  rect(0, height*0.95, width, height);
  rect(width-0.05*height, 0, width, height);
  rect(0, 0, width, 0.05*height);
  rect(0, 0, 0.05*height, height);
  fill(C, 1, 1);
  rect(0, height*(1-border), map(p, 0, width/peri, 0, width), border*height);
  rect(width-border*height, height, border*height, map(p, width/peri, 0.5, 0, -height));
  rect(width, 0, map(p, 0.5, 1-height/peri, 0, -width), border*height);
  rect(0, 0, border*height, map(p, 1-height/peri, 1, 0, height));
  translate(w, h);
}

void fullDisplay() {
  translate(w, h);
  display(); 
  for (int i = 0; i<out.length(); i++) {
    T(out.charAt(i)+"");
    stroke(c, 1, 1);
    line(x1, y1, x2, y2);
    x1 = x2;
    y1 = y2;
    c = (c+0.0001)%1;
  }
  percent = 0;
  loadingBar(percent);
  disp = false;
  done = true;
}

void initialize() {
  x1 = 0;
  y1 = 0;
  x2 = 0;
  y2 = 0;
}

void zoom(float p) {
  sp*=p;
  w+=(w-width/2)*(p-1);
  h+=(h-height/2)*(p-1);
}
