import 'package:flutter/material.dart';
import 'widgets.dart';
import 'desktop_items.dart';
import 'dart:ui';

class DesktopScreen extends StatefulWidget {
  const DesktopScreen({super.key});

  @override
  State<DesktopScreen> createState() => _DesktopScreenState();
}

class _DesktopScreenState extends State<DesktopScreen>
    with SingleTickerProviderStateMixin {
  bool _isStartMenuOpen = false;
  late AnimationController _menuController;
  late Animation<double> _menuScaleAnimation;
  late Animation<double> _menuBlurAnimation;

  @override
  void initState() {
    super.initState();
    _menuController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _menuScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _menuController, curve: Curves.easeOutExpo),
    );
    _menuBlurAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _menuController, curve: Curves.easeOut),
    );
  }

  void _toggleStartMenu() {
    setState(() {
      _isStartMenuOpen = !_isStartMenuOpen;
      if (_isStartMenuOpen) {
        _menuController.forward();
      } else {
        _menuController.reverse();
      }
    });
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
              padding:
                  EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 80),
              child: DesktopItems(),
            ),

            // Top Bar
            const Align(
              alignment: Alignment.topCenter,
              child: TaskBar(),
            ),

            // Animated Start Menu
            if (_isStartMenuOpen)
              AnimatedBuilder(
                animation: _menuController,
                builder: (context, child) {
                  return BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: _menuBlurAnimation.value,
                      sigmaY: _menuBlurAnimation.value,
                    ),
                    child: ScaleTransition(
                      scale: _menuScaleAnimation,
                      child: StartMenu(onClose: _toggleStartMenu),
                    ),
                  );
                },
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
