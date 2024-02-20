import java.util.List;
List <int [] []> history = new ArrayList <int [] []> ();

int table [] [] = new int [n] [n];

int prevTable [] [] = table;

boolean random2or4 () {
  return random2or4 (1);
}

boolean random2or4 (int repeat) {
  for (int a = 0; a < repeat; a ++) {    
    IntList possiblePlaces = new IntList ();

    int counter = 0;
    int numberToPut = random (1) > 0.10? 2 : 4;  // This will be 2, 90% of the time

    for (int r = 0; r < n; r ++) {
      for (int c = 0; c < n; c ++) {
        if (table [r] [c] == 0)
          possiblePlaces.append (counter);
        counter ++;
      }
    }
    if (possiblePlaces.size () == 0)
      return false;
    int randPlace = (int) random (0, possiblePlaces.size());
    int place = possiblePlaces.get (randPlace);

    int r = place/n;
    int c = place%n;

    table [r] [c] = numberToPut;
  }
  return true;
}

void addAndSlide () {
  for (int r = 0; r < n; r ++) {
    for (int c = 0; c < n; c ++) {
      if (table [r] [c] != 0) {
        int j = c + 1;

        while (j < n) {
          if (table [r] [c] != table [r] [j] && table [r] [j] != 0)
            break;
          if (table [r] [c] == table [r] [j]) {
            table [r] [c] *= 2;
            table [r] [j] = 0;
            break;
          }
          j ++;
        }
      }
    }
  }

  int slid [] [] = new int [n] [n];

  for (int r = 0; r < n; r ++) {
    int counter = 0;
    for (int c = 0; c < n; c ++) {
      if (table [r] [c] != 0) {
        slid [r] [counter ++] = table [r] [c];
      }
    }
  }

  table = slid;
}

boolean equals (int table1 [] [], int table2 [] []) {
  for (int r = 0; r < n; r ++) {
    for (int c = 0; c < n; c ++) {
      if (table1 [r] [c] != table2 [r] [c])
        return false;
    }
  }

  return true;
}

boolean tableHas (int val) {
  for (int r = 0; r < n; r ++) {
    for (int c = 0; c < n; c ++) {
      if (table [r] [c] == val)
        return true;
    }
  }

  return false;
}

int maxOfTable () {
  int maxYet = table [0] [0];

  for (int r = 0; r < n; r ++) {
    for (int c = 0; c < n; c ++) {
      maxYet = max (maxYet, table [r] [c]);
    }
  }

  return maxYet;
}

boolean gameOver () {
  if (tableHas (0))
    return false;

  for (int r = 0; r < n - 1; r ++) {
    for (int c = 0; c < n - 1; c ++) {
      if (table [r] [c] == table [r] [c + 1] || table [r] [c] == table [r + 1] [c])
        return false;
    }
  }

  if (n >= 2)
    if (table [n - 1] [n - 1] == table [n - 1] [n - 2] || table [n - 1] [n - 1] == table [n - 2] [n - 1])
      return false;

  return true;
}

void rotateTable (float angle) {
  int rotated [] [] = new int [n] [n];

  angle = radians (angle);

  for (int r = 0; r < n; r ++) {
    for (int c = 0; c < n; c ++) {
      int row = r*round(cos(angle)) + (n-1)*(1 - max(round(cos(angle)), -round(sin(angle)))) - c*round(sin (angle));
      int col = r*round(sin(angle)) + (n-1)*(1 - max(round(sin(angle)), round(cos(angle)))) +  c*round(cos (angle));

      rotated [r] [c] = table [row] [col];
    }
  }

  table = rotated;
}

void saveHighScore (int score) {
  String highScore [] = { str (score) };
  saveStrings (highScorePath, highScore);
}

String currentState () {
  String state = boardDimension + "," + highScore + "," + moves + "-";

  state += tableToString (table);

  if (history.size () > 0) {
    state += "-";
    for (int [] [] table : history)
      state += tableToString (table) + "-";
    state += "=";
    state = state.replace ("-=", "");
  }
  return state;
}

String [] getState () {
  String state [] = loadStrings (statePath);
  return state;
}

boolean boardDimensionExists () {
  String state [] = getState ();

  for (String line : state)
    if (str(line.charAt (0)).equals (str (boardDimension)))
      return true;

  return false;
}
int getBoardDimensionIndex () {
  String state [] = getState ();

  int counter = 0;
  for (String line : state) {
    if (str(line.charAt (0)).equals (str (boardDimension)))
      return counter;
    counter ++;
  }

  return -1;
}

void saveState () {
  String state [] = getState ();

  if (state == null)
    saveStrings (statePath, new String [] { currentState () });
  else {
    if (boardDimensionExists ()) {
      state [getBoardDimensionIndex ()] = currentState ();
      saveStrings (statePath, state);
    } else {
      String joined = join (state, "\n");

      if (joined.length () > 0)
        joined += "\n";
      joined += currentState ();

      saveStrings (statePath, split (joined, "/n"));
    }
  }
}

void updateState () {
  String state [] = getState ();

  if (state != null) {
    if (boardDimensionExists ()) {
      String raw = state [getBoardDimensionIndex ()];
      state = split (raw, "-");

      String info [] = split (state [0], ",");

      highScore = int(info [1]);
      moves = int (info [2]);

      table = stringToTable (state [1]);
      prevTable = table;

      history = new ArrayList <int [] []> ();
      for (int a = 2; a < state.length; a ++) 
        history.add(stringToTable (state [a]));
    }
  }
}

int [] [] stringToTable (String input) {
  int rows = getRowCount (input);
  int columns = getColumnCount (input);

  int [] [] table = new int [rows] [columns];  

  for (int r = 0; r < rows; r ++) {
    String splitted [] = split (getRow (input, r), ",");
    for (int c = 0; c < columns; c ++) {
      table [r] [c] = int(splitted [c]);
    }
  }

  return table;
}

String getRow (String input, int index) {
  return split (input, ";") [index];
}

int getRowCount (String input) {
  return split (input, ";").length;
}
int getColumnCount (String input) {
  String replaced = input.replace (";", ",");
  return split (replaced, ",").length/getRowCount (input);
}

String tableToString (int [] [] table) {
  String output = "";
  for (int r = 0; r < table.length; r ++) {
    for (int c = 0; c < table.length; c ++) {
      output += table [r] [c];
      if (c != table.length - 1)
        output += ",";
    }
    if (r != table [r].length - 1)
      output += ";";
  }
  return output;
}

int getLastBoardDimension () {
  int board = defaultBoardDimension;
  String size [] = loadStrings (lastTableSizePath);
  
  if (size == null)
    saveBoardDimension (boardDimension);
  else {
    board = int(size [0].trim());
    if (board < minBoardDimension || board > maxBoardDimension)
      board = defaultBoardDimension;
  }

  return board;
}

void saveBoardDimension (int boardDimension) {
  String boardDimensionArray [] = { str (boardDimension) };
  saveStrings (lastTableSizePath, boardDimensionArray);
}
