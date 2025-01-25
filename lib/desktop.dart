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
  late Animation<double> _menuFadeAnimation;

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
    _menuFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _menuController, curve: Curves.easeIn),
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
      body: Stack(
        children: [
          // Use a background image
          Positioned.fill(
            child: Image.asset(
              'assets/background3.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // When Start Menu is open, blur everything except TaskBar & Dock
          if (_isStartMenuOpen)
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: _menuBlurAnimation.value,
                  sigmaY: _menuBlurAnimation.value,
                ),
                child: Container(color: Colors.transparent),
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

          // Start Menu overlay with fade + scale transitions
          if (_isStartMenuOpen)
            AnimatedBuilder(
              animation: _menuController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _menuFadeAnimation,
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
    );
  }
}
