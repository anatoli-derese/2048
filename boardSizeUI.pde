String boardType [] = {"Small", "Classic", "Big", "Huge", "Gigantic"};

void boardSizeUI () {
  float x = boardSizeOverlay.x, y = boardSizeOverlay.y;
  float w = boardSizeOverlay.w, h = boardSizeOverlay.h;

  // Overlay Title
  textFont (fonts.caros.eLight);
  textAlign (CENTER, TOP);
  textSize (width*0.05);
  fill (255);

  text ("Board Size", x + w/2, y + padding);
  
  homePlay.alphaOverride = map (boardSizeOverlay.distTo (), 0, boardSizeOverlay.maxDistTo(), 0, 1);
  settings.alphaOverride = map (boardSizeOverlay.distTo (), 0, boardSizeOverlay.maxDistTo(), 0, 1);

  // Overlay Grid
  boardGrid.scale (0.65);
  boardGrid.showFilm(x + w/2, y + h/2, true);
  boardGrid.draw (x + w/2, y + h/2, true);

  // Board Type
  textFont (fonts.caros.regular);
  textAlign (CENTER, TOP);
  textSize (width*0.028);
  fill (255, 255*0.9);

  text (boardType [boardDimension - 3] + " - " + boardGrid.m + "x" + boardGrid.n, 
    x + w/2, y + h/2 + boardGrid.filmH/2 + padding/2);

  // Buttons
  if (boardDimension > minBoardDimension)
    left.draw (x + (w - boardGrid.filmW)/4, y + h/2);
  if (boardDimension < maxBoardDimension)
    right.draw (x + w - (w - boardGrid.filmW)/4, y + h/2);
  
  boardPlay.draw (x + w/2, y + h - padding);
}
