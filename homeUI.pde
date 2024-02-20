void homeUI (float x, float y) {

  // Tiles on top
  int tiles = int(width/tile.diagonal) + 1;
  float gap = tile.w*0.1;
  float startX = (width - tiles*tile.diagonal - (tiles - 1)*gap)/2 + tile.diagonal/2;

  for (int a = 0; a < tiles; a ++)
    tile.draw (x + startX + gap*a + tile.diagonal*a, y, QUARTER_PI);

  // Top
  textFont (fonts.caros.eLight);
  textAlign (CENTER, TOP);
  textSize (width*0.1);
  fill (255);
  kernedText ("2048", x + width/2, padding, width*0.8, 0);

  // Grid
  homeGridRotationFactor = millis ()*0.00004;
  homeGrid.draw (x + width/2, height/2, homeGridRotationDirection*homeGridRotationFactor + homeGridTweaker);

  // Bottom
  settings.draw (x + padding, height - padding);
  homePlay.draw (x + width - padding, height - padding);

  textFont (fonts.caros.eLight);
  textAlign (CENTER, CENTER);
  textSize (width*0.03);
  fill (255);
  text ("Modern\nEdition", x + width/2, height - padding - settings.d/2 - textDescent ()/2);
}
