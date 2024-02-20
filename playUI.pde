void playUI () {
  float xPos = playOverlay.x;
  float yPos = playOverlay.y;
  
  textFont (fonts.roboto.medium);

  fill(255);
  float tSize = (d - d*0.03*(4 + 1))/4; // Where n is 4
  textSize(tSize*0.3);

  textAlign (RIGHT, CENTER);  
  text("Moves: " + moves, xPos + width/2 + d/2, yPos + (height - d)/4);

  textAlign (LEFT, CENTER);  
  text("High Score: " + highScore, xPos + width/2 - d/2, yPos + (height - d)/4);

  // Main container square
  fill (255, 255*0.15);  // 15%
  noStroke ();
  rect (xPos + x, yPos + y, d, d, r);

  // Each of the elements
  textAlign (CENTER, CENTER);
  textSize(eachD*0.33);
  for (int a = 0; a < n; a ++) {
    for (int b = 0; b < n; b ++) {
      int number = table [b] [a];

      // Drawing Square
      if (number == 0)
        fill (255, 255*0.25);  // 25%
      else {
        int index = int(log (number)/log (2)) - 1;
        fill (colors [index]);
      }
      rect(xPos + startX + gap*a + eachD*a, yPos + startY + gap*b + eachD*b, eachD, eachD, r/(n/2));

      // Drawing Text
      if (number < 8)
        fill (#535353);
      else
        fill (255);
      if (number != 0)
        text(number, xPos + startX + gap*a + eachD*a + eachD/2, yPos + startY + gap*b + eachD*b + eachD/2 - textDescent ()/2);
    }
  }

  float buttonGap =  width*0.255;
  float buttonPosY = height/2 + d/2 + (height - d)/4;

  textFont (fonts.roboto.black);
  undo.draw (xPos + width/2 - buttonGap, yPos + buttonPosY);
  if (history.size () > 0)
    undo.showBubble (history.size ());

  restart.draw (xPos + width/2, yPos + buttonPosY);
  home.draw (xPos + width/2 + buttonGap, yPos + buttonPosY);
}

void prompts () {
  float x = promptOverlay.x;
  float y = promptOverlay.y;
  float w = promptOverlay.w;
  float h = promptOverlay.h;
  
  
  textFont (fonts.roboto.medium);
  textAlign (CENTER, CENTER);
  textSize (width*0.06);
  fill (brightOrange);
  text (promptLabel, x + w/2, y + h/2 - textDescent ()/2);
  
  yes.draw (x + padding, y + h/2);
  no.draw (x + w - padding, y + h/2);
}
