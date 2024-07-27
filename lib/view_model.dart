part of 'imports.dart';

class GameViewModel extends ChangeNotifier {
  GameViewModel();

  final gridSize = 3;

  bool isCross = false;
  bool disaperingMode = false;

  Queue<TicTacModel> queue = Queue();

  void toggleDisaperingMode(bool value) {
    disaperingMode = value;
    reset();
    notifyListeners();
  }

  void placeCrossCircle(int row, int col) {
    if (queue.length == 9) {
      return;
    }
    if (disaperingMode) {
      if (queue.length == 7) {
        queue.removeFirst();
      }
      if (queue.length == 6) {
        queue.first.color = Colors.grey;
      }
    }
    IconData icon;
    if (isCross) {
      icon = Icons.close;
    } else {
      icon = Icons.radio_button_unchecked;
    }
    queue.add(
      TicTacModel(
        xPos: row,
        yPos: col,
        icon: icon,
      ),
    );
    isCross = !isCross;
    notifyListeners();
  }

  void reset() {
    queue.clear();
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
    return "($xPos,$yPos,${color.toString()},)";
  }
}
