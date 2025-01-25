import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

class Dock extends StatelessWidget {
  final VoidCallback onStartMenuTap;

  const Dock({super.key, required this.onStartMenuTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      height: 60,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          DockIcon(icon: Icons.apps, label: 'Apps', onTap: onStartMenuTap),
          DockIcon(icon: Icons.folder, label: 'Files'),
          DockIcon(icon: Icons.terminal, label: 'Terminal'),
          DockIcon(icon: Icons.web, label: 'Browser'),
          DockIcon(icon: Icons.settings, label: 'Settings'),
        ],
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

class _DockIconState extends State<DockIcon> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              widget.icon,
              size: _isHovered ? 32 : 28,
              color: Colors.white,
            ),
            if (_isHovered)
              Text(
                widget.label,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
          ],
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
