class Rail {
  int n;
  int alignment = CORNER;
  int focusedIndex;
  int lastFocusedIndex;

  float d;
  float maxD;
  float railD;
  float startX, startY;
  float gap;
  float transitionFactor = 1;
  float alphaOverride;
  float alphaOverrides [];
  float focusedAlpha;

  float cX, cY;
  float toCX, toCY;
  float cW, cH;
  float toCW, toCH;
  float cHeight;

  color shapeColorU;
  color shapeColorP;

  char VERTICAL = 'V';
  char HORIZONTAL = 'H';
  char orientation = VERTICAL;

  Button pressedButton;

  List <Button> rail = new ArrayList <Button> ();

  Rail (char orientation, float totalD) {
    this.orientation = orientation;
    this.maxD = totalD;
  }
  Rail (float totalD) {
    this.maxD = totalD;
  }

  void append (Button button) {
    rail.add (button);
  }

  void orientVertical () {
    orientation = 'V';
  }
  void orientHorizontal () {
    orientation = HORIZONTAL;
  }

  void setGap (float gap) {
    this.gap = gap;
  }
  void setAlignment (int alignment) {
    this.alignment = alignment;
  }

  void setFillForEach (color fillColorU, float fillAlphaU, color fillColorP, float fillAlphaP) {
    for (int a = 0; a < rail.size (); a ++)
      rail.get (a).setFill (fillColorU, fillAlphaU, fillColorP, fillAlphaP);
  }

  void prepare () {
    n = rail.size ();
    d = rail.get (0).d;
    railD = d*n + gap*(n - 1);

    if (orientation == VERTICAL) {
      startX = 0;
      startY = (maxD - railD)/2 + d/2;
    } else if (orientation == HORIZONTAL) {
      startX = (maxD - railD)/2 + d/2;
      startY = 0;
    }

    int orientationFactor = orientation == VERTICAL? 1 : 0;
    cX = startX + (d*focusedIndex + gap*focusedIndex)*(1 - orientationFactor);
    cY = startY + (d*focusedIndex + gap*focusedIndex)*orientationFactor + d;

    alphaOverrides = new float [n];
  }

  void focusedProperties (int focusedIndex, float cW, float cH, float transitionFactor, color shapeColorU, color shapeColorP) {
    this.focusedIndex = focusedIndex;
    this.cW = cW;
    this.cH = cH;
    cHeight = cH;
    this.transitionFactor = transitionFactor;
    this.shapeColorU = shapeColorU;
    this.shapeColorP = shapeColorP;
  }

  void draw (float x, float y) {
    int orientationFactor = orientation == VERTICAL? 1 : 0;

    for (int a = 0; a < rail.size (); a ++) {
      rail.get (a).alphaOverride = alphaOverrides [a];

      if (a == focusedIndex) {
        toCX = x + startX + (d*a + gap*a)*(1 - orientationFactor);
        toCY = y + startY + (d*a + gap*a)*orientationFactor;

        if (orientation == VERTICAL) {
          cX = toCX;
          cY = lerp (cY, toCY, transitionFactor);
        } else if (orientation == HORIZONTAL) {
          cX = lerp (cX, toCX, transitionFactor);
          cY = toCY;
        }
        float maxDist = dist (rail.get (lastFocusedIndex).x, rail.get (focusedIndex).x, rail.get (lastFocusedIndex).y, rail.get (focusedIndex).y);
        focusedAlpha = map (dist (cX, cY, toCX, toCY), 0.001, maxDist, 255, 100);
        toCH = map (dist (cX, cY, toCX, toCY), 0.001, maxDist, cHeight, cHeight*2);
        
        if (!mousePressed) {
          toCH = constrain (toCH, cHeight, cHeight*2);
        } else if (hovered ()) {
          toCH = cHeight*1.15;
        }

        cH = lerp (cH, toCH, 0.3);

        noStroke ();
        fill (white, focusedAlpha*alphaOverride);
        ellipse (cX, cY, cW, cH);

        rail.get (a).shapeColorU = shapeColorU;
        rail.get (a).shapeColorP = shapeColorP;
      } else {
        rail.get (a).shapeColorU = rail.get (a).originalShapeColorU;
        rail.get (a).shapeColorP = rail.get (a).originalShapeColorP;
      }

      rail.get (a).draw (x + startX + (d*a + gap*a)*(1 - orientationFactor), y + startY + (d*a + gap*a)*orientationFactor);
    }
  }

  boolean pressedOutside () {
    for (int a = 0; a < rail.size (); a ++)
      if (rail.get (a).released()) {
        pressedButton = rail.get (a);
        lastFocusedIndex = focusedIndex;
        focusedIndex = a;
        return false;
      }
    return true;
  }
  boolean released () {
    return !pressedOutside ();
  }
  boolean hovered () {
    for (int a = 0; a < rail.size (); a ++)
      if (rail.get (a).released())
        return true;
    return false;
  }

  void pressed () {
    for (int a = 0; a < rail.size (); a ++)
      rail.get (a).pressed ();
  }
  
  String getFocusedTitle () {
    return rail.get(focusedIndex).title;
  }

  void setAlphaOverrides (float alphaOverride) {
    for (int a = 0; a < rail.size (); a ++)
      alphaOverrides [a] = alphaOverride;
  }
}
