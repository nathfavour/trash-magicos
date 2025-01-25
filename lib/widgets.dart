import 'package:flutter/material.dart';

class DesktopBackground extends StatefulWidget {
  const DesktopBackground({super.key});

  @override
  State<DesktopBackground> createState() => _DesktopBackgroundState();
}

class _DesktopBackgroundState extends State<DesktopBackground> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

class TaskBar extends StatelessWidget {
  const TaskBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      color: Colors.black54,
      child: Row(
        children: [
          const Spacer(),
          _buildSystemTray(),
        ],
      ),
    );
  }

  Widget _buildSystemTray() {
    return Row(
      children: [
        Icon(Icons.wifi, size: 16),
        SizedBox(width: 8),
        Icon(Icons.battery_full, size: 16),
        SizedBox(width: 8),
        Text(DateTime.now().toString().substring(11, 16)),
        SizedBox(width: 16),
      ],
    );
  }
}

class Dock extends StatelessWidget {
  final VoidCallback onStartMenuTap;

  const Dock({super.key, required this.onStartMenuTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.apps),
            onPressed: onStartMenuTap,
          ),
          // Add more dock icons here
        ],
      ),
    );
  }
}

class StartMenu extends StatelessWidget {
  final VoidCallback onClose;

  const StartMenu({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 400,
        height: 500,
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.close),
              title: const Text('Close'),
              onTap: onClose,
            ),
            // Add more menu items here
          ],
        ),
      ),
    );
  }
}
