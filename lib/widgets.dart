import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Ensure this import is present

class DesktopBackground extends StatefulWidget {
  const DesktopBackground({super.key});

  @override
  State<DesktopBackground> createState() => _DesktopBackgroundState();
}

class _DesktopBackgroundState extends State<DesktopBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _colorController;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _colorController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat(reverse: true);
    _colorAnimation = ColorTween(
      begin: Colors.purple[900],
      end: Colors.red[900],
    ).animate(_colorController);
  }

  @override
  void dispose() {
    _colorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).primaryColor,
                _colorAnimation.value!,
                Colors.black,
              ],
            ),
          ),
        );
      },
    );
  }
}

class TaskBar extends StatefulWidget {
  const TaskBar({super.key});

  @override
  _TaskBarState createState() => _TaskBarState();
}

class _TaskBarState extends State<TaskBar> {
  String _currentTime = '';

  @override
  void initState() {
    super.initState();
    _updateTime();
  }

  void _updateTime() {
    final now = DateTime.now();
    final formattedTime = DateFormat.Hm().format(now);
    setState(() {
      _currentTime = formattedTime;
    });
    Future.delayed(const Duration(minutes: 1), _updateTime);
  }

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
        Icon(Icons.wifi, size: 16, color: Colors.white),
        SizedBox(width: 8),
        Icon(Icons.battery_full, size: 16, color: Colors.white),
        SizedBox(width: 8),
        Text(
          _currentTime,
          style: TextStyle(color: Colors.white),
        ),
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
