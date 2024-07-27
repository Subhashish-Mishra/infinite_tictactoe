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
      if (placeQueue.length == 7) {
        var first = placeQueue.first;
        placeList[first.xPos][first.yPos] = null;
        placeQueue.removeFirst();
      }
      if (placeQueue.length == 6) {
        var first = placeQueue.first;
        placeList[first.xPos][first.yPos]!.color = Colors.grey;
      }
    }
    IconData icon;
    if (isCross) {
      icon = Icons.close;
    } else {
      icon = Icons.radio_button_unchecked;
    }
    var tictac = TicTacModel(
      xPos: row,
      yPos: col,
      icon: icon,
    );
    placeList[row][col] = tictac;
    placeQueue.add(tictac);
    isCross = !isCross;
    print("${placeList.length}, ${placeQueue.length}");
    notifyListeners();
  }

  void reset() {
    placeList = createEmptyState();
    placeQueue.clear();
    notifyListeners();
  }

  IconData getIcon() {
    if (isCross) {
      return Icons.close;
    } else {
      return Icons.radio_button_unchecked;
    }
  }
}

class TicTacModel {
  TicTacModel({
    required this.xPos,
    required this.yPos,
    this.icon,
    this.color = Colors.white,
  });

  final int xPos;
  final int yPos;
  final IconData? icon;
  Color? color;

  factory TicTacModel.empty() {
    return TicTacModel(
      xPos: 0,
      yPos: 0,
    );
  }

  @override
  String toString() {
    return "($xPos,$yPos)";
  }
}
