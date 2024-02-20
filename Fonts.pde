class Fonts {
  Roboto roboto;
  Caros caros;

  Fonts () {
    roboto = new Roboto ();
    caros = new Caros ();
  }
}

class Roboto {
  PFont medium, regular, bold, black;

  Roboto () {
    medium = createFont ("/data/fonts/roboto-medium.ttf", 10);
    regular = createFont ("/data/fonts/roboto-regular.ttf", 10);
    bold = createFont ("/data/fonts/roboto-bold.ttf", 10);
    black = createFont ("/data/fonts/roboto-black.ttf", 10);
  }
}

class Caros {
  PFont eLight, light, regular;

  Caros () {
    eLight = createFont ("/data/fonts/caros-elight.otf", 10);
    light = createFont ("/data/fonts/caros-light.otf", 10);
    regular = createFont ("/data/fonts/caros-regular.otf", 10);
  }
}
