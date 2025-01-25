import 'package:flutter/material.dart';
import 'widgets.dart';
import 'desktop_items.dart';
import 'dart:ui'; // For ImageFilter

class DesktopScreen extends StatefulWidget {
  const DesktopScreen({super.key});

  @override
  State<DesktopScreen> createState() => _DesktopScreenState();
}

class _DesktopScreenState extends State<DesktopScreen>
    with SingleTickerProviderStateMixin {
  bool _isStartMenuOpen = false;
  bool _isBlurred = false; // New state variable for blur
  late AnimationController _animationController;
  late Animation<Offset> _startMenuOffset;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
      lowerBound: 0.0,
      upperBound: 1.0, // Ensure upperBound is set
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
        _isBlurred = true; // Apply blur when StartMenu opens
      } else {
        _animationController.reverse();
        _isBlurred = false; // Remove blur when StartMenu closes
      }
    });
  }

  void toggleBlur() {
    setState(() {
      _isBlurred = !_isBlurred;
      if (_isBlurred) {
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            fit: StackFit.expand,
            children: [
              // Desktop background
              const Positioned.fill(
                child: DesktopBackground(),
              ),

              // Desktop items with fade
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: _isStartMenuOpen ? 0.3 : 1.0,
                child: const DesktopItems(),
              ),

              // Top taskbar
              const Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: TaskBar(),
              ),

              // Start menu
              if (_isStartMenuOpen)
                Positioned.fill(
                  child: StartMenu(
                    onClose: _toggleStartMenu,
                    animation: _animationController,
                  ),
                ),

              // Dock
              Positioned(
                bottom: _isStartMenuOpen ? -60 : 0,
                left: 0,
                right: 0,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: Dock(
                    onStartMenuTap: _toggleStartMenu,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
