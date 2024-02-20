import java.util.LinkedHashMap;

class Combo {
  float w, h;
  float startY;
  float lineLength;
  float secondaryPadding;

  int alignmentX = CORNER;

  boolean toggle;
  boolean primaryIsToggleType;

  PFont primaryFont;
  PFont secondaryFont;
  PFont buttonFont;

  PShape toggle_on, toggle_off;

  String [] ON_OFF = {"on", "off"};
  String [] SHOW_HIDE = {"show", "hide"};

  color labelColor = 255;

  LinkedHashMap combo;
  LinkedHashMap buttonValues;

  Combo (String label, PFont primaryFont, boolean toggle, float w, float h) {
    this.toggle = toggle;
    this.primaryFont = primaryFont;
    this.w = w;
    this.h = h;

    toggle_on = loadShape ("data/icons/toggle_on.svg");
    toggle_off = loadShape ("data/icons/toggle_off.svg");
    primaryIsToggleType = true;

    Button button = new Button ( h, 0);
    button.setAlignment (CENTER, CENTER);
    button.setFill (255, 255*0, 255, 255*0.15);
    button.setShape (toggle? toggle_on : toggle_off, 255, 255*0.95, 255, 255*1);

    combo = new LinkedHashMap ();
    combo.put (label, button);
    buttonValues = new LinkedHashMap ();
  }

  Combo (String label, PFont primaryFont, float w, float h) {
    this.primaryFont = primaryFont;
    this.w = w;
    this.h = h;

    combo = new LinkedHashMap ();
    combo.put (label, null);
    buttonValues = new LinkedHashMap ();
  }

  void append (String label, PFont secondaryFont, PFont buttonFont, String [] content) {
    this.secondaryFont = secondaryFont;
    this.buttonFont = buttonFont;

    Button button = new Button (h, h, 0);
    button.setAlignment (RIGHT, CENTER);
    button.setFill (255, 255*0, 255, 255*0.25);
    button.curvature = 5;
    button.setLabel (content [0], buttonFont, 255, 255*0.95, 255, 255*1);

    combo.put (label, button);
    buttonValues.put (label, content);
  }

  void draw (float x, float y) {
    float startX = x - (alignmentX == CENTER? w/2 : 0);

    for (int a = 0; a < combo.size(); a ++) {
      textAlign (LEFT, CENTER);
      fill (labelColor);
      if (a == 0) {
        textFont (fonts.caros.regular);
        textSize (width*0.03);
        text(getLabel (a), startX, y + a*h + h/2);

        stroke (255, 255*0.4);
        strokeWeight (1.5);
        line (startX, y + a*h + h, startX + lineLength, y + a*h + h - textDescent ()/2);
      } else {
        textFont (fonts.roboto.regular);
        textSize (width*0.045);
        text(getLabel (a), startX + secondaryPadding, y + a*h + h/2 - textDescent ()/2);
      }

      if (getButton (a) != null)
        getButton (a).draw (startX + w - h/2, y + a*h + h/2);
    }
  }

  float getTotalH () {
    return h*combo.size ();
  }

  String getLabel (int index) {
    ArrayList <String> labels = new ArrayList (combo.keySet());
    return labels.get(index);
  }

  Button getButton (int index) {
    ArrayList <Button> buttons = new ArrayList (combo.values());
    return buttons.get(index);
  }

  String getButtonLabel (int index) {
    if (getButton (index).label != null)
      return getButton (index).label;
    else if (index == 0) {
      return toggle? "on" : "off";
    }
    return getButton (index).label;
  }

  void pressed () {
    for (int a = 0; a < combo.size (); a ++) {
      if (getButton (a) != null)
        getButton (a).pressed ();
    }
  }

  String getNextLabel (int buttonIndex) {
    String content [] = getContents (buttonIndex);

    if (getLabelIndex (buttonIndex) != -1) {
      if (getLabelIndex (buttonIndex) + 1 < content.length)
        return (content [getLabelIndex (buttonIndex) + 1]);
    }
    return (content [0]);
  }

  String getLastLabel (int buttonIndex) {
    String content [] = getContents (buttonIndex);
    return (content [content.length - 1]);
  }

  String getLabelAt (int buttonIndex, int index) {
    String content [] = getContents (buttonIndex);
    return (content [index]);
  }

  int getLabelIndex (int buttonIndex) {
    String label = getButtonLabel (buttonIndex);
    String content [] = getContents (buttonIndex);

    for (int a = 0; a < content.length; a ++) {
      if (content [a].equals (label))
        return a;
    }
    return -1;
  }

  String [] getContents (int index) {
    ArrayList <String []> contents = new ArrayList (buttonValues.values());
    return contents.get (index - 1);
  }

  void released () {
    for (int a = 0; a < combo.size (); a ++) {
      if (getButton (a) != null)
        if (getButton (a).released ()) {
          if (a == 0) {
            toggle = !toggle;
            getButton (0).shape = toggle? toggle_on : toggle_off;
            if (toggle == false)
              for (a = 1; a < combo.size (); a ++) getButton (a).label = getLastLabel (a);
            else
              for (a = 1; a < combo.size (); a ++) getButton (a).label = getLabelAt (a, 0);
          } else {
            getButton (a).label = getNextLabel (a);

            if (primaryIsToggleType) {
              boolean allAtLastState = true;
              for (a = 1; a < combo.size (); a ++)
                if (!getButton (a).label.equals (getLastLabel (a)))
                  allAtLastState = false;

              toggle = !allAtLastState;
              getButton (0).shape = toggle? toggle_on : toggle_off;
            }
          }
        }
    }
  }
}
