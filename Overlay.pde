class Overlay {
  float w, h;
  float x, y;
  float toX, toY;
  float originalX, originalY;
  float pressedX, pressedY;

  float opacity = 0;
  float toOpacity = 0;

  float curtainAlphaU = 0;
  float curtainAlphaP = 255*0.4;
  float transitionFactor = 0.05;
  float transitionFactorInt = -1;
  float transitionFactorToShow = transitionFactor;
  float transitionFactorToHide = transitionFactor;

  float pixelThreshold = 2;

  int swipeTo;

  color curtainFill = -1;

  color background = 0;
  color fromGradient = -1, toGradient = -1;

  char gradientAxis = 'y';

  boolean multiTransitionFactor;
  boolean hiding;

  Overlay (float w, float h, int swipeTo) {
    this.w = w;
    this.h = h;

    this.swipeTo = swipeTo;

    if (swipeTo == RIGHT) {
      x = -w - 1;
      y = 0;
    } else if (swipeTo == LEFT) {
      x = width + 1;
      y = 0;
    } else if (swipeTo == UP) {
      x = 0;
      y = height + 1;
    } else if (swipeTo == DOWN) {
      x = 0;
      y = -h - 1;
    }
    originalX = x;
    originalY = y;

    hide ();
  }

  void setCurtainFill (color curtainFill, float curtainAlphaU, float curtainAlphaP) {
    this.curtainFill = curtainFill;
    this.curtainAlphaU = curtainAlphaU;
    this.curtainAlphaP = curtainAlphaP;
  }

  void setFill (int r, int g, int b) {
    background = color (r, g, b);
  }
  void setFill (color c) {
    background = c;
  }
  void setFill (color gradientFrom, color gradientTo) {
    this.fromGradient = gradientFrom;
    this.toGradient = gradientTo;
  }
  void setFill (char gradientAxis, color gradientFrom, color gradientTo) {
    this.gradientAxis = gradientAxis;
    this.fromGradient = gradientFrom;
    this.toGradient = gradientTo;
  }

  void show () {
    hiding = false;
    if (swipeTo == RIGHT) {
      toX = 0;
      toY = 0;
    } else if (swipeTo == LEFT) {
      toX = width-w;
      toY = 0;
    } else if (swipeTo == UP) {
      toX = 0;
      toY = height - h;
    } else if (swipeTo == DOWN) {
      toX = 0;
      toY = 0;
    }

    toOpacity = curtainAlphaP;
  }
  void hide () {
    hiding = true;
    toX = originalX;
    toY = originalY;

    toOpacity = curtainAlphaU;
  }

  void setTransitionFactor (float transitionFactor) {
    transitionFactorInt = -1;
    this.transitionFactor = abs(transitionFactor);
  }
  void setTransitionFactor (float transitionFactorToShow, float transitionFactorToHide) {
    transitionFactorInt = -1;
    multiTransitionFactor = true;
    this.transitionFactorToShow = transitionFactorToShow;
    this.transitionFactorToHide = transitionFactorToHide;
  }
  void setTransitionFactor (int transitionFactorInt) {
    this.transitionFactorInt = abs(transitionFactorInt);
    transitionFactor = -1;
  }

  void draw () {
    rectMode (CORNER);
    noStroke();

    // Curtain
    float distance;
    if (swipeTo == RIGHT) {
      distance = dist (0, 0, 0, x);
      opacity = map (distance, 0, w, curtainAlphaP, curtainAlphaU);
    } else if (swipeTo == LEFT) {
      distance = dist (0, width, 0, x);
      opacity = map (distance, 0, w, curtainAlphaU, curtainAlphaP);
    } else if (swipeTo == UP) {
      distance = dist (0, y, 0, height);
      opacity = map (distance, 0, h, curtainAlphaU, curtainAlphaP);
    } else if (swipeTo == DOWN) {
      distance = dist (0, 0, 0, y);
      opacity = map (distance, 0, h, curtainAlphaU, curtainAlphaP);
    } 
    fill (curtainFill, opacity);
    rect (0, 0, width, height);

    // Overlay
    if (fromGradient != -1)
      setGradient((int) x, (int) y, (int) w, (int) h, fromGradient, toGradient, gradientAxis);
    else {
      fill (background);
      rect ((int) x, (int) y, (int) w + 1, (int) h);
    }
  }

  void transitionUpdates () {
    if (transitionFactor != -1) {
      if (multiTransitionFactor) {
        if (hiding) {
          x = lerp (x, toX, transitionFactorToHide);
          y = lerp (y, toY, transitionFactorToHide);
        } else {
          x = lerp (x, toX, transitionFactorToShow);
          y = lerp (y, toY, transitionFactorToShow);
        }
      } else {
        x = lerp (x, toX, transitionFactor);
        y = lerp (y, toY, transitionFactor);
      }
      if (dist (x, 0, toX, 0) < pixelThreshold) x = toX;
      if (dist (y, 0, toY, 0) < pixelThreshold) y = toY;
    } else if (transitionFactorInt != -1) {
      if (swipeTo == RIGHT || swipeTo == LEFT) {
        if (x < toX - transitionFactorInt)
          x += transitionFactorInt;
        else if (x > toX + transitionFactorInt)
          x -= transitionFactorInt;
        else
          x = toX;
      } else {
        if (y < toY - transitionFactorInt)
          y += transitionFactorInt;
        else if (y > toY + transitionFactorInt)
          y -= transitionFactorInt;
        else {
          y = toY;
        }
      }
    }
  }

  boolean isVisible () {
    boolean visible = false;

    if (swipeTo == RIGHT)
      visible = (int) x > (int) originalX;
    else if (swipeTo == LEFT)
      visible = (int) x < (int) originalX;
    else if (swipeTo == UP)
      visible = (int) y < (int) originalY;
    else if (swipeTo == DOWN)
      visible = (int) y > (int) originalY;

    transitionUpdates ();

    return visible;
  }

  float distTo () {
    float distance = 0;
    if (swipeTo == RIGHT)
      distance = dist (0, 0, 0, x);
    else if (swipeTo == LEFT)
      distance = dist (0, width, 0, x);
    else if (swipeTo == UP)
      distance = dist (0, y, 0, height);
    else if (swipeTo == DOWN)
      distance = dist (0, 0, 0, y);
    return distance;
  }

  float maxDistTo () {
    float distance = 0;
    if (swipeTo == RIGHT || swipeTo == LEFT)
      distance = w;
    else if (swipeTo == UP || swipeTo == DOWN)
      distance = h;
    return distance;
  }

  boolean pressedOutside () {
    boolean leaving = !rectHovered (x, y, w, h, CORNER);
    if (leaving)
      hide ();
    return leaving;
  }
  boolean pressedOutside (boolean hide) {
    boolean leaving = !rectHovered (x, y, w, h, CORNER) && !rectHovered (pressedX, pressedY, x, y, w, h, CORNER);
    if (leaving && hide)
      hide ();
    return leaving;
  }

  boolean rectHovered(float x, float y, float w, float h, float orientation) {
    return (((orientation == CORNER && mouseX >= x && mouseX <= x + w && mouseY >= y && mouseY <= y + h) || (orientation == CENTER && mouseX >= x - w/2 && mouseX <= x + w/2 && mouseY >= y - h/2 && mouseY <= y + h/2))? true : false);
  }
  boolean rectHovered(float mouseX, float mouseY, float x, float y, float w, float h, float orientation) {
    return (((orientation == CORNER && mouseX >= x && mouseX <= x + w && mouseY >= y && mouseY <= y + h) || (orientation == CENTER && mouseX >= x - w/2 && mouseX <= x + w/2 && mouseY >= y - h/2 && mouseY <= y + h/2))? true : false);
  }
  
  void pressed () {
    pressedX = mouseX;
    pressedY = mouseY;
  }
}
