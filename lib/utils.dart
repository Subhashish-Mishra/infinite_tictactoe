part of 'imports.dart';

void showSnackBar(String value) {
  scaffoldMessagerKey.currentState!
      .showSnackBar(SnackBar(content: Text(value)));
}
