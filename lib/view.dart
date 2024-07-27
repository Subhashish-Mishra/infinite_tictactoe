part of 'imports.dart';

class GameView extends StatelessWidget {
  const GameView({super.key, required this.viewModel});
  final GameViewModel viewModel;

  Widget createGrid(double resSize, List<List<TicTacModel?>> places) {
    List<Row> rows = [];
    for (var row = 0; row < viewModel.gridSize; row++) {
      List<Widget> boxes = [];
      for (var col = 0; col < viewModel.gridSize; col++) {
        boxes.add(
          GestureDetector(
            onTapDown: (_) => viewModel.placeCrossCircle(row, col),
            child: Container(
              width: resSize,
              height: resSize,
              decoration: BoxDecoration(
                border: Border.all(width: 2.0, color: Colors.white),
              ),
              child: Center(
                child: Builder(
                  builder: (context) {
                    TicTacModel tictak =
                        places[row][col] ?? TicTacModel.empty();

                    return Icon(
                      tictak.icon,
                      size: resSize,
                      color: tictak.color,
                    );
                  },
                ),
              ),
            ),
          ),
        );
      }
      rows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: boxes,
        ),
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: rows,
    );
  }

  Widget disaperingModeButton(double width, double height) {
    List<Widget> disaperingMode = [
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(
          "Disappering Mode",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      Transform.scale(
        scale: 0.8,
        child: CupertinoSwitch(
          trackColor: Colors.grey[800],
          activeColor: Colors.grey,
          value: viewModel.disaperingMode,
          onChanged: viewModel.toggleDisaperingMode,
        ),
      ),
    ];
    return OverflowBar(
      overflowAlignment: OverflowBarAlignment.center,
      alignment: MainAxisAlignment.center,
      overflowDirection: VerticalDirection.up,
      children: disaperingMode,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: scaffoldMessagerKey,
      home: Scaffold(
        backgroundColor: Theme.of(context).disabledColor,
        body: Center(
          child: SizedBox(
            width: 1000,
            height: 1080,
            child: LayoutBuilder(
              builder: (context, constraints) {
                var resSize = min(
                  constraints.maxWidth / viewModel.gridSize,
                  (constraints.maxHeight - 80) / viewModel.gridSize,
                );
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    createGrid(resSize, viewModel.placeList),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Expanded(flex: 1, child: SizedBox.shrink()),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Icon(
                                  Icons.close,
                                  color: viewModel.isCross
                                      ? Colors.white
                                      : Colors.white30,
                                  size: 20,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey,
                                    foregroundColor: Colors.white,
                                  ),
                                  onPressed: viewModel.reset,
                                  child: const Text("Reset"),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Icon(
                                  Icons.radio_button_unchecked,
                                  color: !viewModel.isCross
                                      ? Colors.white
                                      : Colors.white30,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            flex: 1,
                            child: disaperingModeButton(
                              constraints.maxWidth,
                              constraints.maxHeight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
