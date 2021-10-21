part of 'package:useful_utilities/useful_utilities.dart';

extension ContextExtension on BuildContext {
  double get screenHeight => MediaQuery.of(this).size.height;
  double get screenWidth => MediaQuery.of(this).size.width;

  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}
