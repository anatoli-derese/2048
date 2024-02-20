class Button {
  // Alpha
  float fillAlphaP = 255;
  float fillAlphaU = 255;
  float strokeAlphaP = 255;
  float strokeAlphaU = 255;
  float shapeAlphaP = 255;
  float shapeAlphaU = 255;
  float labelAlphaP = 255;
  float labelAlphaU = 255;

  float tempFillAlphaU;
  float tempStrokeAlphaU;
  float tempShapeAlphaU;

  float shapePercentage = 0.6;
  float labelPercentage = 1.3;
  float alphaOverride = 0;
  float curvature;

  int pressedX, pressedY;

  int bubbleAlphaP = 255;
  int bubbleAlphaU = 255;
  int bubbleStrokeAlphaP = 255;
  int bubbleStrokeAlphaU = 255;
  int bubbleTextAlphaP = 255;
  int bubbleTextAlphaU = 255;

  int bubblePosition = 1; // 0 - Top Left Corner    1 - Top Right Corner    2 - Bottom Right Corner    3 - Bottom Left Corner
  int alignmentX = CENTER;
  int alignmentY = CENTER;
  int alignLabelX = CENTER;
  int alignLabelY = CENTER;

  float x, y;
  float d;
  float w, h;

  float t = -1;
  float bubbleT = -1;

  color fillColorP = -1;
  color fillColorU = -1;
  color strokeColorP = -1;
  color strokeColorU = -1;
  color shapeColorP = -1;
  color shapeColorU = -1;
  color originalShapeColorP = -1;
  color originalShapeColorU = -1;
  color labelColorP = -1;
  color labelColorU = -1;
  color bubbleColorP = -1;
  color bubbleColorU = -1;
  color bubbleStrokeP = -1;
  color bubbleStrokeU = -1;
  color bubbleTextP = -1;
  color bubbleTextU = -1;

  String title;
  String label;
  String activeOnPage;

  PShape shape;
  PFont font;

  boolean rectangle;

  Button (float d) {
    this.d = d;
  }

  Button (float d, float t) {
    this.d = d;
    this.t = t;
  }
  Button (float w, float h, float t) {
    this.w = w;
    this.h = h;
    this.t = t;

    rectangle = true;
  }

  void activeOnPage (String pageActiveOn) {
    this.activeOnPage = pageActiveOn;
  }

  void setAlignment (int alignmentX, int alignmentY) {
    this.alignmentX = alignmentX;
    this.alignmentY = alignmentY;
  }

  void draw (float x, float y, float d) {
    this.d = d;
    draw (x, y);
  }
  void draw (float x, float y) {
    this.x = x;
    this.y = y;
    draw ();
  }
  void draw() {
    fixAlignment (x, y);

    boolean hoveringCondition;
    if (rectangle)
      hoveringCondition = hovered (pressedX, pressedY, x, y, w, h, CENTER) && hovered (x, y, w, h, CENTER) && mousePressed && isActive ();
    else
      hoveringCondition = hovered (pressedX, pressedY, x, y, d, CENTER) && hovered (x, y, d, CENTER) && mousePressed && isActive ();

    if (hoveringCondition) {
      if (fillColorP != -1)
        fill(fillColorP, fillAlphaP*(1 - alphaOverride));
      else
        noFill ();

      if (strokeColorP != -1)
        stroke (strokeColorP, strokeAlphaP*(1 - alphaOverride));
      else
        noStroke ();
    } else {
      if (fillColorU != -1)
        fill(fillColorU, fillAlphaU*(1 - alphaOverride));
      else
        noFill ();

      if (strokeColorU != -1)
        stroke (strokeColorU, strokeAlphaU*(1 - alphaOverride));
      else
        noStroke ();
    }
    if (t != -1)
      strokeWeight(t);

    rectMode (CENTER);
    ellipseMode (CENTER);

    if (rectangle)
      rect (x, y, w, h, curvature);
    else
      circle (x, y, d);

    if (shape != null) {
      shape.disableStyle();
      if (hoveringCondition) {
        if (shapeColorP != -1)
          fill(shapeColorP, shapeAlphaP*(1 - alphaOverride));
        else
          noFill ();
      } else {
        if (shapeColorU != -1)
          fill(shapeColorU, shapeAlphaU*(1 - alphaOverride));
        else
          noFill ();
      }
      noStroke ();
      shapeMode (CENTER);
      shape(shape, x, y, d*shapePercentage, d*shapePercentage);
    }

    if (label != null) {
      if (hoveringCondition) {
        if (labelColorP != -1)
          fill(labelColorP, labelAlphaP*(1 - alphaOverride));
        else
          noFill ();
      } else {
        if (labelColorU != -1)
          fill(labelColorU, labelAlphaU*(1 - alphaOverride));
        else
          noFill ();
      }

      if (font != null)
        textFont (font);
      textAlign (alignLabelX, alignLabelY);
      if (rectangle)
        textSize (h*0.5*0.45*labelPercentage);
      else
        textSize (d*0.5*0.45*labelPercentage);
      
      float posX = x;
      if(alignLabelX == RIGHT)
        posX += rectangle? w/2 : d/2;
      else if(alignLabelX == LEFT)
        posX -= rectangle? w/2 : d/2;
      text(label, posX, y - textDescent ()/2);
    }
  }

  float fixX (float x) {
    float dx = 0;

    if (alignmentX == CENTER)
      dx = x;
    else if (alignmentX == LEFT)
      dx = x + d/2;
    else if (alignmentX == RIGHT)
      dx = x - d/2;

    return dx;
  }
  float fixY (float y) {
    float dy = 0;

    if (alignmentY == CENTER)
      dy = y;
    else if (alignmentY == TOP)
      dy = y + d/2;
    else if (alignmentY == BOTTOM)
      dy = y - d/2;

    return dy;
  }

  void fixAlignment (float x, float y) {
    this.x = fixX (x);
    this.y = fixY (y);
  }

  void setFill (color fillColorU, float fillAlphaU, color fillColorP, float fillAlphaP) {
    this.fillColorP = fillColorP;
    this.fillAlphaP = fillAlphaP;
    this.fillColorU = fillColorU;
    this.fillAlphaU = fillAlphaU;
  }
  void setStroke (color strokeColorU, float strokeAlphaU, color strokeColorP, float strokeAlphaP) {
    this.strokeColorP = strokeColorP;
    this.strokeAlphaP = strokeAlphaP;
    this.strokeColorU = strokeColorU;
    this.strokeAlphaU = strokeAlphaU;
  }

  void setShape (PShape shape, color shapeColorU, float shapeAlphaU, color shapeColorP, float shapeAlphaP) {
    this.shape = shape;
    this.shapeColorP = shapeColorP;
    this.shapeAlphaP = shapeAlphaP;
    this.shapeColorU = shapeColorU;
    this.shapeAlphaU = shapeAlphaU;

    originalShapeColorU = shapeColorU;
    originalShapeColorP = shapeColorP;
  }
  void setShape (PShape shape, String title, color shapeColorU, float shapeAlphaU, color shapeColorP, float shapeAlphaP) {
    this.title = title;
    setShape (shape, shapeColorU, shapeAlphaU, shapeColorP, shapeAlphaP);
  }

  void setLabel (String label, color labelColorU, float labelAlphaU, color labelColorP, float labelAlphaP) {
    this.label = label;
    this.labelColorU = labelColorU;
    this.labelAlphaU = labelAlphaU;
    this.labelColorP = labelColorP;
    this.labelAlphaP = labelAlphaP;
  }
  void setLabel (String label, PFont font, color labelColorU, float labelAlphaU, color labelColorP, float labelAlphaP) {
    this.label = label;
    this.font = font;
    this.labelColorU = labelColorU;
    this.labelAlphaU = labelAlphaU;
    this.labelColorP = labelColorP;
    this.labelAlphaP = labelAlphaP;
  }

  void setBubble (int bubblePosition, int bubbleT, color bubbleColorU, int bubbleAlphaU, color bubbleColorP, int bubbleAlphaP) {
    this.bubblePosition = bubblePosition;
    this.bubbleT = bubbleT;
    this.bubbleColorU = bubbleColorU;
    this.bubbleAlphaU = bubbleAlphaU;
    this.bubbleColorP = bubbleColorP;
    this.bubbleAlphaP = bubbleAlphaP;
  }
  void setBubbleStroke (color bubbleStrokeU, int bubbleStrokeAlphaU, color bubbleStrokeP, int bubbleStrokeAlphaP) {
    this.bubbleStrokeU = bubbleStrokeU;
    this.bubbleStrokeAlphaU = bubbleStrokeAlphaU;
    this.bubbleStrokeP = bubbleStrokeP;
    this.bubbleStrokeAlphaP = bubbleStrokeAlphaP;
  }
  void setBubbleTextFill (color bubbleTextU, int bubbleTextAlphaU, color bubbleTextP, int bubbleTextAlphaP) {
    this.bubbleTextU = bubbleTextU;
    this.bubbleTextAlphaU = bubbleTextAlphaU;
    this.bubbleTextP = bubbleTextP;
    this.bubbleTextAlphaP = bubbleTextAlphaP;
  }

  void showBubble (int num) {
    showBubble (str(num));
  }
  void showBubble (String s) {
    float bubbleX, bubbleY;
    float theta = radians (135 - 90*bubblePosition);

    bubbleX = x + d*0.5*cos (theta);
    bubbleY = y - d*0.5*sin (theta);

    if (hovered (pressedX, pressedY, x, y, d, CENTER) && hovered (x, y, d, CENTER) && mousePressed && isActive ()) {
      if (bubbleColorP != -1)
        fill(bubbleColorP, bubbleAlphaP*(1 - alphaOverride));
      else
        noFill ();

      if (bubbleStrokeP != -1)
        stroke (bubbleStrokeP, bubbleAlphaP*(1 - alphaOverride));
      else
        noStroke ();
    } else {
      if (bubbleColorU != -1)
        fill(bubbleColorU, bubbleAlphaU*(1 - alphaOverride));
      else
        noFill ();

      if (bubbleStrokeU != -1)
        stroke (bubbleStrokeU, bubbleAlphaU*(1 - alphaOverride));
      else
        noStroke ();
    }
    if (bubbleT != -1)
      strokeWeight(d*0.1);
    ellipseMode (CENTER);
    circle (bubbleX, bubbleY, d*0.4);

    if (hovered (pressedX, pressedY, x, y, d, CENTER) && hovered (x, y, d, CENTER) && mousePressed && isActive ()) {
      if (bubbleTextP != -1)
        fill(bubbleTextP, bubbleTextAlphaP*(1 - alphaOverride));
      else
        noFill ();
    } else {
      if (bubbleTextU != -1)
        fill(bubbleTextU, bubbleTextAlphaU*(1 - alphaOverride));
      else
        noFill ();
    }

    textAlign (CENTER, CENTER);
    textSize (d*0.5*0.45);
    text(s, bubbleX, bubbleY - textDescent ()/2);
  }

  void setShapeLocation (String shapeLocation) {
    shape = loadShape (shapeLocation);
  }

  boolean isActive () {
    if (activeOnPage == null)
      return true;
    return activeOnPage.equals (page);
  }

  boolean hovered (float x, float y, float r, float mode) {
    return circleHovered (x, y, r, mode);
  }
  boolean hovered (float mouseX, float mouseY, float x, float y, float r, float mode) {
    return circleHovered (mouseX, mouseY, x, y, r, mode);
  }

  boolean hovered (float x, float y, float w, float h, float mode) {
    return rectHovered (x, y, w, h, mode);
  }
  boolean hovered (float mouseX, float mouseY, float x, float y, float w, float h, float mode) {
    return rectHovered (mouseX, mouseY, x, y, w, h, mode);
  }

  boolean rectHovered(float x, float y, float w, float h, float orientation) {
    return (((orientation == CORNER && mouseX >= x && mouseX <= x + w && mouseY >= y && mouseY <= y + h) || (orientation == CENTER && mouseX >= x - w/2 && mouseX <= x + w/2 && mouseY >= y - h/2 && mouseY <= y + h/2))? true : false);
  }
  boolean rectHovered(float mouseX, float mouseY, float x, float y, float w, float h, float orientation) {
    return (((orientation == CORNER && mouseX >= x && mouseX <= x + w && mouseY >= y && mouseY <= y + h) || (orientation == CENTER && mouseX >= x - w/2 && mouseX <= x + w/2 && mouseY >= y - h/2 && mouseY <= y + h/2))? true : false);
  }

  boolean circleHovered (float x, float y, float rad, float mode) {
    return mode == CORNER && dist(mouseX, mouseY, x + rad/2, y + rad/2) <= rad/2 ||
      mode == CENTER && dist(mouseX, mouseY, x, y) <= rad/2 ? true : false;
  }

  boolean circleHovered (float mouseX, float mouseY, float x, float y, float rad, float mode) {
    return mode == CORNER && dist(mouseX, mouseY, x + rad/2, y + rad/2) <= rad/2 ||
      mode == CENTER && dist(mouseX, mouseY, x, y) <= rad/2 ? true : false;
  }

  void pressed () {
    pressedX = mouseX;
    pressedY = mouseY;
  }

  boolean released () {
    if (rectangle)
      return rectHovered (x, y, w, h, CENTER) && rectHovered (pressedX, pressedY, x, y, w, h, CENTER) && isActive ();
    else
      return circleHovered (x, y, d, CENTER) && circleHovered (pressedX, pressedY, x, y, d, CENTER) && isActive ();
  }
}
