import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Ensure this import is present
import 'dart:ui'; // Add this import for BackdropFilter

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

class Dock extends StatefulWidget {
  final VoidCallback onStartMenuTap;

  const Dock({super.key, required this.onStartMenuTap});

  @override
  _DockState createState() => _DockState();
}

class _DockState extends State<Dock> with SingleTickerProviderStateMixin {
  late AnimationController _expandController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _expandController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _expandController,
      curve: Curves.easeOutBack,
    );
  }

  @override
  void dispose() {
    _expandController.dispose();
    super.dispose();
  }

  void _handleStartMenuTap() {
    widget.onStartMenuTap();
    if (!_expandController.isAnimating) {
      _expandController.forward();
    } else {
      _expandController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Opacity(
        opacity: 0.7, // Semi-transparent
        child: Container(
          height: 60,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Example App Icons
              DockIcon(icon: Icons.home, label: 'Home'),
              DockIcon(icon: Icons.search, label: 'Search'),
              DockIcon(
                icon: Icons.apps,
                label: 'Apps',
                onTap: _handleStartMenuTap,
                isCentral: true,
              ),
              DockIcon(icon: Icons.settings, label: 'Settings'),
              DockIcon(icon: Icons.info, label: 'Info'),
            ],
          ),
        ),
      ),
    );
  }
}

class DockIcon extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool isCentral;

  const DockIcon({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    this.isCentral = false,
  });

  @override
  _DockIconState createState() => _DockIconState();
}

class _DockIconState extends State<DockIcon>
    with SingleTickerProviderStateMixin {
  bool _isHovering = false;
  late AnimationController _bounceController;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  void _onEnter(PointerEvent details) {
    setState(() {
      _isHovering = true;
    });
    _bounceController.forward();
  }

  void _onExit(PointerEvent details) {
    setState(() {
      _isHovering = false;
    });
    _bounceController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    double scale = 1 + _bounceController.value;
    return MouseRegion(
      onEnter: _onEnter,
      onExit: _onExit,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Transform.scale(
          scale: scale,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: widget.isCentral
                      ? Theme.of(context)
                          .extension<CustomColors>()!
                          .accentColor
                          .withOpacity(0.8)
                      : Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: Icon(
                  widget.icon,
                  size: widget.isCentral ? 40 : 30,
                  color: widget.isCentral
                      ? Colors.white
                      : Theme.of(context).colorScheme.secondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: widget.isCentral ? 14 : 12,
                ),
              ),
            ],
          ),
        ),
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
