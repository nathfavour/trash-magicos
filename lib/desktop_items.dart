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
        _buildDesktopIcon(
          context,
          icon: Icons.folder,
          label: 'Projects',
          position: Offset(screenWidth * 0.25, screenHeight * 0.3),
        ),
        _buildDesktopIcon(
          context,
          icon: Icons.folder,
          label: 'Downloads',
          position: Offset(screenWidth * 0.35, screenHeight * 0.45),
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
                color: Colors.white.withOpacity(0.2), // Glassy effect
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Icon(icon,
                  size: 36,
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.8)),
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
