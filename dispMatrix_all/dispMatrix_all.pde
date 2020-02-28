MatrixSet MS;
IMatrix A, mult;
int selectedTL = -1, selectedTR = -1, 
  selectedBR = -1, selectedBL = -1, 
  selectedRes = -1;
int[] indexSet = {-1, -1};
boolean elementSelect;
boolean event;
String IN;

void setup() {  
  fullScreen();
  colorMode(HSB, 1);
  textAlign(CENTER, CENTER);

  MS = new MatrixSet();

  reInit();
  background(0);

  event = false;
}

void draw() {
  if (event) {
    background(0);
    MS.disp();
    if (elementSelect) {
      fill(1);
      stroke(0.8);
      textSize(30);
      rect(width/2-200, height/2-50, 400, 100);
      fill(0);
      text(IN, width/2, height/2);
    }
    if (selectedTR>-1) {
      MS.get(selectedTR).opList();
    }
    event = false;
  }
}

void mouseMoved() {
  event = true;
}

void keyPressed() {
  if (key == ' ') {
    MS.randLoc();
  }

  if (keyCode == UP) {
    int k = MS.detectOver();
    if (k > -1) {
      MS.get(k).expUp();
    }
  }

  if (keyCode == DOWN) {
    int k = MS.detectOver();
    if (k > -1) {
      MS.get(k).expDown();
    }
  }

  if (keyCode == DELETE || key == '-') {
    int k = MS.detectOver();
    if (k > -1) {
      MS.remove(k);
    }
    reInit();
  }

  if (key == 'r' || key == 'R') {
    int k = MS.detectOver();
    if (k > -1) {
      MS.get(k).randInt(-10, 10);
    }
  }
  if (key == 's' || key == 'S') {
    MS.split();
  }
  if (key == 'a' || key == 'A') {
    MS.augment();
  }
  if (key == 'i' || key == 'I') {
    int k = MS.detectOver();
    if (k > -1) {
      MS.get(k).setI();
    }
  }
  if (key == 'o' || key == 'O') {
    int k = MS.detectOver();
    if (k > -1) {
      MS.get(k).setO();
    }
  }
  if (key == 'd' || key == 'D') {
    int k = MS.detectOver();
    if (k > -1) {
      MS.duplicate(k);
    }
  }

  if (elementSelect && ((keyCode>=45 && keyCode<58) || keyCode == 88)) {
    if (keyCode == 46) {
      if (IN.indexOf(".") == -1) {
        IN += ".";
      }
    } else if (keyCode == 45) {
      if (!IN.equals("")) {
        if (IN.substring(0, 1).equals("-")) {
          IN = IN.substring(1);
        } else {
          IN = "-"+IN;
        }
      }
    } else if (keyCode == 88) {
      IN += "*";
    } else {
      IN += ""+char(keyCode);
    }
  }

  if (key == 'c' || key == 'C') {
    MS.add(new IMatrix(2).I().cast());
    MS.get(MS.length-1).setPos(mouseX, mouseY);
  }

  if (key == 'u' || key == 'U') {
    int k = 0; 
    k = MS.detectOver();
    if (k>-1) {
      MS.get(k).unlink();
    }
  }

  if (key == ENTER) {
    if (!IN.equalsIgnoreCase("")) {
      MS.get(indexSet[0]).set(indexSet[1], parse(IN));
      elementSelect = false;
      IN = "";
    }
  }

  if (key == BACKSPACE) {
    if (IN.length()>0) {
      IN = IN.substring(0, IN.length()-1);
    }
  }

  event = true;
}

void mousePressed() {
  selectedRes = MS.detectResCorner();
  selectedTL = MS.detectCornerTL();
  selectedTR = MS.detectCornerTR();
  selectedBR = MS.detectCornerBR();
  indexSet = MS.detectElement();
  if (indexSet[0] > -1) {
    elementSelect = true;
    MS.ratl();
    IN = ""+MS.get(indexSet[0]).get(indexSet[1]);
  } else {
    elementSelect = false;
    IN = "";
  }
  if (selectedRes > -1) {
    if (MS.get(selectedRes).resultMat != null) {
      MS.add(MS.get(selectedRes).resultMat);
      MS.get(selectedRes).resetOp();
    }
  }

  event = true;
}

void mouseReleased() {
  selectedTL = -1;
  MS.link();

  event = true;
}

void mouseDragged() {
  if (selectedTL>-1) {
    MS.get(selectedTL).posX += (mouseX-pmouseX);
    MS.get(selectedTL).posY += (mouseY-pmouseY);
  }
  if (selectedBR>-1) {
    MS.get(selectedBR).setDimFromPos(mouseX, mouseY);
  }
  event = true;
}

void reInit() {
  selectedTL = -1;
  selectedTR = -1;
  selectedBR = -1;
  selectedBL = -1;
  selectedRes = -1;

  IN = "";
  indexSet[0] = -1;
  indexSet[1] = -1;

  elementSelect = false;
  event = true;
}

///////////////////////////

class IMatrix extends Matrix {
  float posX, posY, wid, hgt;
  final float BRACKET = height*0.008;
  final float SCALE = height*0.07;
  final float MATRIX_SPACE = height*0.028;
  final float DETECT = height*0.01;

  boolean multMode, addMode, subMode, divMode;
  IMatrix lLink, rLink, resultMat;
  String rightOperation = "";
  int exponent;
  String[] rightOps = {"-1", "RREF", "REF", 
    "·", "÷", "+", "-", 
    "^", "T", "det", "NONE"};
  String[] rightOpsUP = {"-1", "RREF", "REF", "T", "det", "^"};
  String[] rightOpsMID = {"·", "÷", "+", "-"};                    
  boolean leftLinked, rightLinked;

  IMatrix(int m, int n) {
    super(m, n);
    initialize();
  }

  IMatrix(int m) {
    super(m);
    initialize();
  }

  void setPos(float X, float Y) {
    posX = X;
    posY = Y;
    if (rightLinked) {
      rLink.setPos(posX+wid+MATRIX_SPACE, posY+hgt/2-rLink.hgt/2);
    }
  }

  void setPos(IMatrix Mat) {
    posX = Mat.posX;
    posY = Mat.posY;
    if (rightLinked) {
      rLink.setPos(posX+wid+MATRIX_SPACE, posY+hgt/2-rLink.hgt/2);
    }
  }

  void setPos(IMatrix Mat, int k) {
    posX = Mat.posX+Mat.wid*k*1.2/Mat.n;
    posY = Mat.posY;
    if (rightLinked) {
      rLink.setPos(posX+wid+MATRIX_SPACE, posY+hgt/2-rLink.hgt/2);
    }
  }

  void chgDim(int dN, int dM) {
    super.chgDim(dN, dM);
    wid = SCALE*n;
    hgt = SCALE*m;
  }

  void setDim(int N, int M) {
    if (N<1 || M<1) {
      return;
    } else {
      chgDim(N, M);
    }
  }

  void setDim(int N) {
    setDim(N, N);
  }

  void setDimFromPos(float X, float Y) {
    setDim(round(constrain((X - posX) / SCALE, 1, 9)), 
      round(constrain((Y - posY) / SCALE, 1, 9)));
  }

  IMatrix op(IMatrix Mat) {
    if (contains(rightOperation, rightOpsMID)) {
      if (!leftLinked) {
        if (rightOperation.equalsIgnoreCase("·")) {
          return this.mult(Mat).cast();
        }
        if (rightOperation.equalsIgnoreCase("÷")) {
          return this.div(Mat).cast();
        }
        if (rightOperation.equalsIgnoreCase("+")) {
          return this.add(Mat).cast();
        }
        if (rightOperation.equalsIgnoreCase("-")) {
          return this.sub(Mat).cast();
        }
      } else {
        if (rightOperation.equalsIgnoreCase("·")) {
          return op(this).mult(Mat).cast();
        }
        if (rightOperation.equalsIgnoreCase("÷")) {
          return op(this).div(Mat).cast();
        }
        if (rightOperation.equalsIgnoreCase("+")) {
          return op(this).add(Mat).cast();
        }
        if (rightOperation.equalsIgnoreCase("-")) {
          return op(this).sub(Mat).cast();
        }
      }
    }    
    return this.O().cast();
  }

  void expUp() {
    exponent = min(10, exponent+1);
  }

  void expDown() {
    exponent = max(0, exponent-1);
  }

  void opList() {
    int len = rightOps.length;
    float x, y, w, h;
    w = SCALE*0.5;
    h = SCALE*0.3;
    x = posX+wid-w/2;
    textSize(SCALE*0.15);
    noStroke();
    for (int i = 0; i<len; i++) {
      y = posY-i*h-h/2;
      if (abs(x-mouseX)<w/2 && abs(y-mouseY)<h/2) {
        fill(0.7);
        rightOperation = rightOps[i];
        if (rightOperation.equalsIgnoreCase("NONE")) {
          rightOperation = "";
        }
      } else {
        fill(1);
      }
      rect(x-w/2, y-h/2, w, h);
      fill(0);
      text(rightOps[i], x, y);
    }
  }

  void resetOp() {
    rightOperation = "";
    resultMat = null;
    unlinkRight();
  }

  private void initialize() {
    posX = width*(0.2+random(0.6));
    posY = height*(0.2+random(0.6));
    wid = SCALE*n;
    hgt = SCALE*m;

    leftLinked = false;
    rightLinked = false;
  }

  boolean isExponent() {
    return rightOperation.equalsIgnoreCase("^");
  }

  void disp() {
    fill(0);
    noStroke();
    rect(posX, posY, wid, hgt);

    //bracket
    stroke(1);
    if (rightLinked) {
      stroke(1, 1, 1);
    }
    strokeWeight(2);
    line(posX, posY, posX, posY+hgt);
    line(posX, posY, posX+BRACKET, posY);
    line(posX, posY+hgt, posX+BRACKET, posY+hgt);
    line(posX+wid, posY, posX+wid, posY+hgt);
    line(posX+wid, posY, posX+wid-BRACKET, posY);
    line(posX+wid, posY+hgt, posX+wid-BRACKET, posY+hgt);

    //elements
    textSize(SCALE*0.2);
    fill(1);
    noStroke();
    float x, y;
    for (int i = 0; i<n; i++) {
      for (int j = 0; j<m; j++) {
        x = wid/2.0/n+map(i, 0, n, posX, posX+wid);
        y = hgt/2.0/m+map(j, 0, m, posY, posY+hgt);
        text(rationalize(M[i][j]), x, y);
      }
    }

    //operation
    textSize(SCALE*0.25);
    textAlign(LEFT, CENTER);
    fill(1);
    if (isExponent()) {
      text(exponent, posX+wid+BRACKET, posY-BRACKET/2);
    } else if (contains(rightOperation, rightOpsUP)) {
      text(rightOperation, posX+wid+BRACKET, posY-BRACKET/2);
    } else if (contains(rightOperation, rightOpsMID)) {
      text(rightOperation, posX+wid+BRACKET, posY+hgt/2);
    }
    textAlign(CENTER, CENTER);

    if (contains(rightOperation, rightOpsUP)) {
      if (rightOperation.equalsIgnoreCase("^")) {
        text("=", posX+wid+7*BRACKET, posY+hgt/2);
        resultMat = this.pow(exponent).cast();
        resultMat.setPos(posX+wid+9*BRACKET, posY+hgt/2-resultMat.hgt/2);
        resultMat.disp();
      } else if (rightOperation.equalsIgnoreCase("det")) {
        text("= "+this.det(), posX+wid+7*BRACKET, posY+hgt/2);
      } else if (rightOperation.equalsIgnoreCase("RREF")) {
        text("=", posX+wid+7*BRACKET, posY+hgt/2);
        resultMat = this.rref().cast();
        resultMat.setPos(posX+wid+9*BRACKET, posY+hgt/2-resultMat.hgt/2);
        resultMat.disp();
      } else if (rightOperation.equalsIgnoreCase("REF")) {
        text("=", posX+wid+7*BRACKET, posY+hgt/2);
        resultMat = this.ref().cast();
        resultMat.setPos(posX+wid+9*BRACKET, posY+hgt/2-resultMat.hgt/2);
        resultMat.disp();
      } else if (rightOperation.equalsIgnoreCase("-1")) {
        text("=", posX+wid+7*BRACKET, posY+hgt/2);
        resultMat = this.inv().cast();
        resultMat.setPos(posX+wid+9*BRACKET, posY+hgt/2-resultMat.hgt/2);
        resultMat.disp();
      } else if (rightOperation.equalsIgnoreCase("RREF")) {
        text("=", posX+wid+7*BRACKET, posY+hgt/2);
        resultMat = this.rref().cast();
        resultMat.setPos(posX+wid+9*BRACKET, posY+hgt/2-resultMat.hgt/2);
        resultMat.disp();
      } else if (rightOperation.equalsIgnoreCase("T")) {
        text("=", posX+wid+7*BRACKET, posY+hgt/2);
        resultMat = this.T().cast();
        resultMat.setPos(posX+wid+9*BRACKET, posY+hgt/2-resultMat.hgt/2);
        resultMat.disp();
      }
    } else if (leftLinked) {
      text("=", posX+wid+3*BRACKET, posY+hgt/2);
      resultMat = lLink.op(this).cast();
      resultMat.setPos(posX+wid+9*BRACKET, posY+hgt/2-resultMat.hgt/2);
      resultMat.disp();
    } else {
      resultMat = null;
    }
  }  

  void randLoc() {
    posX = width*(0.1+random(0.8));
    posY = height*(0.1+random(0.8));
  }

  boolean detectCornerTL() {
    return abs(posX+BRACKET-mouseX)<2*BRACKET && abs(posY+BRACKET-mouseY)<2*BRACKET;
  }

  boolean detectCornerTR() {
    return abs(posX+wid-BRACKET-mouseX)<2*BRACKET && abs(posY+BRACKET-mouseY)<2*BRACKET;
  }

  boolean detectCornerBR() {
    return abs(posX+wid-BRACKET-mouseX)<2*BRACKET && abs(posY+hgt-BRACKET-mouseY)<2*BRACKET;
  }

  boolean detectCornerBL() {
    return abs(posX+BRACKET-mouseX)<2*BRACKET && abs(posY+hgt-BRACKET-mouseY)<2*BRACKET;
  }

  boolean detectRightEdge() {
    return abs(posX+wid-mouseX)<MATRIX_SPACE && abs(posY+hgt/2.0-mouseY)<hgt/2.0;
  }
  boolean detectLeftEdge() {
    return abs(posX-mouseX)<MATRIX_SPACE && abs(posY+hgt/2.0-mouseY)<hgt/2.0;
  }

  boolean detectOver() {
    return abs(posX+wid/2-mouseX)<wid/2 && abs(posY+hgt/2-mouseY)<hgt/2;
  }

  int detectElement() {
    if (detectOver()) {
      int i = 0;
      float x, y;
      while (i<n*m) {
        x = wid/2.0/n+map(i%n, 0, n, posX, posX+wid);
        y = hgt/2.0/m+map(i/n, 0, m, posY, posY+hgt);
        if (abs(x-mouseX)<DETECT && abs(y-mouseY)<DETECT) {
          return i;
        }
        i++;
      }
    }
    return -1;
  }

  int detectVert() {
    if (detectOver()) {
      int i = 0;
      float x, y;
      while (i<n-1) {
        x = wid/2.0/n+map((i+0.5), 0, n, posX, posX+wid);
        if (abs(x-mouseX)<DETECT) {
          return 1+i;
        }
        i++;
      }
    }
    return -1;
  }

  float dist(IMatrix Mat) {
    return abs(posX+wid-Mat.posX)+abs(posY-Mat.posY);
  }

  void unlink() {
    if (rightLinked) {
      rLink.leftLinked = false;
      rLink.lLink = null;
    }
    if (leftLinked) {
      lLink.rightLinked = false;
      lLink.rLink = null;
    }
    rightLinked = false;
    leftLinked = false;
    rLink = null;
    lLink = null;
  }

  void unlinkRight() {
    if (rightLinked) {
      rLink.leftLinked = false;
      rLink.lLink = null;
    }
    rightLinked = false;
    rLink = null;
  }

  void unlinkLeft() {
    if (leftLinked) {
      lLink.rightLinked = false;
      lLink.rLink = null;
    }
    leftLinked = false;
    lLink = null;
  }

  void linkRight(IMatrix M) {
    rightLinked = true;
    rLink = M;
    rLink.leftLinked = true;
    rLink.lLink = this;
    rLink.setPos(posX+wid+MATRIX_SPACE, posY+hgt/2-M.hgt/2);
  }
  void linkLeft(IMatrix M) {
    leftLinked = true;
    lLink = M;
    lLink.rightLinked = true;
    lLink.rLink = this;
    lLink.setPos(posX-M.wid-MATRIX_SPACE, posY+hgt/2-M.hgt/2);
  }

  IMatrix Copy() {
    IMatrix Mat = new IMatrix(m, n);
    for (int i = 0; i<m*n; i++) {
      Mat.M[i%n][i/n] = M[i%n][i/n];
    }
    Mat.posX = posX;
    Mat.posY = posY;
    Mat.wid = wid;
    Mat.hgt = hgt;

    Mat.rightLinked = rightLinked;
    Mat.leftLinked = leftLinked;
    Mat.rLink = rLink;
    Mat.lLink = lLink;

    return Mat;
  }

  void augment(IMatrix Mat) {
    chgDim(this.n+Mat.n, this.m);
    for (int i = 0; i<Mat.n; i++) {
      for (int j = 0; j<Mat.m; j++) {
        this.M[this.n-Mat.n+i][j] = Mat.M[i][j];
      }
    }
  }

  IMatrix ratl() {
    IMatrix Mat = new IMatrix(m, n);
    for (int i = 0; i<m*n; i++) {
      Mat.M[i%n][i/n] = rational(M[i%n][i/n]);
    }
    return Mat;
  }
}

/////////////////////////////////////

class Matrix {
  // note: [n][m] for m x n matrix
  double[][] M;
  int m, n;

  Matrix(int m, int n) {
    M = new double[n][m];
    this.m = m;
    this.n = n;
  }

  Matrix(int m) {
    M = new double[m][m];
    this.m = m;
    this.n = m;
  }

  Matrix() {
    M = new double[1][1];
    this.m = 1;
    this.n = 1;
  }

  boolean isSquare() {
    return m == n;
  }

  void chgDim(int dN, int dM) {
    if (dN>=1 && dM>=1) { 
      double[][] newM = new double[dN][dM];
      for (int i = 0; i<min(this.n, dN); i++) {
        for (int j = 0; j<min(this.m, dM); j++) {
          newM[i][j] = this.M[i][j];
        }
      }
      this.M = newM;
      this.n = dN;
      this.m = dM;
    }
  }

  Matrix Copy() {
    Matrix Mat = new Matrix(m, n);
    for (int i = 0; i<m*n; i++) {
      Mat.M[i%n][i/n] = M[i%n][i/n];
    }
    return Mat;
  }

  IMatrix cast() {
    IMatrix I = new IMatrix(m, n);
    for (int i = 0; i<m*n; i++) {
      I.M[i%n][i/n] = M[i%n][i/n];
    }
    return I;
  }

  double get(int i) {
    if (i >=0 && i<n*m) {
      return M[i%n][i/n];
    }
    return 0;
  }

  void set(int i, double val) {
    if (i >=0 && i<n*m) {
      M[i%n][i/n] = val;
    }
  }

  void load(double... nums) {
    for (int i = 0; i < min(m*n, nums.length); i++) {
      M[i%n][i/n] = nums[i];
    }
  }

  void randInt(int n1) {
    for (int i = 0; i < m*n; i++) {
      M[i%n][i/n] = floor(random(n1+1));
    }
  }
  void randInt(int n1, int n2) {
    for (int i = 0; i < m*n; i++) {
      M[i%n][i/n] = int(random(n1, n2+1));
    }
  }
  void rand(double f) {
    for (int i = 0; i < m*n; i++) {
      M[i%n][i/n] = random(f);
    }
  }
  void rand(int f1, int f2) {
    for (int i = 0; i < m*n; i++) {
      M[i%n][i/n] = random(f1, f2);
    }
  }

  Matrix scl(double f) {
    Matrix Mat = new Matrix(m, n);
    for (int j = 0; j<m*n; j++) {
      Mat.M[j%n][j/n] = f*M[j%n][j/n];
    }
    return Mat;
  }
  void Scl(double f) {
    for (int j = 0; j<m*n; j++) {
      M[j%n][j/n] = f*M[j%n][j/n];
    }
  }

  Vector mult(double... fs) {
    Vector v = new Vector(fs);
    return this.mult(v);
  }

  Matrix mult(Matrix M_) {
    double sum = 0;
    if (M_.m == n) {
      Matrix Mat = new Matrix(m, M_.n);
      for (int j = 0; j<m*M_.n; j++) {
        sum = 0;
        for (int l = 0; l < n; l++) {
          sum += this.M[l][j/M_.n]*M_.M[j%M_.n][l];
        }
        Mat.M[j%M_.n][j/M_.n] = sum;
      }
      return Mat;
    } else {
      //println("WRONG DIMENSIONS");
      return O();
    }
  }

  Matrix div(Matrix M_) {
    return mult(M_.inv());
  }

  Vector mult(Vector v) {
    return new Vector(this.mult(v.V));
  }

  Matrix add(Matrix M_) {
    if (m!=M_.m || n!=M_.n) {
      println("WRONG DIMENSIONS");
      return O();
    }
    Matrix N = this;
    for (int i = 0; i<m*n; i++) {
      N.M[i/m][i%m] += M_.M[i/m][i%m];
    }
    return N;
  }

  Matrix sub(Matrix M_) {
    if (m!=M_.m || n!=M_.n) {
      //println("WRONG DIMENSIONS");
      return O();
    }
    Matrix N = this;
    for (int i = 0; i<m*n; i++) {
      N.M[i/m][i%m] -= M_.M[i/m][i%m];
    }
    return N;
  }

  boolean singular() {
    return det() == 0;
  }

  boolean invertible() {
    return det() != 0;
  }

  Matrix upTri() {
    return upTri(false);
  }  
  Matrix upTri(boolean detPreserving) {
    Matrix Mat = Copy();
    int x = 0, y = 0, ct = 0;
    while (x<n && y<m && ct<m) {
      //CREATE UPPER TRIANGULAR MATRIX VIA ROW OPERATIONS
      if (Mat.M[x][y] == 0) {
        y++;
        if (y==m) {
          x++;
          y = ct;
        }
      } else if (y <= ct) {
        ct++;
        for (int i = y+1; i<m; i++) {
          Mat.rComb(i, y, -Mat.M[x][i]*1.0/Mat.M[x][y]);
        }
        x++;
        y = ct;
      } else {
        Mat.rSwap(ct, y);
        if (detPreserving) {
          Mat.rScl(ct, -1);
        }
        y = ct;
      }
    }
    return Mat.add(O());
  }
  Matrix ref() {
    Matrix Mat = Copy();
    int x = 0, y = 0, ct = 0;
    while (x<n && y<m && ct<m) {
      if (Mat.M[x][y] == 0) {
        y++;
        if (y==m) {
          x++;
          y = ct;
        }
      } else if (y <= ct) {
        Mat.rScl(y, 1/Mat.M[x][y]);
        ct++;
        for (int i = y+1; i<m; i++) {
          Mat.rComb(i, y, -Mat.M[x][i]);
        }
        x++;
        y = ct;
      } else {
        Mat.rSwap(ct, y);
        y = ct;
      }
    }
    return Mat.add(Mat.O());
  }
  Matrix rref() {
    Matrix Mat = ref();
    int x = min(n-1, m-1), y = m-1;
    while (x>0 && y>=0) {
      if (Mat.M[x][y] == 0) {
        x++;
        if (x==n) {
          y--;
          x = min(n-1, y);
        }
      } else {
        for (int i = y-1; i>=0; i--) {
          Mat.rComb(i, y, -Mat.M[x][i]);
        }
        y--;
        x = y;
      }
    }
    return Mat.add(Mat.O());
  }
  //ROW OPERATIONS
  void rScl(int ind, double f) {
    int index = max(0, min(ind, m-1));
    for (int k = 0; k<n; k++) {
      M[k][index] *= f;
    }
  }
  void rSwap(int ind1, int ind2) {
    if (ind1==ind2) {
      return;
    }
    if (ind1<0||ind2<0||ind1>=m||ind2>=m) {
      println("INDEX OUT OF RANGE");
      return;
    }
    double[] nums = new double[n];
    for (int i = 0; i<n; i++) {
      nums[i] = M[i][ind1];
    }
    for (int i = 0; i<n; i++) {
      M[i][ind1] = M[i][ind2];
    }
    for (int i = 0; i<n; i++) {
      M[i][ind2] = nums[i];
    }
  }
  void rComb(int ind1, double f1, int ind2, double f2) {
    if (ind1<0||ind2<0||ind1>=m||ind2>=m) {
      //println("INDEX OUT OF RANGE");
      return;
    }
    if (ind1==ind2) {
      rScl(ind1, f1);
      return;
    }
    if (f2==0) {
      rScl(ind1, f1);
      return;
    }
    for (int i = 0; i<n; i++) {
      M[i][ind1] *= f1;
      M[i][ind1] += f2*M[i][ind2];
    }
  }
  void rComb(int ind1, int ind2, double f1) {
    if (f1 == 0) {
      return;
    }
    if (ind1==ind2) {
      rScl(ind1, f1);
      return;
    }
    rComb(ind1, 1, ind2, f1);
  }

  Matrix diag() {
    Matrix Mat = new Matrix(min(n, m));
    for (int i = 0; i<min(n, m); i++) {
      Mat.M[i][i] = this.M[i][i];
    }
    return Mat;
  }

  double det() {
    if (isSquare()) {
      Matrix Mat = upTri(true);
      double D = 1;
      for (int i = 0; i<n; i++) {
        D *= Mat.M[i][i];
      }
      if (D==0) {
        return 0;
      }
      return D;
    } else {
      //println("NOT SQUARE -> DETERMINANT UNDEFINED");
      return 0;
    }
  }

  Matrix inv() {
    return inv(false);
  }
  Matrix inv(boolean detScl) {
    if (!isSquare()) {
      //println("NOT SQUARE");
      return O();
    } else if (invertible()) {
      Matrix Mat = Copy();
      Mat = Mat.augmentRight(Mat.I());
      Mat = Mat.rref();
      if (detScl) {
        return Mat.cutRight(this.n).scl(this.det()).rnd(true);
      }
      return Mat.cutRight(this.n);
    } else {
      //println("SINGULAR");
      return O();
    }
  }

  Matrix pow(int k) {
    Matrix Mat = this;
    if (k==0 && isSquare()) {
      return Mat.I();
    } else if (k == 1 && isSquare()) {
      return Mat;
    } else if (isSquare() && k<0) {
      return Mat.inv().pow(-k);
    } else if (isSquare()) {
      return Mat.mult(Mat.pow(k-1));
    } else {
      //println("NOT SQUARE");
      return O();
    }
  }

  Matrix T() {
    Matrix Mat = new Matrix(n, m);
    for (int i = 0; i < m*n; i++) {
      Mat.M[i/n][i%n] = M[i%n][i/n];
    }
    return Mat;
  }

  Matrix I() {
    Matrix N = new Matrix(m, n);
    for (int j = 0; j < min(m, n); j++) {
      N.M[j][j] = 1;
    }
    return N;
  }

  void setI() {
    setO();
    for (int j = 0; j < min(m, n); j++) {
      M[j][j] = 1;
    }
  }

  Matrix aug(Matrix N) {
    return augmentRight(N);
  }
  Matrix aug(Vector v) {
    return augmentRight(v.V);
  }
  Matrix augmentRight(Matrix N) {
    if (m != N.m) {
      //println("WRONG DIMENSIONS");
      return O();
    }
    Matrix Mat = new Matrix(m, n+N.n);
    for (int y = 0; y<Mat.m; y++) {
      for (int x = 0; x<Mat.n; x++) {
        if (x<n) {
          Mat.M[x][y] = M[x][y];
        } else {
          Mat.M[x][y] = N.M[x-n][y];
        }
      }
    }
    return Mat;
  }

  Matrix cutRight(int L) {
    int l = max(min(L, n), 0);
    if (l == n || l == 0) {
      return this;
    }
    Matrix Mat = new Matrix(m, l);
    for (int i = 0; i < m*l; i++) {
      Mat.M[i%l][i/l] = M[n-l+(i%l)][i/l];
    }
    return Mat;
  }
  Matrix cutLeft(int L) {
    int l = max(min(L, n), 0);
    if (l == n || l == 0) {
      return this;
    }
    Matrix Mat = new Matrix(m, l);
    for (int i = 0; i < m*l; i++) {
      Mat.M[i%l][i/l] = M[i%l][i/l];
    }
    return Mat;
  }

  Matrix O() {
    Matrix N = new Matrix(m, n);
    return N;
  }

  void setO() {
    Matrix N = new Matrix(m, n);
    this.M = N.M;
  }

  Matrix rnd() {
    return rnd(false);
  }
  Matrix rnd(boolean roundClose) {
    Matrix Mat = new Matrix(m, n);
    double f = 0;
    for (int i = 0; i < m*n; i++) {
      if (roundClose) {
        f = M[i%n][i/n];
        if (abs(round(f)-f)<0.001) {
          Mat.M[i%n][i/n] = round(f);
        } else {
          Mat.M[i%n][i/n] = f;
        }
      } else {
        Mat.M[i%n][i/n] = round(M[i%n][i/n]);
      }
    }
    return Mat;
  }

  Matrix ab() {
    Matrix Mat = new Matrix(m, n);
    for (int i = 0; i < m*n; i++) {
      Mat.M[i%n][i/n] = abs(M[i%n][i/n]);
    }
    return Mat;
  }

  String deci() {
    String str = "[";
    for (int i = 0; i<m*n; i++) {
      if (i != 0 && i%n == 0) {
        str += "\n  "+(M[0][i/n]);
      } else {
        str += " "+(M[i%n][i/n]);
      }
    }
    str+="]";
    return str;
  }

  Matrix ratl() {
    Matrix Mat = new Matrix(m, n);
    for (int i = 0; i<m*n; i++) {
      Mat.M[i%n][i/n] = rational(M[i%n][i/n]);
    }
    return Mat;
  }

  String toString() {
    String str = "[";
    for (int i = 0; i<m*n; i++) {
      if (i != 0 && i%n == 0) {
        str += "\n  "+rationalize(M[0][i/n]);
      } else {
        str += " "+rationalize(M[i%n][i/n]);
      }
    }
    str+="]";
    return str;
  }
}

Matrix buildRows(Vector... vs) {
  Matrix Mat = new Matrix(vs.length, vs[0].n);
  for (int i = 0; i<Mat.m*Mat.n; i++) {
    Mat.M[i%Mat.n][i/Mat.n] = vs[i/Mat.n].el(i%Mat.n);
  }
  return Mat;
}

Matrix buildCols(Vector... vs) {
  Matrix Mat = new Matrix(vs[0].n, vs.length);
  for (int i = 0; i<Mat.m*Mat.n; i++) {
    Mat.M[i/Mat.n][i%Mat.n] = vs[i/Mat.n].el(i%Mat.n);
  }
  return Mat;
}
class Matrix {
  // note: [n][m] for m x n matrix
  double[][] M;
  int m, n;

  Matrix(int m, int n) {
    M = new double[n][m];
    this.m = m;
    this.n = n;
  }

  Matrix(int m) {
    M = new double[m][m];
    this.m = m;
    this.n = m;
  }

  Matrix() {
    M = new double[1][1];
    this.m = 1;
    this.n = 1;
  }

  boolean isSquare() {
    return m == n;
  }

  void chgDim(int dN, int dM) {
    if (dN>=1 && dM>=1) { 
      double[][] newM = new double[dN][dM];
      for (int i = 0; i<min(this.n, dN); i++) {
        for (int j = 0; j<min(this.m, dM); j++) {
          newM[i][j] = this.M[i][j];
        }
      }
      this.M = newM;
      this.n = dN;
      this.m = dM;
    }
  }

  Matrix Copy() {
    Matrix Mat = new Matrix(m, n);
    for (int i = 0; i<m*n; i++) {
      Mat.M[i%n][i/n] = M[i%n][i/n];
    }
    return Mat;
  }

  IMatrix cast() {
    IMatrix I = new IMatrix(m, n);
    for (int i = 0; i<m*n; i++) {
      I.M[i%n][i/n] = M[i%n][i/n];
    }
    return I;
  }

  double get(int i) {
    if (i >=0 && i<n*m) {
      return M[i%n][i/n];
    }
    return 0;
  }

  void set(int i, double val) {
    if (i >=0 && i<n*m) {
      M[i%n][i/n] = val;
    }
  }

  void load(double... nums) {
    for (int i = 0; i < min(m*n, nums.length); i++) {
      M[i%n][i/n] = nums[i];
    }
  }

  void randInt(int n1) {
    for (int i = 0; i < m*n; i++) {
      M[i%n][i/n] = floor(random(n1+1));
    }
  }
  void randInt(int n1, int n2) {
    for (int i = 0; i < m*n; i++) {
      M[i%n][i/n] = int(random(n1, n2+1));
    }
  }
  void rand(double f) {
    for (int i = 0; i < m*n; i++) {
      M[i%n][i/n] = random(f);
    }
  }
  void rand(int f1, int f2) {
    for (int i = 0; i < m*n; i++) {
      M[i%n][i/n] = random(f1, f2);
    }
  }

  Matrix scl(double f) {
    Matrix Mat = new Matrix(m, n);
    for (int j = 0; j<m*n; j++) {
      Mat.M[j%n][j/n] = f*M[j%n][j/n];
    }
    return Mat;
  }
  void Scl(double f) {
    for (int j = 0; j<m*n; j++) {
      M[j%n][j/n] = f*M[j%n][j/n];
    }
  }

  Vector mult(double... fs) {
    Vector v = new Vector(fs);
    return this.mult(v);
  }

  Matrix mult(Matrix M_) {
    double sum = 0;
    if (M_.m == n) {
      Matrix Mat = new Matrix(m, M_.n);
      for (int j = 0; j<m*M_.n; j++) {
        sum = 0;
        for (int l = 0; l < n; l++) {
          sum += this.M[l][j/M_.n]*M_.M[j%M_.n][l];
        }
        Mat.M[j%M_.n][j/M_.n] = sum;
      }
      return Mat;
    } else {
      //println("WRONG DIMENSIONS");
      return O();
    }
  }

  Matrix div(Matrix M_) {
    return mult(M_.inv());
  }

  Vector mult(Vector v) {
    return new Vector(this.mult(v.V));
  }

  Matrix add(Matrix M_) {
    if (m!=M_.m || n!=M_.n) {
      println("WRONG DIMENSIONS");
      return O();
    }
    Matrix N = this;
    for (int i = 0; i<m*n; i++) {
      N.M[i/m][i%m] += M_.M[i/m][i%m];
    }
    return N;
  }

  Matrix sub(Matrix M_) {
    if (m!=M_.m || n!=M_.n) {
      //println("WRONG DIMENSIONS");
      return O();
    }
    Matrix N = this;
    for (int i = 0; i<m*n; i++) {
      N.M[i/m][i%m] -= M_.M[i/m][i%m];
    }
    return N;
  }

  boolean singular() {
    return det() == 0;
  }

  boolean invertible() {
    return det() != 0;
  }

  Matrix upTri() {
    return upTri(false);
  }  
  Matrix upTri(boolean detPreserving) {
    Matrix Mat = Copy();
    int x = 0, y = 0, ct = 0;
    while (x<n && y<m && ct<m) {
      //CREATE UPPER TRIANGULAR MATRIX VIA ROW OPERATIONS
      if (Mat.M[x][y] == 0) {
        y++;
        if (y==m) {
          x++;
          y = ct;
        }
      } else if (y <= ct) {
        ct++;
        for (int i = y+1; i<m; i++) {
          Mat.rComb(i, y, -Mat.M[x][i]*1.0/Mat.M[x][y]);
        }
        x++;
        y = ct;
      } else {
        Mat.rSwap(ct, y);
        if (detPreserving) {
          Mat.rScl(ct, -1);
        }
        y = ct;
      }
    }
    return Mat.add(O());
  }
  Matrix ref() {
    Matrix Mat = Copy();
    int x = 0, y = 0, ct = 0;
    while (x<n && y<m && ct<m) {
      if (Mat.M[x][y] == 0) {
        y++;
        if (y==m) {
          x++;
          y = ct;
        }
      } else if (y <= ct) {
        Mat.rScl(y, 1/Mat.M[x][y]);
        ct++;
        for (int i = y+1; i<m; i++) {
          Mat.rComb(i, y, -Mat.M[x][i]);
        }
        x++;
        y = ct;
      } else {
        Mat.rSwap(ct, y);
        y = ct;
      }
    }
    return Mat.add(Mat.O());
  }
  Matrix rref() {
    Matrix Mat = ref();
    int x = min(n-1, m-1), y = m-1;
    while (x>0 && y>=0) {
      if (Mat.M[x][y] == 0) {
        x++;
        if (x==n) {
          y--;
          x = min(n-1, y);
        }
      } else {
        for (int i = y-1; i>=0; i--) {
          Mat.rComb(i, y, -Mat.M[x][i]);
        }
        y--;
        x = y;
      }
    }
    return Mat.add(Mat.O());
  }
  //ROW OPERATIONS
  void rScl(int ind, double f) {
    int index = max(0, min(ind, m-1));
    for (int k = 0; k<n; k++) {
      M[k][index] *= f;
    }
  }
  void rSwap(int ind1, int ind2) {
    if (ind1==ind2) {
      return;
    }
    if (ind1<0||ind2<0||ind1>=m||ind2>=m) {
      println("INDEX OUT OF RANGE");
      return;
    }
    double[] nums = new double[n];
    for (int i = 0; i<n; i++) {
      nums[i] = M[i][ind1];
    }
    for (int i = 0; i<n; i++) {
      M[i][ind1] = M[i][ind2];
    }
    for (int i = 0; i<n; i++) {
      M[i][ind2] = nums[i];
    }
  }
  void rComb(int ind1, double f1, int ind2, double f2) {
    if (ind1<0||ind2<0||ind1>=m||ind2>=m) {
      //println("INDEX OUT OF RANGE");
      return;
    }
    if (ind1==ind2) {
      rScl(ind1, f1);
      return;
    }
    if (f2==0) {
      rScl(ind1, f1);
      return;
    }
    for (int i = 0; i<n; i++) {
      M[i][ind1] *= f1;
      M[i][ind1] += f2*M[i][ind2];
    }
  }
  void rComb(int ind1, int ind2, double f1) {
    if (f1 == 0) {
      return;
    }
    if (ind1==ind2) {
      rScl(ind1, f1);
      return;
    }
    rComb(ind1, 1, ind2, f1);
  }

  Matrix diag() {
    Matrix Mat = new Matrix(min(n, m));
    for (int i = 0; i<min(n, m); i++) {
      Mat.M[i][i] = this.M[i][i];
    }
    return Mat;
  }

  double det() {
    if (isSquare()) {
      Matrix Mat = upTri(true);
      double D = 1;
      for (int i = 0; i<n; i++) {
        D *= Mat.M[i][i];
      }
      if (D==0) {
        return 0;
      }
      return D;
    } else {
      //println("NOT SQUARE -> DETERMINANT UNDEFINED");
      return 0;
    }
  }

  Matrix inv() {
    return inv(false);
  }
  Matrix inv(boolean detScl) {
    if (!isSquare()) {
      //println("NOT SQUARE");
      return O();
    } else if (invertible()) {
      Matrix Mat = Copy();
      Mat = Mat.augmentRight(Mat.I());
      Mat = Mat.rref();
      if (detScl) {
        return Mat.cutRight(this.n).scl(this.det()).rnd(true);
      }
      return Mat.cutRight(this.n);
    } else {
      //println("SINGULAR");
      return O();
    }
  }

  Matrix pow(int k) {
    Matrix Mat = this;
    if (k==0 && isSquare()) {
      return Mat.I();
    } else if (k == 1 && isSquare()) {
      return Mat;
    } else if (isSquare() && k<0) {
      return Mat.inv().pow(-k);
    } else if (isSquare()) {
      return Mat.mult(Mat.pow(k-1));
    } else {
      //println("NOT SQUARE");
      return O();
    }
  }

  Matrix T() {
    Matrix Mat = new Matrix(n, m);
    for (int i = 0; i < m*n; i++) {
      Mat.M[i/n][i%n] = M[i%n][i/n];
    }
    return Mat;
  }

  Matrix I() {
    Matrix N = new Matrix(m, n);
    for (int j = 0; j < min(m, n); j++) {
      N.M[j][j] = 1;
    }
    return N;
  }

  void setI() {
    setO();
    for (int j = 0; j < min(m, n); j++) {
      M[j][j] = 1;
    }
  }

  Matrix aug(Matrix N) {
    return augmentRight(N);
  }
  Matrix aug(Vector v) {
    return augmentRight(v.V);
  }
  Matrix augmentRight(Matrix N) {
    if (m != N.m) {
      //println("WRONG DIMENSIONS");
      return O();
    }
    Matrix Mat = new Matrix(m, n+N.n);
    for (int y = 0; y<Mat.m; y++) {
      for (int x = 0; x<Mat.n; x++) {
        if (x<n) {
          Mat.M[x][y] = M[x][y];
        } else {
          Mat.M[x][y] = N.M[x-n][y];
        }
      }
    }
    return Mat;
  }

  Matrix cutRight(int L) {
    int l = max(min(L, n), 0);
    if (l == n || l == 0) {
      return this;
    }
    Matrix Mat = new Matrix(m, l);
    for (int i = 0; i < m*l; i++) {
      Mat.M[i%l][i/l] = M[n-l+(i%l)][i/l];
    }
    return Mat;
  }
  Matrix cutLeft(int L) {
    int l = max(min(L, n), 0);
    if (l == n || l == 0) {
      return this;
    }
    Matrix Mat = new Matrix(m, l);
    for (int i = 0; i < m*l; i++) {
      Mat.M[i%l][i/l] = M[i%l][i/l];
    }
    return Mat;
  }

  Matrix O() {
    Matrix N = new Matrix(m, n);
    return N;
  }

  void setO() {
    Matrix N = new Matrix(m, n);
    this.M = N.M;
  }

  Matrix rnd() {
    return rnd(false);
  }
  Matrix rnd(boolean roundClose) {
    Matrix Mat = new Matrix(m, n);
    double f = 0;
    for (int i = 0; i < m*n; i++) {
      if (roundClose) {
        f = M[i%n][i/n];
        if (abs(round(f)-f)<0.001) {
          Mat.M[i%n][i/n] = round(f);
        } else {
          Mat.M[i%n][i/n] = f;
        }
      } else {
        Mat.M[i%n][i/n] = round(M[i%n][i/n]);
      }
    }
    return Mat;
  }

  Matrix ab() {
    Matrix Mat = new Matrix(m, n);
    for (int i = 0; i < m*n; i++) {
      Mat.M[i%n][i/n] = abs(M[i%n][i/n]);
    }
    return Mat;
  }

  String deci() {
    String str = "[";
    for (int i = 0; i<m*n; i++) {
      if (i != 0 && i%n == 0) {
        str += "\n  "+(M[0][i/n]);
      } else {
        str += " "+(M[i%n][i/n]);
      }
    }
    str+="]";
    return str;
  }

  Matrix ratl() {
    Matrix Mat = new Matrix(m, n);
    for (int i = 0; i<m*n; i++) {
      Mat.M[i%n][i/n] = rational(M[i%n][i/n]);
    }
    return Mat;
  }

  String toString() {
    String str = "[";
    for (int i = 0; i<m*n; i++) {
      if (i != 0 && i%n == 0) {
        str += "\n  "+rationalize(M[0][i/n]);
      } else {
        str += " "+rationalize(M[i%n][i/n]);
      }
    }
    str+="]";
    return str;
  }
}

Matrix buildRows(Vector... vs) {
  Matrix Mat = new Matrix(vs.length, vs[0].n);
  for (int i = 0; i<Mat.m*Mat.n; i++) {
    Mat.M[i%Mat.n][i/Mat.n] = vs[i/Mat.n].el(i%Mat.n);
  }
  return Mat;
}

Matrix buildCols(Vector... vs) {
  Matrix Mat = new Matrix(vs[0].n, vs.length);
  for (int i = 0; i<Mat.m*Mat.n; i++) {
    Mat.M[i/Mat.n][i%Mat.n] = vs[i/Mat.n].el(i%Mat.n);
  }
  return Mat;
}

//////////////////////////////

class MatrixSet {
  final float MATRIX_SPACE = height*0.07;
  IMatrix[] item = new IMatrix[0];
  int length;

  MatrixSet() {
    length = 0;
  }

  void add(IMatrix Mat) {
    length++;
    IMatrix[] Mats = new IMatrix[length];
    for (int i = 0; i<length-1; i++) {
      Mats[i] = item[i].Copy();
    }
    Mats[length-1] = Mat;
    item = Mats;
  }

  void add(Matrix Mat) {
    length++;
    IMatrix[] Mats = new IMatrix[length];
    for (int i = 0; i<length-1; i++) {
      Mats[i] = item[i].Copy();
    }
    Mats[length-1] = Mat.cast();
    item = Mats;
  }
  
  void duplicate(int index) {
    if(index > -1) {
      add(item[index%length].Copy());
      item[length-1].setPos(item[index],item[index].n);
    }
  }

  IMatrix get(int i) {
    if (i >= 0 && i < length) {
      return this.item[i];
    } else {
      return null;
    }
  }

  void augment() {
    int[] set = detectAug();
    if (set[0]>-1) {
      get(set[0]).augment(get(set[1]));
      remove(set[1]);
    }
  }

  void split() {
    int[] set = detectCut();
    if (set[0]>-1) {
      IMatrix whole = get(set[0]);
      remove(set[0]);
      add(whole.cutLeft(set[1]));
      add(whole.cutRight(whole.n-set[1]));
      get(length-2).setPos(whole);
      get(length-1).setPos(whole, set[1]);
    }
  }

  void remove(int i) {
    if (length>0 && i>=0 && i<length) {
      int k = i;
      while (k<length-1) {
        item[k] = item[k+1].Copy();
        k++;
      }
      length--;
    }
  }

  void randLoc() {
    for (int i = 0; i<length; i++) {
      item[i].randLoc();
    }
  }

  void disp() {
    for (int i = 0; i<length; i++) {
      item[i].disp();
    }
  }

  int detectCornerTL() {
    int i = 0;
    while (i<length) {
      if (item[i].detectCornerTL()) {
        return i;
      }
      i++;
    }
    return -1;
  }

  int detectCornerTR() {
    int i = 0;
    while (i<length) {
      if (item[i].detectCornerTR()) {
        return i;
      }
      i++;
    }
    return -1;
  }

  int detectCornerBR() {
    int i = 0;
    while (i<length) {
      if (item[i].detectCornerBR()) {
        return i;
      }
      i++;
    }
    return -1;
  }

  int detectCornerBL() {
    int i = 0;
    while (i<length) {
      if (item[i].detectCornerBL()) {
        return i;
      }
      i++;
    }
    return -1;
  }

  int detectOver() {
    int i = 0;
    while (i<length) {
      if (item[i].detectOver()) {
        return i;
      }
      i++;
    }
    return -1;
  }

  int[] detectElement() {
    int i = 0;
    while (i<length) {
      int k = item[i].detectElement();
      if (k > -1) {
        int[] OUT = {i, k};
        return OUT;
      }
      i++;
    }
    int[] OUT = {-1, -1};
    return OUT;
  }

  int detectResCorner() {
    int i = 0;
    while (i<length) {
      if (item[i].resultMat != null) {
        if (item[i].resultMat.detectCornerTL()) {
          return i;
        }
      }
      i++;
    }
    return -1;
  }

  int[] detectAug() {
    int i = 0, j = 0;
    while (i<length) {
      if (item[i].detectRightEdge()) {
        j = 0;
        while (j<length) {
          if (i != j) {
            if (item[i].m == item[j].m &&
              item[j].detectLeftEdge()) {
              int[] OUT = {i, j};
              return OUT;
            }
          }
          j++;
        }
      }
      i++;
    }
    int[] OUT = {-1, -1};
    return OUT;
  }

  int[] detectCut() {
    int i = 0;
    while (i<length) {
      int k = item[i].detectVert();
      if (k > -1) {
        int[] OUT = {i, k};
        return OUT;
      }
      i++;
    }
    int[] OUT = {-1, -1};
    return OUT;
  }

  int readyToOp() {
    int i = 0;
    while (i<length) {
      if (item[i].resultMat == null && !item[i].rightLinked) {
        if (contains(item[i].rightOperation, item[i].rightOpsMID)) {
          return i;
        }
      }
      i++;
    }
    return -1;
  }

  void link() {
    int i = readyToOp();
    if (i>-1) {
      for (int j = 0; j<length; j++) {
        if (j != i) {
          if (item[i].dist(item[j]) < MATRIX_SPACE) {
            item[i].linkRight(item[j]);
            return;
          }
        }
      }
    }
  }
  
  void unlinkAll() {
    for(int i = 0; i<length; i++) {
      item[i].unlink();
    }
  }
  
  void ratl() {
    for(int i = 0; i<length; i++) {
      item[i].ratl();
    }
  }
}

///////////////////////////////////

String rationalize(double f) {
  int largestDen = 10000;
  double bound = 0.00005;
  if (abs(f-round(f))<bound) {
    return ""+round(f);
  }
  int N = 1, D = 2;
  while (abs(D*f-round(D*f))>=bound && D<largestDen) {
    D++;
  }
  if (D == largestDen) {
    return ""+f;
  }
  N = round(D*f);
  return N+"/"+D;
}

double rational(double f) {
  int largestDen = 10000;
  double bound = 0.00005;
  if (abs(f-round(f))<bound) {
    return round(f);
  }
  int N = 1, D = 2;
  while (abs(D*f-round(D*f))>=bound && D<largestDen) {
    D++;
  }
  if (D == largestDen) {
    return f;
  }
  N = round(D*f);
  return N*1.0/D;
}

double pwr(double t, int k) {
  if (k<=0) {
    return 1;
  }
  return t*pwr(t, k-1);
}

int round(double f) {
  return round((float)f);
}

float abs(double f) {
  return abs((float)f);
}

float random(double f) {
  return random((float)f);
}

double parse(String str) {
  if (str.equals("")) {
    return 1.0;
  }

  double OUT = 0;
  String[] stg;

  try {
    OUT = Double.parseDouble(str);
  }
  catch(Exception e2) {
    if (str.indexOf("*") != -1) {
      try {
        stg = split(str, '*');
        OUT = parse(stg[0]);
        for (int i = 1; i<stg.length; i++) {
          OUT *= parse(stg[i]);
        }
      }
      catch(Exception e) {
        println(e);
        return 0;
      }
    }

    if (str.indexOf("/") != -1) {
      try {
        stg = split(str, '/');
        OUT = parse(stg[0]);
        for (int i = 1; i<stg.length; i++) {
          if (parse(stg[i]) == 0) {
            OUT = 0;
          } else {
            OUT /= parse(stg[i]);
          }
        }
      }
      catch(Exception e) {
        println(e);
        return 0;
      }
    }
  }

  return OUT;
}

boolean contains(String str, String[] strs) {
  for(int i = 0; i<strs.length; i++) {
    if (strs[i].equalsIgnoreCase(str)) {
      return true;
    }
  }
  
  return false;
}

/////////////////////////////////

class Vector {
  int n;
  Matrix V;

  Vector(double... nums) {
    n = nums.length;
    V = new Matrix(n, 1);
    V.load(nums);
  }
  Vector(Matrix M) {
    if (M.n == 1) {
      n = M.m;
      V = M.Copy();
    } else {
      println("NOT A VECTOR: WRONG DIMENSIONS");
      V = null;
    }
  }

  Matrix T() {
    return V.T();
  }

  Vector Copy() {
    Matrix M_ = this.V.Copy();
    return new Vector(M_);
  }

  double r() {
    return sqrt((float)dot(this));
  }
  double r2() {
    return dot(this);
  }

  double dot(Vector v_) {
    if (this.n == v_.n) {
      double f = 0;
      for (int i = 0; i<this.n; i++) {
        f += v_.V.M[0][i]*this.V.M[0][i];
      }
      return f;
    } else {
      println("DOT PRODUCT ERROR: WRONG DIMENSIONS");
      return 0;
    }
  }

  Vector add(Vector v_) {
    Vector v1 = this.Copy();
    if (this.n == v_.n) {
      for (int i = 0; i<this.n; i++) {
        v1.V.M[0][i] += v_.V.M[0][i];
      }
      return v1;
    } else {
      println("VECTOR ADD ERROR: WRONG DIMENSIONS");
      return v1;
    }
  }

  Vector sub(Vector v_) {
    Vector v1 = this.Copy();
    if (this.n == v_.n) {
      for (int i = 0; i<this.n; i++) {
        v1.V.M[0][i] -= v_.V.M[0][i];
      }
      return v1;
    } else {
      println("VECTOR SUBTRACT ERROR: WRONG DIMENSIONS");
      return v1;
    }
  }

  Vector scl(double f) {
    Vector v1 = this.Copy();
    for (int i = 0; i<this.n; i++) {
      v1.V.M[0][i] *= f;
    }
    return v1;
  }

  Vector proj(Vector v_) {
    Vector v1 = v_.Copy();
    return v1.scl(v_.dot(this)/v_.r2());
  }
  
  Vector qroj(Vector v_) {
    return this.sub(proj(v_));
  }
  
  //el -> element i (for i between 0 and n-1)
  double el(int i) {
    if(i<n) {
      return this.V.M[0][i];
    }
    return 0;
  }

  String deci() {
    return ""+V.deci();
  }

  String toString() {
    return ""+V;
  }
}
