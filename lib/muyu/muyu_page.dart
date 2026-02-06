import 'package:flutter/material.dart';
import 'package:game/muyu/count_panel.dart';

class MuyuPage extends StatefulWidget {
  const MuyuPage({super.key});

  @override
  MuyuPageState createState() => MuyuPageState();
}

class MuyuPageState extends State<MuyuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('电子木鱼'),
        actions: [IconButton(onPressed: _toHistory, icon: Icon(Icons.history))],
      ),
      body: Column(
        children: [
          Expanded(
            child: CountPanel(
              count: 0,
              onTapSwitchAudio: _onTapSwitchAudio,
              onTapSwitchImage: _onTapSwitchImage,
            ),
          ),
          Expanded(child: MuyuPage()),
        ],
      ),
    );
  }

  void _toHistory() {}

  void _onTapSwitchAudio() {}

  void _onTapSwitchImage() {}
}
