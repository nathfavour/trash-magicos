import 'package:flutter/material.dart';
import 'widgets.dart';

class DesktopScreen extends StatefulWidget {
  const DesktopScreen({super.key});

  @override
  State<DesktopScreen> createState() => _DesktopScreenState();
}

class _DesktopScreenState extends State<DesktopScreen> {
  bool _isStartMenuOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Stack(
        children: [
          // Desktop area
          const Positioned.fill(
            child: DesktopBackground(),
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
            Positioned(
              bottom: 80,
              left: 0,
              right: 0,
              child: StartMenu(
                onClose: () => setState(() => _isStartMenuOpen = false),
              ),
            ),

          // Dock
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Dock(
              onStartMenuTap: () =>
                  setState(() => _isStartMenuOpen = !_isStartMenuOpen),
            ),
          ),
        ],
      ),
    );
  }
}
