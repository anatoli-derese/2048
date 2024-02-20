color white = #FFFFFF;
color brightOrange = #FF5929;
color orange = #FE5928;
color darkOrange = #8D2D1D;
color darkPurple = #B23035;

color colors [] = {#EEE4DA, #FFEAC4, #FFB277, #F79663, #F77D5A, #F65E3B, #FE5928, #FFE17E, #EDCC61};

String highScorePath = "/data/file/highscore.txt";
String lastTableSizePath = "/data/file/recentTableSize.txt";
String statePath = "/data/file/state.txt";
String page = "Home";
String promptLabel;

float x, y;
float d;
float r;
float startX, startY;
float eachD, gap;
float padding;
float homeGridRotationFactor;
float homeGridTweaker;
float homeGridRotationDirection = 1;

int n = 4;
int highScore;
int moves;
int historyLimit = 4;

int minBoardDimension = 3;
int defaultBoardDimension = 4;
int maxBoardDimension = 7;
int boardDimension = defaultBoardDimension;

int pressedX, pressedY;

Button undo, restart, home;
Button settings, homePlay;
Button left, right, boardPlay;
Button yes, no;
Button controls, gameplay, donate, info, help, exit;

Rail settingsRail;

Combo animations, visuals;
Combo personalize;

Fonts fonts;

Grid homeGrid;
Grid tile;
Grid boardGrid;

Overlay settingsOverlay, boardSizeOverlay, playOverlay;
Overlay promptOverlay;

void setup() {
  size (383, 680);
  surface.setLocation (displayWidth - width - 150, 10);

  fonts = new Fonts ();

  boardDimension = getLastBoardDimension ();
  initialize ();

  float rad = width * 0.15;

  // Playing Board Page Buttons
  undo = new Button (rad);
  undo.setFill (255, 255*0.15, 255, 255*0.25);
  undo.setShape (loadShape ("data/icons/undo.svg"), 255, 255*0.75, 255, 255*1);
  undo.setBubble (1, 1, #FE5928, 255, #FE5928, 255);
  undo.setBubbleStroke (#C43A32, 255, #C43A32, 255);
  undo.setBubbleTextFill (255, 255, 255, 255);

  restart = new Button (rad);
  restart.shapePercentage = 0.5;
  restart.setFill (255, 255*0.15, 255, 255*0.25);
  restart.setShape (loadShape ("data/icons/restart.svg"), 255, 255*0.75, 255, 255*1);

  home = new Button (rad);
  home.setFill (255, 255*0.15, 255, 255*0.25);
  home.setShape (loadShape ("data/icons/home.svg"), 255, 255*0.75, 255, 255*1);

  // Home Page Buttons
  settings = new Button (rad*1.2, 2);
  settings.setStroke (255, 255*0.85, 255, 255);
  settings.setShape (loadShape ("data/icons/settings.svg"), 255, 255*0.85, 255, 255*1);
  settings.shapePercentage = 0.5;
  settings.setAlignment (LEFT, BOTTOM);
  settings.activeOnPage("Home");

  homePlay = new Button (rad*1.2, 2);
  homePlay.setStroke (255, 255*0.85, 255, 255);
  homePlay.setShape (loadShape ("data/icons/play.svg"), 255, 255*0.85, 255, 255*1);
  homePlay.shapePercentage = 0.5;
  homePlay.setAlignment (RIGHT, BOTTOM);
  homePlay.activeOnPage("Home");

  // Board Size Page Buttons
  left = new Button (rad*0.85, 2);
  left.setFill (255, 0, 255, 255*0.15);
  left.setShape (loadShape ("data/icons/left.svg"), 255, 255*0.5, 255, 255*1);
  left.shapePercentage = 0.4;
  left.activeOnPage("BoardSize");

  right = new Button (rad*0.85, 2);
  right.setFill (255, 0, 255, 255*0.15);
  right.setShape (loadShape ("data/icons/right.svg"), 255, 255*0.5, 255, 255*1);
  right.shapePercentage = 0.4;
  right.activeOnPage("BoardSize");

  boardPlay = new Button (rad*1.2, 2);
  boardPlay.setStroke (255, 255*0.85, 255, 255);
  boardPlay.setShape (loadShape ("data/icons/play.svg"), 255, 255*0.85, 255, 255*1);
  boardPlay.shapePercentage = 0.5;
  boardPlay.setAlignment (CENTER, BOTTOM);
  boardPlay.activeOnPage("BoardSize");

  // Restart page buttons
  yes = new Button (rad*1.2, 3);
  yes.setStroke (brightOrange, 255*0.95, brightOrange, 255);
  yes.setFill (255, 0, brightOrange, 255);
  yes.setLabel ("Yes", fonts.roboto.medium, brightOrange, 255*0.95, 255, 255);
  yes.setAlignment (LEFT, CENTER);

  no = new Button (rad*1.2, 3);
  no.setStroke (255, 255*0.85, 255, 255);
  no.setFill (brightOrange, 255*0.95, brightOrange, 255);
  no.setLabel ("No", fonts.roboto.medium, 255, 255*0.85, 255, 255);
  no.setAlignment (RIGHT, CENTER);

  // Overlays
  settingsOverlay = new Overlay (width*0.72, height, RIGHT);
  settingsOverlay.setCurtainFill (0, 0, 150);
  settingsOverlay.setFill (orange, darkPurple);
  settingsOverlay.setTransitionFactor(0.15, 0.15);

  boardSizeOverlay = new Overlay (width*0.72, height, LEFT);
  boardSizeOverlay.setCurtainFill (0, 0, 150);
  boardSizeOverlay.setFill (orange, darkPurple);
  boardSizeOverlay.setTransitionFactor(0.15, 0.15);

  playOverlay = new Overlay (width, height, RIGHT);
  playOverlay.setCurtainFill (0, 0, 140);
  playOverlay.setFill (orange, darkPurple);
  playOverlay.setTransitionFactor(0.3, 0.08);

  promptOverlay = new Overlay (width, height*0.2, UP);
  promptOverlay.setCurtainFill (0, 0, 140);
  promptOverlay.setFill (white);
  promptOverlay.setTransitionFactor(0.25);

  // Settings Rail Buttons
  controls = new Button (rad);
  controls.setShape (loadShape ("data/icons/adjust.svg"), "Controls", 255, 255*0.95, 255, 255*1);
  controls.shapePercentage = 0.6;

  gameplay = new Button (rad);
  gameplay.setShape (loadShape ("data/icons/joystick.svg"), "Gameplay", 255, 255*0.95, 255, 255*1);

  donate = new Button (rad);
  donate.setShape (loadShape ("data/icons/donate.svg"), "Donate", 255, 255*0.95, 255, 255*1);

  info = new Button (rad);
  info.setShape (loadShape ("data/icons/info.svg"), "About game", 255, 255*0.95, 255, 255*1);

  help = new Button (rad);
  help.setShape (loadShape ("data/icons/help.svg"), "How to play", 255, 255*0.95, 255, 255*1);

  exit = new Button (settingsOverlay.w*0.85, padding, rad);
  exit.setFill (255, 255*0.1, 255, 255*0.15);
  exit.setLabel ("Leave Game", fonts.caros.regular, 255, 255*0.85, 255, 255);
  exit.labelPercentage = 0.85;
  exit.curvature = 6;
  exit.setAlignment (CENTER, BOTTOM);

  // Rail
  settingsRail = new Rail (settingsOverlay.h);
  settingsRail.append (controls);
  settingsRail.append (gameplay);
  settingsRail.append (donate);
  settingsRail.append (info);
  settingsRail.append (help);
  settingsRail.setGap (controls.d*0.5);
  settingsRail.setFillForEach (255, 255*0, 255, 255*0.25);
  settingsRail.focusedProperties (0, rad*1.1, rad*1.1, 0.25, orange, orange);
  settingsRail.prepare ();

  // Combo - Controls
  animations = new Combo ("Animations", fonts.caros.light, true, settingsOverlay.w - padding*0.6*2, rad);
  animations.append ("visual effects", fonts.roboto.medium, fonts.roboto.bold, animations.ON_OFF);
  animations.append ("gameplay", fonts.roboto.medium, fonts.roboto.bold, animations.ON_OFF);
  animations.append ("transitions", fonts.roboto.medium, fonts.roboto.bold, animations.ON_OFF);
  animations.lineLength = settingsOverlay.w - padding*0.6;
  animations.secondaryPadding = padding*0.2;

  visuals = new Combo ("Visuals", fonts.caros.light, settingsOverlay.w - padding*0.6*2, rad);
  visuals.append ("state on board size", fonts.roboto.medium, fonts.roboto.bold, animations.SHOW_HIDE);
  visuals.lineLength = settingsOverlay.w - padding*0.6;
  visuals.secondaryPadding = padding*0.2;
  
  // Combo - Personalize
  personalize = new Combo ("Personalize", fonts.caros.light, settingsOverlay.w - padding*0.6*2, rad);
  personalize.append ("state outside board", fonts.roboto.medium, fonts.roboto.bold, animations.ON_OFF);
  personalize.append ("undo deducts move", fonts.roboto.medium, fonts.roboto.bold, animations.ON_OFF);
  personalize.append ("tile numbers", fonts.roboto.medium, fonts.roboto.bold, new String [] {"2", "3", "4", "5"});
  personalize.append ("game ends at", fonts.roboto.medium, fonts.roboto.bold, new String [] {"2048", "4096", "8192"});
  personalize.lineLength = settingsOverlay.w - padding*0.6;
  personalize.secondaryPadding = padding*0.2;

  homeGrid = new Grid (3);
  homeGrid.randomOpacity(0.8, 0.3, 0.8);

  tile = new Grid (3);
  tile.setOpacity (0.2);
  tile.scale (0.25);

  boardGrid = new Grid (boardDimension, boardSizeOverlay.w*0.62); // 62% of the overlay width
  boardGrid.gapFactor (0.65);
  boardGrid.randomOpacity (0.5, 0.4, 0.5);
  boardGrid.setFilmFill(255, 255*0.15);
}

void initialize () {
  table = new int [n] [n];
  prevTable = table;
  history = new ArrayList <int [] []> ();

  random2or4 (2);

  moves = 0;

  d = width*0.82;  // 82%
  r = width*0.025*map (n, minBoardDimension, maxBoardDimension, 1, 0.8);

  gap = d*0.03*map (n, minBoardDimension, maxBoardDimension, 1, 0.6);
  eachD = (d - gap*(n + 1))/n;

  startX = (width - d)/2 + gap;
  startY = (height - d)/2 + gap;

  x = width/2 - d/2;
  y = height/2 - d/2;

  padding = height*0.07;
}

void draw () {
  float shiftBy = width*0.5;
  int sign = 0;

  if (settingsOverlay.isVisible ()) {
    sign = 1;
    shiftBy = ceil( map ((int) settingsOverlay.distTo(), 0, (int) settingsOverlay.maxDistTo(), shiftBy, 0));
  } else if (boardSizeOverlay.isVisible ()) {
    sign = -1;
    shiftBy = ceil( map ((int) boardSizeOverlay.distTo(), 0, (int) boardSizeOverlay.maxDistTo(), 0, shiftBy));
  } else if (playOverlay.isVisible ()) {
    sign = 1;
    shiftBy = ceil( map ((int) playOverlay.distTo(), 0, (int) playOverlay.maxDistTo(), shiftBy, 0));
  } 

  if (playOverlay.distTo () != 0) {
    setGradient(0, 0, width, height, orange, darkPurple, 'y');
    homeUI (sign*shiftBy, 0);
    homeGridTweaker = map(sign*shiftBy, -width*0.5, width*0.5, -PI*0.25, PI*0.25);
  }

  if (settingsOverlay.isVisible ()) {
    settingsOverlay.draw ();
    settingsUI ();
  } else if (boardSizeOverlay.isVisible ()) {
    boardSizeOverlay.draw ();
    boardSizeUI ();
  } 
  if (playOverlay.isVisible ()) {
    playOverlay.draw ();
    playUI ();
  }
  if (promptOverlay.isVisible ()) {
    promptOverlay.draw ();
    prompts ();
  }
}

void mousePressed () {
  pressedX = mouseX;
  pressedY = mouseY;

  undo.pressed ();
  restart.pressed ();
  home.pressed ();

  settings.pressed ();
  homePlay.pressed ();

  left.pressed ();
  right.pressed ();
  boardPlay.pressed ();

  yes.pressed ();
  no.pressed ();

  exit.pressed ();

  settingsOverlay.pressed ();
  boardSizeOverlay.pressed ();

  settingsRail.pressed ();

  animations.pressed();
  visuals.pressed();
  personalize.pressed ();
}

void mouseReleased () {
  if (page == "Play") {
    float dx = mouseX - pressedX + 0.0000001;
    float dy = pressedY - mouseY;

    float swipeLength = dist (pressedX, pressedY, mouseX, mouseY);

    float slope = dy/dx;
    float theta = atan(slope)*180/PI;

    if (swipeLength > d*0.1) {

      prevTable = table;

      if (abs(theta) > 45) {
        if (dy < 0) {
          rotateTable (90);
          addAndSlide ();
          rotateTable (-90);
        } else {
          rotateTable (-90);
          addAndSlide ();
          rotateTable (90);
        }
      } else {
        if (dx < 0)
          addAndSlide ();
        else {
          rotateTable (-180);  // Rotate matrix by -180
          addAndSlide ();
          rotateTable (180);   // Rotate matrix by 180
        }
      }


      if (equals (prevTable, table)) {
        println ("NO CHANGE");
      } else {

        if (maxOfTable () > highScore) {
          highScore = maxOfTable ();
          saveHighScore (highScore);
        }

        if (history.size () >= historyLimit) {
          List <int [] []> tempHistory = new ArrayList <int [] []> ();

          for (int a = 1; a < history.size (); a ++)
            tempHistory.add (history.get(a));

          history = tempHistory;
        }
        history.add (prevTable);

        random2or4 ();
        moves ++;

        // Winning
        if (tableHas (512)) println ("You Won!");

        // Game Over
        if (gameOver ())  println ("Game Over!");

        saveState ();
      }
    }

    if (undo.released ()) {
      if (!history.isEmpty()) {
        int lastElement = history.size () - 1;

        table = history.get (lastElement);
        history.remove (lastElement);

        if (moves > 0)
          moves --;
        saveState ();
      }
    } else if (restart.released ()) {
      page = "Restart";
      promptLabel = "Restart?";
      promptOverlay.show ();
    }
    if (home.released ()) {
      page = "Home";
      playOverlay.hide ();
      homeGridRotationDirection = -1;
    }
  }

  // Home Page
  else if (page == "Home") {
    if (homePlay.released ()) {
      page = "BoardSize";
      boardSizeOverlay.show ();
    } else if (settings.released ()) {
      page = "Settings";
      settingsOverlay.show ();
      homeGridRotationDirection = 1;
    }
  }

  // Settings
  else if (page == "Settings") {
    if (settingsOverlay.pressedOutside(false) && settingsRail.pressedOutside ()) {
      page = "Home";
      homeGridRotationDirection = -1;
      settingsOverlay.hide ();
    } else if (exit.released ()) {
      page = "Exit";
      promptLabel = "Exit?";
      promptOverlay.show ();
      settingsOverlay.hide ();
      homeGridRotationDirection = -1;
    } else {
      animations.released ();
      visuals.released ();
      personalize.released ();
    }
  }

  // BoardSize
  else if (page == "BoardSize") {
    if (boardSizeOverlay.pressedOutside (false)) {
      page = "Home";
      homeGridRotationDirection = 1;
      boardSizeOverlay.hide ();
    } else if (boardPlay.released ()) {
      page = "Play";
      playOverlay.show ();
      boardSizeOverlay.hide ();

      n = boardDimension;
      initialize ();
      updateState ();
      saveState ();
    }

    // Chevrons
    else if (left.released ()) {
      if (boardDimension > minBoardDimension) {
        boardDimension --;
        boardGrid.setDimension(boardDimension);

        boardGrid.randomOpacity (0.5, 0.4, 0.5);
        boardGrid.rotateTo (-HALF_PI, 0.15);
        saveBoardDimension (boardDimension);
      } else
        boardGrid.theta -= radians (10);
    } else if (right.released ()) {
      if (boardDimension < maxBoardDimension) {
        boardDimension ++;
        boardGrid.setDimension(boardDimension);

        boardGrid.randomOpacity (0.5, 0.4, 0.5);
        boardGrid.rotateTo (HALF_PI, 0.15);
        saveBoardDimension (boardDimension);
      } else
        boardGrid.theta += radians (10);
    }
  }

  // Restart
  else if (page == "Restart") {
    if (promptOverlay.pressedOutside ()) {
      page = "Play";
      promptOverlay.hide ();
    } else if (yes.released ()) {
      initialize ();
      saveState ();
      page = "Play";
      promptOverlay.hide ();
    } else if (no.released ()) {
      page = "Play";
      promptOverlay.hide ();
    }
  }

  // Exit
  else if (page == "Exit") {
    if (promptOverlay.pressedOutside ()) {
      page = "Home";
    } else if (yes.released ()) {
      promptOverlay.hide ();
      exit ();
    } else if (no.released ()) {
      page = "Home";
      promptOverlay.hide ();
    }
  }
}

void kernedText (String text, float x, float y, float w, float p) {
  float gapW = w*p;
  float charW = (w - gapW*(text.length() - 1))/text.length();
  float startX = x - w/2;

  stroke(255);
  strokeWeight (4);
  for (int a = 0; a < text.length(); a ++)
    text(text.charAt (a), startX + charW*a + gapW*a + charW/2, y);
}
