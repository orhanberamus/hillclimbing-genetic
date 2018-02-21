

int SPACE = 75;
int NUMQUEENS = 8;
int CYCLE = 35;

int numFrames =10; 
int currentState;
int min;
int resets = 0; 
int hamle = 0;
int bulunmaSayisi = 0;

PImage img; 
boolean ciz = false;
boolean done = false;

Queen queens[] = new Queen[NUMQUEENS];
Queen oncekiQueens[] = new Queen[NUMQUEENS];
Queen duplicateQueens[] = new Queen[NUMQUEENS];
int successors[][] = new int [NUMQUEENS][NUMQUEENS];
double sureler[] = new double[CYCLE];
int hamleler[] = new int[CYCLE];
int resetler[] = new int[CYCLE];

StopWatchTimer sw = new StopWatchTimer();

void setup() {
  sw.start();
  size(1200, 620);
  background(255);
  frameRate(60);
  img = loadImage("blackQueen.png");


  initializeBoard();
  randomQuennEkle();
  currentState = calculateAttacks(queens);
  calculateSuccessors(queens);
  initializeArrays();
}
void draw() {


  if (mousePressed == true) {
    stroke(255, 0, 0);
    strokeWeight(5);
    line(mouseX, mouseY, pmouseX, pmouseY);
  } else {
    strokeWeight(0);
    if (bulunmaSayisi < CYCLE) {
      if (!done) {
        if ( goNeighbor(queens)) {
           initializeBoard();
            drawQueens(queens);
          currentState = calculateAttacks(queens);
          if (currentState == 0) {
            
            sw.stop();
            sureler[bulunmaSayisi] = sw.second();
            sw.start();
            resetler[bulunmaSayisi] = resets;
            hamleler[bulunmaSayisi] = hamle;

            hamle = 0;
            resets = 0;
            fill(0);
             textSize(14);
            text("Sıra ", 8 * SPACE + SPACE, SPACE /3);
            text("Sure ", 8 * SPACE + SPACE * 3, SPACE /3);
            text("Hamle ", 8*SPACE + SPACE * 5, SPACE /3);
            text("Reset ", 8*SPACE + SPACE * 7, SPACE /3);
             fill(0);
             textSize(14);
             text(bulunmaSayisi + 1, 8*SPACE + SPACE, SPACE*bulunmaSayisi/5 + SPACE);
             text(str((float)sureler[bulunmaSayisi]), 8*SPACE + SPACE * 3, SPACE*bulunmaSayisi/5 + SPACE);
             text(hamleler[bulunmaSayisi], 8*SPACE + SPACE * 5, SPACE*bulunmaSayisi/5 + SPACE);
             text(resetler[bulunmaSayisi], 8*SPACE + SPACE * 7, SPACE*bulunmaSayisi/5 + SPACE);
              bulunmaSayisi++;
          }

          calculateSuccessors(queens);
        } else {

          resetQueens();
        }
      }
    }
  }



  if (bulunmaSayisi == CYCLE) {
    float toplamSure = 0;
    int toplamHamle = 0, toplamReset = 0;
   
    for (int i = 0; i < CYCLE; i++) {
      String sure, hamlex, resetx;
      sure = str((float)sureler[i]);
      hamlex = str(hamleler[i]);
      resetx = str(resetler[i]);

      toplamSure += sureler[i];
      toplamHamle += hamleler[i];
      toplamReset += resetler[i];

    }

    fill(0);
    textSize(14);
    text("TOPLAM ", 8*SPACE + SPACE, SPACE*bulunmaSayisi  /5  + SPACE);
    text(toplamSure, 8*SPACE + SPACE * 3, SPACE* bulunmaSayisi /5   + SPACE);
    text(toplamHamle, 8*SPACE + SPACE * 5, SPACE*bulunmaSayisi/5 + SPACE);
    text(toplamReset, 8*SPACE + SPACE * 7, SPACE*bulunmaSayisi/5 + SPACE);
    text("ORTALAMA ", 8*SPACE + SPACE, (SPACE*(bulunmaSayisi+1))   /5 + SPACE);
    text(toplamSure / CYCLE, 8*SPACE + SPACE * 3, (SPACE* (bulunmaSayisi +1)) /5 + SPACE);
    text(toplamHamle / CYCLE, 8*SPACE + SPACE * 5, (SPACE * (bulunmaSayisi + 1)) /5 + SPACE);
    text(toplamReset / CYCLE, 8*SPACE + SPACE * 7, (SPACE * (bulunmaSayisi + 1) ) /5 + SPACE);
  }
}


void randomQuennEkle() {
  for (int i=0; i<NUMQUEENS; i++) {
    int rand =(int) random(NUMQUEENS);
    image(img, i*SPACE, rand*SPACE);
    queens[i] = new Queen(i*SPACE, rand*SPACE);
  }
}


int calculateAttacks (Queen []paraQueens) {//kaç queen birbirine direk ya da indirect saldırıyor bulan fonksyion
  int numAttacks = 0;

  for (int iQueen = 0; iQueen < NUMQUEENS - 1; iQueen++) {
    for (int iAttackingQueen = iQueen + 1; iAttackingQueen < NUMQUEENS; iAttackingQueen++) {
      if (paraQueens[iQueen].getX() == paraQueens[iAttackingQueen].getX()) {
        numAttacks++;
      } else if (paraQueens[iQueen].getY() == paraQueens[iAttackingQueen].getY()) {
        numAttacks++;
      } else if (paraQueens[iQueen].getX()+ paraQueens[iQueen].getY() ==
        paraQueens[iAttackingQueen].getX() + paraQueens[iAttackingQueen].getY()) {//diagonal olarak bulan
        numAttacks++;
      } else if (paraQueens[iQueen].getY() - paraQueens[iQueen].getX() == //diagonal olarak bulan
        paraQueens[iAttackingQueen].getY() - paraQueens[iAttackingQueen].getX()) {
        numAttacks++;
      }
    }
  }

  return numAttacks;
}


class Queen {//queen classı

  private int x;
  private int y;

  public Queen(int x, int y) {
    this.x = x;
    this.y = y;
  }
  public int getX() {
    return this.x;
  }
  public int getY() {
    return this.y;
  }
  public void setX(int xs) {
    this.x = xs;
  }
  public void setY(int ys) {
    this.y = ys;
  }
}


class StopWatchTimer { //stopwatchtimer classı
  double startTime = 0, stopTime = 0;
  boolean running = false;  


  void start() {
    startTime = millis();
    running = true;
  }
  void stop() {
    stopTime = millis();
    running = false;
  }
  double getElapsedTime() {
    double elapsed;
    if (running) {
      elapsed = (millis() - startTime);
    } else {
      elapsed = (stopTime - startTime);
    }
    return elapsed;
  }
  double second() {
    return (getElapsedTime() /1000) % 60;
  }
  double minute() {
    return (getElapsedTime() / (1000*60)) % 60;
  }
  double hour() {
    return (getElapsedTime() / (1000*60*60)) % 24;
  }
}

int calculateSuccessors( Queen [] paraQueens) {//sırasıyla 1 queenin yerini columnda degistirip kaç queen birbirine saldırıyor bulan fonksiyon

  int  attacks = 0;
  String sattacks;

  for (int k = 0; k< NUMQUEENS; k++) {
    duplicateQueens[k] = new Queen(paraQueens[k].getX(), paraQueens[k].getY());//ana queen arrayi duplicatequeense kopyalanıyo
  }

  for (int i = 0; i < NUMQUEENS; i++) {
    for (int j = 0; j < NUMQUEENS; j++) {

      duplicateQueens[i].setX( i * SPACE );
      duplicateQueens[i].setY( j * SPACE );

      attacks =  calculateAttacks(duplicateQueens);

      sattacks = str(attacks);
      fill(255, 0, 0);
      textSize(20);
      text(sattacks, duplicateQueens[i].getX(), duplicateQueens[i].getY()+SPACE);
      successors[i][j] = attacks;
    }

      for (int m = 0; m < NUMQUEENS; m++) {
        duplicateQueens[m] = new Queen(paraQueens[m].getX(), paraQueens[m].getY());//ilk fordan cıkınca tekrar ana queen arrayi duplicatequeense atanıyo.tekrar resetlenmiş oluyo duplicatequeens
    }
  }
  return attacks;
}

void initializeBoard() {//boardın karelerini çizen fonksyion
  int k = 0;
  for (int i = 0; i < NUMQUEENS; i++) {
    for (int j = 0; j < NUMQUEENS; j++) {

      if (k % 2 == 0) {
        fill(105, 105, 105);
        rect(i*SPACE, j*SPACE, SPACE, SPACE);
      } else {
        fill(255);
        rect(i*SPACE, j*SPACE, SPACE, SPACE);
      }
      k++;
    }
    k--;
  }
}

boolean goNeighbor(Queen[] paraQueens) {//bir queenin daha iyi bir state e gidip gitmeyecegine karar veren fonksyion

  min = 1000;
  int minx = 0;
  int miny = 0;
  for (int i = 0; i < NUMQUEENS; i++) {
    for (int j = 0; j < NUMQUEENS; j++) {


      if (successors[i][j] < currentState && successors[i][j] < min) {//successor matrixindeki deger currentStateten kucukse (yani daha iyi bir state varsa) ve bu successor statei boarddaki en kucuk state ise yeni gidilebilcek best state successor[i][j] oluyor
        min = successors[i][j];
        minx = i;
        miny = j;
      }
    }
  }
  if (min != 1000) {//successor[i][j] current stateden kucuk degilse min 1000 olarak kalıyor değişmiyor eger degistiyse movequeen fonksyonu cagırılıp bir queenin yeri değiştiriliyor
    moveQueen(minx, miny, paraQueens);

    return true;
  } else //false donerse board resetlenecek demek
    return false;
}


void moveQueen(int minx, int miny, Queen [] paraQueens) {

  paraQueens[minx].setX(minx * SPACE);
  paraQueens[minx].setY(miny * SPACE);
}


void drawQueens(Queen [] paraQueens) {
  hamle++;//queen arrayi boarda çizildiginde 1 hamle yapılmış sayılıyor.
  for (int i = 0; i < NUMQUEENS; i++) {
    image(img, paraQueens[i].getX(), paraQueens[i].getY() );
  }
}


void resetQueens () {//gidilecek daha iyi bir state olmadıgında cagırılan boardı arraylari resetleyen fonksiyon
  initializeBoard();
  randomQuennEkle();
  currentState = calculateAttacks(queens);
  calculateSuccessors(queens);
  resets ++;
}


void initializeArrays(){
  for (int i = 0; i < NUMQUEENS; i++) {
    oncekiQueens[i] = new Queen(1, 1);
  }
  for (int k = 0; k < CYCLE; k++) {
    sureler[k] = 0;
    hamleler[k] = 0;
    resetler[k] = 0;
  }
}