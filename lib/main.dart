import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'imports.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GameViewModel>.value(
      value: GameViewModel(),
      child: Consumer<GameViewModel>(
        builder: (context, viewModel, child) => GameView(viewModel: viewModel),
      ),
    );
  }
}
