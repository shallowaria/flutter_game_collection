import 'package:flutter/material.dart';

class CountPanel extends StatelessWidget {
  final int count;
  final VoidCallback onTapSwitchAudio;
  final VoidCallback onTapSwitchImage;

  const CountPanel({
    super.key,
    required this.count,
    required this.onTapSwitchAudio,
    required this.onTapSwitchImage,
  });

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
      minimumSize: Size(36, 36),
      backgroundColor: Colors.green,
      padding: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      foregroundColor: Colors.white,
    );

    return Stack(
      children: [
        Center(
          child: Text(
            '功德数: $count',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),

        Positioned(
          right: 10,
          top: 10,
          child: Wrap(
            spacing: 8,
            direction: Axis.vertical,
            children: [
              ElevatedButton(
                style: style,
                onPressed: onTapSwitchAudio,
                child: Icon(Icons.music_note_outlined),
              ),
              ElevatedButton(
                style: style,
                onPressed: onTapSwitchImage,
                child: Icon(Icons.image),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
