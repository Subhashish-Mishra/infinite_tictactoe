part of 'imports.dart';

class GameViewModel extends ChangeNotifier {
  GameViewModel() {
    _init();
  }

  final gridSize = 3;

  bool isGameWon = false;

  bool isCross = false;
  bool disaperingMode = false;

  Queue<TicTacModel> placeQueue = Queue();
  List<List<TicTacModel?>> placeList = [];

  void _init() {
    placeList = createEmptyState();
  }

  List<List<TicTacModel?>> createEmptyState() {
    return List.generate(gridSize, (i) => List.generate(gridSize, (j) => null));
  }

  void toggleDisaperingMode(bool value) {
    disaperingMode = value;
    reset();
    notifyListeners();
  }

  void placeCrossCircle(int row, int col) {
    if (placeList[row][col] != null) {
      showSnackBar("Wrong move bro!");
      return;
    }
    if (placeQueue.length == 9) {
      return;
    }
    if (disaperingMode) {
      if (placeQueue.length == 6) {
        var first = placeQueue.first;
        placeList[first.xPos][first.yPos] = null;
        placeQueue.removeFirst();
      }
      if (placeQueue.length == 5) {
        var first = placeQueue.first;
        placeList[first.xPos][first.yPos]!.color = Colors.grey;
      }
    }
    PlaceType type;
    if (isCross) {
      type = PlaceType.cross;
    } else {
      type = PlaceType.circle;
    }
    var tictac = TicTacModel(
      xPos: row,
      yPos: col,
      type: type,
    );
    placeList[row][col] = tictac;
    placeQueue.add(tictac);
    isCross = !isCross;
    // print("${placeList.length}, ${placeQueue.length}");
    isGameWon = checkWin();
    notifyListeners();
  }

  bool checkWin() {
    if (checkDiagonal() || chekcRow() || checkColumn()) {
      showSnackBar("GAME WON!");
      return true;
    }
    return false;
  }

  bool checkDiagonal() {
    bool diag1Win = true;
    for (int i = 1; i < gridSize; i++) {
      if (placeList[i][i] != placeList[0][0] || placeList[0][0] == null) {
        diag1Win = false;
        break;
      }
    }
    if (diag1Win) {
      // return "${placeList[0][0]} wins!";
      return true;
    }
    bool diag2Win = true;
    for (int i = 1; i < gridSize; i++) {
      if (placeList[i][gridSize - 1 - i] != placeList[0][gridSize - 1] ||
          placeList[0][gridSize - 1] == null) {
        diag2Win = false;
        break;
      }
    }
    if (diag2Win) {
      // return "${placeList[0][gridSize - 1]} wins!";
      return true;
    }

    return false;
  }

  bool checkColumn() {
    for (int i = 0; i < gridSize; i++) {
      bool colWin = true;
      for (int j = 1; j < gridSize; j++) {
        if (placeList[j][i] != placeList[0][i] || placeList[0][i] == null) {
          colWin = false;
          break;
        }
      }
      if (colWin) {
        // return "${placeList[0][i]} wins!";
        return true;
      }
    }
    return false;
  }

  bool chekcRow() {
    for (int i = 0; i < gridSize; i++) {
      bool rowWin = true;
      for (int j = 1; j < gridSize; j++) {
        if (placeList[i][j] != placeList[i][0] || placeList[i][0] == null) {
          rowWin = false;
          break;
        }
      }
      if (rowWin) {
        // return "${placeList[i][0]} wins!";
        return true;
      }
    }
    return false;
  }

  bool checkDraw() {
    bool isDraw = false;
    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) {
        if (placeList[i][j] == null) {
          isDraw = true;
        }
      }
    }
    return isDraw;
  }

  void reset() {
    placeList = createEmptyState();
    placeQueue.clear();
    isGameWon = false;
    notifyListeners();
  }
}

class TicTacModel {
  TicTacModel({
    required this.xPos,
    required this.yPos,
    this.color = Colors.white,
    required this.type,
  }) {
    setIcon(type);
  }

  final int xPos;
  final int yPos;
  Color? color;
  PlaceType type;

  IconData? _icon;
  IconData? get icon => _icon;

  void setIcon(PlaceType value) {
    if (value == PlaceType.cross) {
      _icon = Icons.close;
    } else if (value == PlaceType.circle) {
      _icon = Icons.radio_button_unchecked;
    }
  }

  factory TicTacModel.empty() {
    return TicTacModel(
      xPos: 0,
      yPos: 0,
      type: PlaceType.none,
    );
  }

  @override
  String toString() {
    return "($xPos,$yPos,$type,$icon)";
  }

  @override
  bool operator ==(other) => other is TicTacModel && other.type == type;

  @override
  int get hashCode => Object.hash(xPos.hashCode, yPos.hashCode);
}

enum PlaceType { none, cross, circle }
