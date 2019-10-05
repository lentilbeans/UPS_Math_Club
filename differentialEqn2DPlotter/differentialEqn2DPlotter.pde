float dt = 0.001;
float mu = -1;
float alpha = 1.0, beta = 1.0, 
  delta = 2.0, gamma = 0.5;
float x, y, dx, dy;
//BOUNDS! DON'T FORGET, QUINTIN.
// OH YEAH TOTALLY, I WON'T FORGET.
// THX.
float xL = -15, xR = 15, 
  yB = -10, yT = 10;
float[] xVals, yVals;
float[] cols;
float bd = 14;
int points = 40, iterations = 100;

void setup() {
  size(1000, 500);
  colorMode(HSB, 1);
  background(0);
  x = 0;
  y = 0;
  dx = 0;
  dy = 0;

  xVals = new float[points];
  yVals = new float[points];
  cols = new float[points];

  for (int i = 0; i<points; i++) {
    initialize(i);
  }
}

void draw() {
  for (int j = 0; j<iterations; j++) {
    for (int i = 0; i<points; i++) {
      dx = F(xVals[i],yVals[i])*dt;
      dy = G(xVals[i],yVals[i])*dt;
      xVals[i] += dx;
      yVals[i] += dy;
      if(dx*dx+dy*dy<0.0001*dt*dt) {
        initialize(i);
      }
    }
    strokeWeight(1);
    for (int i = 0; i<points; i++) {
      stroke(cols[i],1,1);
      x = map(xVals[i],xL,xR,0,width);
      y = map(yVals[i],yB,yT,height,0);
      point(x,y);
    }
  }

  restart();
}

float F(float X, float Y) {
  return Y;
}

float G(float X, float Y) {
  return -0.001*X*X*cos(X)-1+X*sin(Y);
}

void restart() {
  for(int i = 0; i<points; i++) {
    if(xVals[i]<xL-bd || xVals[i]>xR+bd || yVals[i]<yB-bd || yVals[i]>yT+bd) {
      initialize(i);
    }
  }
}

void initialize(int i) {
  xVals[i] = random(xL, xR);
  yVals[i] = random(yB, yT);
  cols[i] = random(1);
}

void mousePressed() {
  int index = floor(random(points));
  xVals[index] = map(mouseX,0,width,xL,xR);
  yVals[index] = map(mouseY,height,0,yB,yT);
}
