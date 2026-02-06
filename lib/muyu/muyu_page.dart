import 'dart:math';

import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:game/muyu/count_panel.dart';
import 'package:game/muyu/muyu_app_bar.dart';
import 'package:game/muyu/muyu_image.dart';

class MuyuPage extends StatefulWidget {
  const MuyuPage({super.key});

  @override
  MuyuPageState createState() => MuyuPageState();
}

class MuyuPageState extends State<MuyuPage> {
  int _count = 0;
  final Random _random = Random();
  AudioPool? pool;

  @override
  void initState() {
    super.initState();
    _initAudioPool();
  }

  Future<void> _initAudioPool() async {
    pool = await FlameAudio.createPool('muyu_1.mp3', maxPlayers: 4);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MuyuAppBar(onTabHistory: _toHistory),
      body: Column(
        children: [
          Expanded(
            child: CountPanel(
              count: _count,
              onTapSwitchAudio: _onTapSwitchAudio,
              onTapSwitchImage: _onTapSwitchImage,
            ),
          ),
          Expanded(
            child: MuyuImage(image: 'assets/images/muyu.png', onTap: _onKnock),
          ),
        ],
      ),
    );
  }

  void _toHistory() {}

  void _onTapSwitchAudio() {}

  void _onTapSwitchImage() {}

  void _onKnock() {
    setState(() {
      int addCount = _random.nextInt(3) + 1;
      _count += addCount;
      pool?.start();
    });
  }
}
