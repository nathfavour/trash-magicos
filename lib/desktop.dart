import 'package:flutter/material.dart';
import 'widgets.dart';
import 'desktop_items.dart'; // Ensure this file exists

class DesktopScreen extends StatefulWidget {
  const DesktopScreen({super.key});

  @override
  State<DesktopScreen> createState() => _DesktopScreenState();
}

class _DesktopScreenState extends State<DesktopScreen>
    with SingleTickerProviderStateMixin {
  bool _isStartMenuOpen = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleStartMenu() {
    setState(() {
      _isStartMenuOpen = !_isStartMenuOpen;
      if (_isStartMenuOpen) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context)
          .colorScheme
          .surface, // Changed from background to surface
      body: Stack(
        children: [
          // Desktop area with animated transitions
          const Positioned.fill(
            child: DesktopBackground(),
          ),

          // Desktop items
          const Positioned.fill(
            child:
                DesktopItems(), // Ensure DesktopItems is correctly implemented
          ),

          // Top taskbar
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: TaskBar(),
          ),

          // Start menu with fade transition
          FadeTransition(
            opacity: _animationController,
            child: _isStartMenuOpen
                ? Positioned(
                    bottom: 80,
                    left: 0,
                    right: 0,
                    child: StartMenu(
                      onClose: _toggleStartMenu,
                    ),
                  )
                : Container(),
          ),

          // Dock
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Dock(
              onStartMenuTap: _toggleStartMenu,
            ),
          ),
        ],
      ),
    );
  }
}
