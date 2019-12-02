String out = "R", temp = "";
float x1, x2, y1, y2, 
  mx1, mx2, my1, my2, 
  w, h, 
  c = random(1), C = random(1), 
  percent = 0;
float sp, peri, border = 0.03; //spacing, perimeter, border-percent
int index = 0;
int origLength = out.length();

boolean active = true, done = true, 
  disp = true, intro = true, introDone = false, 
  genNext = false, genPrev = false, dispLen = false, 
  alt = true, alternating = false, 
  mode1 = true, mode2 = false, mode3 = false;

void setup() {
  fullScreen();
  peri = 2*width+2*height;
  initialize();
  colorMode(HSB, 1);
  textFont(createFont("Cambria", width/50));
  textAlign(CENTER, CENTER);
  w = width/2;
  h = height/2;
  sp = h/10;
  strokeWeight(5);
  background(0);
}

void draw() {
  if (intro) {
    translate(width/2, height/2);
    background(0);
    fill(1);    
    if (mode1) {
      text("MODE 1: SQUARE\n---\nType R, L, U, D, 1, 2, 3, or 4 here:\n"
        +out+"\n\n\n(press Q to quit)"
        +"\nAlternating: "+alternating
        +"\n\nHow to adjust: Dragging, A, Z, X, R, UP, DOWN", 0, 0);
    } else if(mode2) {
      text("MODE 2: TRIANGLE\n---\nType 1, 2, or 3 here:\n"
        +out+"\n\n\n(press Q to quit)"
        +"\nAlternating: "+alternating
        +"\n\nHow to adjust: Dragging, A, Z, X, R, UP, DOWN", 0, 0);
    } else if(mode3) {
      text("MODE 3: HEXAGON\n---\nType 1, 2, 3, 4, 5, or 6 here:\n"
        +out+"\n\n\n(press Q to quit)"
        +"\nAlternating: "+alternating
        +"\n\nHow to adjust: Dragging, A, Z, X, R, UP, DOWN", 0, 0);
    }
  } else if (introDone) {
    fullDisplay();
    introDone = false;
  } else if (active) {
    translate(w, h);  
    if (done) {
      active = false;
    } else if (disp) {   
      for (int i = 0; i<min(out.length()/50.0, 4000)&&index<out.length(); i++) {
        T(out.charAt(index)+"");
        stroke(c, 1, 1);
        line(x1, y1, x2, y2);
        x1 = x2;
        y1 = y2;
        c = (c+0.0001)%1;
        index++;
        percent += 1.0/out.length();
      }
      loadingBar(percent);
      if (index>=out.length()) {
        percent = 0;
        index = 0;
        loadingBar(percent);
        disp = false;
        done = true;
      }
      //
    } else if (genNext) {
      for (int i = 0; i<min(out.length()/50.0, 4000)&&index>=0; i++) {
        temp+=convert(out.charAt(index)+"");
        index--;
        percent += 1.0/out.length();
      }
      loadingBar(percent);
      if (index<0) {
        genNext = false;
        done = false;
        disp = true;
        if (alternating) {
          alt = !alt;
        }
        display();
        out += temp;
        zoom(0.8);
        index = 0;
      }
      //
    } else if (genPrev) {
      for (int i = 0; i<min(out.length()/50.0, 4000)&&index<out.length()/2; i++) {
        temp+=(out.charAt(index)+"");
        index++;
        percent += 0.5/out.length();
      }
      loadingBar(percent);
      if (index>=out.length()/2) {
        if (alternating) {
          alt = !alt;
        }
        genPrev = false;
        done = false;
        disp = true;
        display();
        out = "";
        out += temp;
        zoom(1.25);
        index = 0;
      }
      //
    }
    //
    if (dispLen) {
      fill(1);
      text(out.length(), 0, 0);
    }
    //
  }
}
