part of 'imports.dart';

class GameViewModel extends ChangeNotifier {
  GameViewModel() {
    _init();
  }

  final gridSize = 3;

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
    checkWin();
    notifyListeners();
  }

  void checkWin() {
    if (checkDiagonal() || chekcRow() || checkColumn()) {
      showSnackBar("GAME WON!");
    }
  }

  bool checkDiagonal() {
    if (placeList[0][0] == placeList[1][1] &&
        placeList[1][1] == placeList[2][2] &&
        placeList[0][0] != null) {
      return true;
    }
    if (placeList[0][2] == placeList[1][1] &&
        placeList[1][1] == placeList[2][0] &&
        placeList[0][2] != null) {
      return true;
    }

    return false;
  }

  bool checkColumn() {
    for (int i = 0; i < gridSize; i++) {
      if (placeList[0][i] == placeList[1][i] &&
          placeList[1][i] == placeList[2][i] &&
          placeList[0][i] != null) {
        return true;
      }
    }
    return false;
  }

  bool chekcRow() {
    for (int i = 0; i < gridSize; i++) {
      if (placeList[i][0] == placeList[i][1] &&
          placeList[i][1] == placeList[i][2] &&
          placeList[i][0] != null) {
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
