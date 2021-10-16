import 'package:flutter/material.dart';

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({
    Key? key,
    required this.child,
    required this.isLoading,
  }) : super(key: key);

  final Widget child;
  final bool isLoading;

  static const animDuration = Duration(milliseconds: 500);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedOpacity(
          opacity: isLoading ? 0.5 : 1.0,
          duration: animDuration,
          child: AbsorbPointer(absorbing: isLoading, child: child),
        ),
        if (isLoading)
          const Positioned(child: Align(child: CircularProgressIndicator())),
      ],
    );
  }
}
