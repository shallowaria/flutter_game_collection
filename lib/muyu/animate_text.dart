import 'package:flutter/material.dart';

class AnimateText extends StatelessWidget {
  final String text;
  final Animation<double> opacity;
  final Animation<Offset> position;
  final Animation<double> scale;

  const AnimateText({
    super.key,
    required this.text,
    required this.opacity,
    required this.position,
    required this.scale,
  });

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scale,
      child: SlideTransition(
        position: position,
        child: FadeTransition(opacity: opacity, child: Text(text)),
      ),
    );
  }
}
