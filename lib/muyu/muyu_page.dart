import 'dart:math';

import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:game/muyu/animate_text.dart';
import 'package:game/muyu/models/audio_option.dart';
import 'package:game/muyu/models/merit_record.dart';
import 'package:game/muyu/options/select_audio.dart';
import 'package:uuid/uuid.dart';
import 'models/image_option.dart';
import 'muyu_image.dart';

import 'count_panel.dart';
import 'muyu_app_bar.dart';
import 'options/select_image.dart';

class MuyuPage extends StatefulWidget {
  const MuyuPage({super.key});

  @override
  State<MuyuPage> createState() => _MuyuPageState();
}

class _MuyuPageState extends State<MuyuPage> with TickerProviderStateMixin {
  int _counter = 0;
  int _cruValue = 0;
  bool _showFloatingText = false;
  int _activeImageIndex = 0;
  int _activeAudioIndex = 0;

  late AnimationController _animationController;
  late Animation<double> _opacity;
  late Animation<Offset> _position;
  late Animation<double> _scale;

  final Random _random = Random();

  final List<ImageOption> imageOptions = const [
    ImageOption(name: '基础版', src: 'assets/images/muyu.png', min: 1, max: 3),
    ImageOption(name: '尊享版', src: 'assets/images/muyu2.png', min: 3, max: 6),
  ];

  final List<AudioOption> audioOptions = const [
    AudioOption(name: '音效1', src: 'muyu_1.mp3'),
    AudioOption(name: '音效2', src: 'muyu_2.mp3'),
    AudioOption(name: '音效3', src: 'muyu_3.mp3'),
  ];

  final Uuid uuid = Uuid();

  final List<MeritRecord> _records = [];

  AudioPool? pool;

  @override
  void initState() {
    super.initState();
    _initAnimationController();
    _initAudioPool();
  }

  void _initAnimationController() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _opacity = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(_animationController);
    _scale = Tween<double>(begin: 1.0, end: 0.9).animate(_animationController);
    _position = Tween<Offset>(
      begin: const Offset(0, 2),
      end: Offset.zero,
    ).animate(_animationController);
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _showFloatingText = false;
        });
      }
    });
  }

  void _initAudioPool() async {
    pool = await FlameAudio.createPool('muyu_1.mp3', maxPlayers: 1);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MuyuAppBar(onTapHistory: _toHistory),
      body: Column(
        children: [
          Expanded(
            child: CountPanel(
              count: _counter,
              onTapSwitchAudio: _onTapSwitchAudio,
              onTapSwitchImage: _onTapSwitchImage,
            ),
          ),
          Expanded(
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                MuyuAssetsImage(image: activeImage, onTap: _onKnock),
                if (_showFloatingText)
                  AnimateText(
                    text: '功德+$_cruValue',
                    opacity: _opacity,
                    position: _position,
                    scale: _scale,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _toHistory() {}

  void _onTapSwitchAudio() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return AudioOptionPanel(
          audioOptions: audioOptions,
          activeIndex: _activeAudioIndex,
          onSelect: _onSelectAudio,
        );
      },
    );
  }

  void _onTapSwitchImage() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return ImageOptionPanel(
          imageOptions: imageOptions,
          activeIndex: _activeImageIndex,
          onSelect: _onSelectImage,
        );
      },
    );
  }

  void _onKnock() {
    pool?.start();
    setState(() {
      _cruValue = knockValue;
      _counter += _cruValue;
      _showFloatingText = true;
      // 添加功德记录
      String id = uuid.v4();
      _records.add(
        MeritRecord(
          id,
          DateTime.now().millisecondsSinceEpoch,
          _cruValue,
          activeImage,
          audioOptions[_activeAudioIndex].name,
        ),
      );
    });
    _animationController.forward(from: 0.0);
  }

  String get activeImage => imageOptions[_activeImageIndex].src;
  String get activeAudio => audioOptions[_activeAudioIndex].src;

  int get knockValue {
    int min = imageOptions[_activeImageIndex].min;
    int max = imageOptions[_activeImageIndex].max;
    return min + _random.nextInt(max + 1 - min);
  }

  void _onSelectImage(int value) {
    Navigator.of(context).pop();
    if (value == _activeImageIndex) return;
    setState(() {
      _activeImageIndex = value;
    });
  }

  void _onSelectAudio(int value) async {
    Navigator.of(context).pop();
    if (value == _activeAudioIndex) return;
    _activeAudioIndex = value;
    pool = await FlameAudio.createPool(activeAudio, maxPlayers: 1);
  }
}
