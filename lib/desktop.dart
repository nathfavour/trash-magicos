import 'package:flutter/material.dart';
import 'widgets.dart';
import 'desktop_items.dart';

class DesktopScreen extends StatefulWidget {
  const DesktopScreen({super.key});

  @override
  State<DesktopScreen> createState() => _DesktopScreenState();
}

class _DesktopScreenState extends State<DesktopScreen>
    with SingleTickerProviderStateMixin {
  bool _isStartMenuOpen = false;
  late AnimationController _animationController;
  late Animation<Offset> _startMenuOffset;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _startMenuOffset = Tween<Offset>(
      begin: const Offset(0, 1),
      end: const Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
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
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          // Desktop area with animated transitions
          const Positioned.fill(
            child: DesktopBackground(),
          ),

          // Desktop items
          AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: _isStartMenuOpen ? 0.3 : 1.0,
            child: const Positioned.fill(
              child: DesktopItems(),
            ),
          ),

          // Top taskbar
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: TaskBar(),
          ),

          // Start menu with morphing animation
          if (_isStartMenuOpen)
            Positioned(
              bottom: 80,
              left: 0,
              right: 0,
              child: StartMenu(
                onClose: _toggleStartMenu,
                animation: _animationController,
              ),
            ),

          // Dock
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            bottom: _isStartMenuOpen ? -60 : 0,
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
