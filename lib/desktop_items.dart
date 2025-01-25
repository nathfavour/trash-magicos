import 'package:flutter/material.dart';

class DesktopItems extends StatelessWidget {
  const DesktopItems({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        _buildDesktopIcon(
          context,
          icon: Icons.brush,
          label: 'Art Studio',
          position: Offset(screenWidth * 0.1, screenHeight * 0.2),
        ),
        _buildDesktopIcon(
          context,
          icon: Icons.music_note,
          label: 'Music Player',
          position: Offset(screenWidth * 0.2, screenHeight * 0.6),
        ),
        _buildDesktopIcon(
          context,
          icon: Icons.gamepad,
          label: 'Game Hub',
          position: Offset(screenWidth * 0.3, screenHeight * 0.2),
        ),
        _buildDesktopIcon(
          context,
          icon: Icons.camera_alt,
          label: 'Photo Gallery',
          position: Offset(screenWidth * 0.4, screenHeight * 0.6),
        ),
        // Add more desktop items here within screen boundaries
      ],
    );
  }

  Widget _buildDesktopIcon(BuildContext context,
      {required IconData icon,
      required String label,
      required Offset position}) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: GestureDetector(
        onDoubleTap: () {
          // Implement app launch animation or navigation
        },
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: Icon(icon,
                  size: 40, color: Theme.of(context).colorScheme.secondary),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
