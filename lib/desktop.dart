import 'package:flutter/material.dart';
import 'widgets.dart';
import 'desktop_items.dart';

class DesktopScreen extends StatefulWidget {
  const DesktopScreen({super.key});

  @override
  State<DesktopScreen> createState() => _DesktopScreenState();
}

class _DesktopScreenState extends State<DesktopScreen> {
  bool _isStartMenuOpen = false;

  void _toggleStartMenu() {
    setState(() => _isStartMenuOpen = !_isStartMenuOpen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(
        child: Stack(
          children: [
            // Background
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).primaryColor,
                    Colors.purple[900]!,
                    Colors.black,
                  ],
                ),
              ),
            ),

            // Desktop Items
            const Padding(
              padding: EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 80),
              child: DesktopItems(),
            ),

            // Top Bar
            const Align(
              alignment: Alignment.topCenter,
              child: TaskBar(),
            ),

            // Start Menu
            if (_isStartMenuOpen)
              Align(
                alignment: Alignment.center,
                child: StartMenu(onClose: _toggleStartMenu),
              ),

            // Dock
            Align(
              alignment: Alignment.bottomCenter,
              child: Dock(onStartMenuTap: _toggleStartMenu),
            ),
          ],
        ),
      ),
    );
  }
}
