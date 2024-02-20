void setGradient(float x, float y, float w, float h, color c1, color c2, char axis ) {
  // calculate differences between color components 
  float deltaR = red(c2)-red(c1);
  float deltaG = green(c2)-green(c1);
  float deltaB = blue(c2)-blue(c1);

  // choose axis
  if (axis == 'y') {
    /*nested for loops set pixels
     in a basic table structure */
    // column
    for (float i=x; i<=(x+w); i++) {
      // row
      for (float j = y; j<=(y+h); j++) {
        color c = color(
          (red(c1)+(j-y)*(deltaR/h)), 
          (green(c1)+(j-y)*(deltaG/h)), 
          (blue(c1)+(j-y)*(deltaB/h)) 
          );
        set((int) i, (int) j, c);
      }
    }
  } else if (axis == 'x') {
    // column 
    for (float i=y; i<=(y+h); i++) {
      // row
      for (float j = x; j<=(x+w); j++) {
        color c = color(
          (red(c1)+(j-x)*(deltaR/h)), 
          (green(c1)+(j-x)*(deltaG/h)), 
          (blue(c1)+(j-x)*(deltaB/h))
          );
        set((int) j, (int) i, c);
      }
    }
  }
}
