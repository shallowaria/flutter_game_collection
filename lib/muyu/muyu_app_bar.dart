import 'package:flutter/material.dart';

class MuyuAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onTabHistory;

  const MuyuAppBar({super.key, required this.onTabHistory});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      titleTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: Colors.black),
      title: Text('电子木鱼'),
      actions: [IconButton(onPressed: onTabHistory, icon: Icon(Icons.history))],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
