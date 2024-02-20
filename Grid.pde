class Grid {
  int m, n;

  float r;
  float gap, eachD;
  float startX, startY;
  float diagonal;
  float gapFactor = 1;

  float filmR;
  float filmAlpha = 20;
  float filmW, filmH;

  float x, y;
  float w, h;
  float theta;
  float toTheta;

  float transitionFactor;

  float grid [] [];

  color filmFill = -1;

  boolean sizeBased = false;

  // Element count based
  Grid (int n) {
    m = n;
    this.n = n;
    grid = new float [m] [n];

    sizeBased = false;
    init ();
  }
  Grid (int m, int n) {
    this.m = m;
    this.n = n;
    grid = new float [m] [n];

    sizeBased = false;
    init ();
  }

  void init (float factor) {
    r = width*0.015*factor;
    gap = width*0.82*0.07*gapFactor*factor;
    eachD = width*0.82*0.15*factor;
    w = (eachD*n + gap*(n-1));
    h = (eachD*m + gap*(m-1));

    filmW = w + gap*2;
    filmH = h + gap*2;

    diagonal = sqrt (w*w + h*h);
    filmR = r*3;

    calculateInit ();
  }
  void init () {
    init (1);
  }

  // Element count and film size based
  Grid (int n, float filmW) {
    this.filmW = filmW;
    this.filmH = filmW;

    m = n;
    this.n = n;

    grid = new float [m] [n];

    sizeBased = true;
    initWithFilm ();
  }
  Grid (int m, int n, float filmW, float filmH) {
    this.filmW = filmW;
    this.filmH = filmH;

    this.m = m;
    this.n = n;

    grid = new float [m] [n];

    sizeBased = true;
    initWithFilm ();
  }

  void initWithFilm (float factor) {
    r = width*0.015*factor;
    gap = width*0.82*0.07*gapFactor*factor*map (n, minBoardDimension, maxBoardDimension, 1, 0.5);
    eachD = (filmW - gap*(n + 1))/n;

    diagonal = sqrt (filmW*filmW + filmH*filmH);
    filmR = r*3;

    calculateInit ();
  }
  void initWithFilm () {
    initWithFilm (1);
  }

  void calculateInit () {
    startX = (w - filmW)/2 + gap;
    startY = (h - filmH)/2 + gap;
  }

  void setDimension (int dimension) {
    m = dimension;
    n = dimension;
    grid = new float [m] [n];

    if (sizeBased)
      initWithFilm ();
    else
      init ();
  }

  void setFilmFill (color filmFill, float filmAlpha) {
    this.filmFill = filmFill;
    this.filmAlpha = filmAlpha;
  }
  void gapFactor (float gapFactor) {
    this.gapFactor = gapFactor;

    if (sizeBased)
      initWithFilm (1);
    else
      init (1);
  }

  void scale (float s) {
    if (sizeBased)
      initWithFilm (s);
    else
      init (s);
  }

  void draw (float x, float y, float theta) {
    calculateInit ();
    this.theta = theta;

    pushMatrix ();
    translate (x, y);
    rotate (theta);

    draw (0, 0);

    popMatrix ();
  }
  void draw (float x, float y) {
    x -= w/2;
    y -= h/2;

    rectMode (CORNER);
    noStroke ();
    for (int a = 0; a < n; a ++) {
      for (int b = 0; b < m; b ++) {
        float alpha = grid [b] [a];
        fill (255, 255*alpha);
        rect(x + startX + gap*a + eachD*a, y + startY + gap*b + eachD*b, eachD, eachD, r);
      }
    }
  }
  void draw (float x, float y, boolean animate) {
    if (!animate)
      draw (x, y);
    else {
      calculateInit ();
      
      pushMatrix ();
      translate (x, y);
      rotate (theta);

      draw (0, 0);

      popMatrix ();
    }
  }

  void rotateTo (float toTheta, float transitionFactor) {
    this.toTheta += toTheta;
    this.transitionFactor = transitionFactor;
  }

  void calculateTheta () {
    theta = lerp (theta, toTheta, transitionFactor);
  }

  void showFilm (float x, float y) {
    noStroke ();
    rectMode (CENTER);
    if (filmFill != -1) {
      fill(filmFill, filmAlpha);
      rect (x, y, filmW, filmH, filmR);
    }
  }
  void showFilm (float x, float y, float theta) {
    pushMatrix ();
    translate (x, y);
    rotate (theta);

    showFilm (0, 0);

    popMatrix ();
  }
  void showFilm (float x, float y, boolean animate) {
    if (!animate)
      showFilm (x, y);
    else {
      calculateTheta ();
      
      pushMatrix ();
      translate (x, y);
      rotate (theta);

      showFilm (0, 0);

      popMatrix ();
    }
  }

  void randomOpacity () {
    randomOpacity (0.7);
  }
  void randomOpacity (float probability) {
    randomOpacity (probability, 0.2, 0.8);
  }
  void randomOpacity (float probability, float from, float to) {
    for (int a = 0; a < n; a ++) {
      for (int b = 0; b < m; b ++) {
        float rand = random (1);

        if (rand > 1 - probability)
          grid [b] [a] = from + int (random (to*10))*0.1;
        else
          grid [b] [a] = 0.3;
      }
    }
  }
  void randomOpacity (float from, float to) {
    randomOpacity (0.2, from, to);
  }

  void setOpacity (float opacity) {
    for (int a = 0; a < n; a ++)
      for (int b = 0; b < m; b ++)
        grid [b] [a] = opacity;
  }
}
