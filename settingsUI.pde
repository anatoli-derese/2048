void settingsUI () {
  textFont (fonts.caros.eLight);
  textAlign (LEFT, TOP);
  textSize (width*0.05);
  fill (255);

  text ("Settings", int(padding*0.6 + settingsOverlay.x), int(padding + settingsOverlay.y));

  float navigationX = settingsOverlay.x;
  float navigationY = settingsOverlay.y + padding*2.2;
  float navigationW = settingsOverlay.w;
  float navigationH = padding*1.2;

  noStroke ();
  fill (255);
  rectMode (CORNER);
  rect (settingsOverlay.x, navigationY, navigationW, navigationH);

  textFont (fonts.caros.regular);
  textAlign (LEFT, CENTER);
  textSize (width*0.033);
  fill (orange);
  text (settingsRail.getFocusedTitle (), int(navigationX + padding*0.6), navigationY + navigationH/2);

  if (settingsRail.getFocusedTitle () == "Controls") {
    animations.draw (int(padding*0.6 + settingsOverlay.x), navigationY + navigationH);
    visuals.draw (int(padding*0.6 + settingsOverlay.x), navigationY + navigationH + animations.getTotalH ());
  } else if (settingsRail.getFocusedTitle () == "Gameplay") {
    personalize.draw (int(padding*0.6 + settingsOverlay.x), navigationY + navigationH);
  }

  exit.draw (settingsOverlay.x + settingsOverlay.w/2, settingsOverlay.y + settingsOverlay.h - padding);

  settingsRail.draw (settingsOverlay.x + settingsOverlay.w + (width - settingsOverlay.w)/2, 0);
  settingsRail.alphaOverride = map (settingsOverlay.distTo (), 0, settingsOverlay.maxDistTo(), 1, 0);
  settingsRail.setAlphaOverrides (map (settingsOverlay.distTo (), 0, settingsOverlay.maxDistTo(), 0, 1));

  settings.alphaOverride = map (settingsOverlay.distTo (), 0, settingsOverlay.maxDistTo(), 1, 0);
  homePlay.alphaOverride = map (settingsOverlay.distTo (), 0, settingsOverlay.maxDistTo(), 1, 0);
}
