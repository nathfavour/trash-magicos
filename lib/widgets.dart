import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:vector_math/vector_math.dart' as vector;

class TaskBar extends StatelessWidget {
  const TaskBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      color: Colors.black45,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Text('MagicOS',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const Spacer(),
          _buildSystemTray(),
        ],
      ),
    );
  }

  Widget _buildSystemTray() {
    final time = DateFormat.Hm().format(DateTime.now());
    return Row(
      children: [
        const Icon(Icons.wifi, size: 16, color: Colors.white),
        const SizedBox(width: 12),
        const Icon(Icons.battery_full, size: 16, color: Colors.white),
        const SizedBox(width: 12),
        Text(time, style: const TextStyle(color: Colors.white)),
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
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _scaleController.forward(),
      onExit: (_) => _scaleController.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001) // perspective
            ..rotateX(vector.radians(-10)),
          alignment: Alignment.center,
          child: GlassmorphicContainer(
            width: 500,
            height: 60,
            borderRadius: 30,
            blur: 10,
            alignment: Alignment.bottomCenter,
            border: 1,
            linearGradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.1),
                Colors.white.withOpacity(0.05),
              ],
            ),
            borderGradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.2),
                Colors.white.withOpacity(0.1),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DockIcon(
                    icon: Icons.apps,
                    label: 'Apps',
                    onTap: widget.onStartMenuTap),
                DockIcon(icon: Icons.folder, label: 'Files'),
                DockIcon(icon: Icons.terminal, label: 'Terminal'),
                DockIcon(icon: Icons.web, label: 'Browser'),
                DockIcon(icon: Icons.settings, label: 'Settings'),
              ],
            ),
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

  const DockIcon({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  State<DockIcon> createState() => _DockIconState();
}

class _DockIconState extends State<DockIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeOutBack),
    );
    _rotateAnimation = Tween<double>(begin: 0, end: 0.1).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeOutBack),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _hoverController.forward(),
      onExit: (_) => _hoverController.reverse(),
      child: AnimatedBuilder(
        animation: _hoverController,
        builder: (context, child) {
          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(vector.radians(_rotateAnimation.value * 30))
              ..scale(_scaleAnimation.value),
            alignment: Alignment.center,
            child: child,
          );
        },
        child: GestureDetector(
          onTap: widget.onTap,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                size: 28,
                color: Colors.white,
              ),
              if (_hoverController.value > 0)
                FadeTransition(
                  opacity: _hoverController,
                  child: Text(
                    widget.label,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
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
    return Container(
      width: 600,
      height: 400,
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _buildSearchBar(),
          Expanded(child: _buildAppGrid()),
          _buildQuickActions(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        children: [
          Icon(Icons.search, color: Colors.white70),
          SizedBox(width: 8),
          Expanded(
            child: TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Search apps and files...',
                hintStyle: TextStyle(color: Colors.white70),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppGrid() {
    // Simple placeholder grid
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      children: [
        _buildGridIcon(Icons.web, 'Browser'),
        _buildGridIcon(Icons.folder, 'Files'),
        // ...add more icons as needed...
      ],
    );
  }

  Widget _buildGridIcon(IconData icon, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.white, size: 32),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }

  Widget _buildQuickActions() {
    // Simple placeholder row
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildActionIcon(Icons.power_settings_new, 'Power'),
          const SizedBox(width: 20),
          _buildActionIcon(Icons.settings, 'Settings'),
        ],
      ),
    );
  }

  Widget _buildActionIcon(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }
}
