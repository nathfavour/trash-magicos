import 'package:flutter/material.dart';

class DesktopItems extends StatelessWidget {
  const DesktopItems({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
      ),
      itemCount: _desktopItems.length,
      itemBuilder: (context, index) {
        final item = _desktopItems[index];
        return _DesktopIcon(
          icon: item.icon,
          label: item.label,
          onTap: () {/* Handle tap */},
        );
      },
    );
  }
}

class _DesktopIcon extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _DesktopIcon({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<_DesktopIcon> createState() => _DesktopIconState();
}

class _DesktopIconState extends State<_DesktopIcon> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          decoration: BoxDecoration(
            color: _isHovered ? Colors.white10 : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.icon,
                size: 40,
                color: Colors.white,
              ),
              const SizedBox(height: 8),
              Text(
                widget.label,
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final _desktopItems = [
  _DesktopItem(Icons.folder, 'Documents'),
  _DesktopItem(Icons.folder, 'Downloads'),
  _DesktopItem(Icons.folder, 'Pictures'),
  _DesktopItem(Icons.folder, 'Music'),
  _DesktopItem(Icons.folder, 'Videos'),
  _DesktopItem(Icons.settings, 'Settings'),
];

class _DesktopItem {
  final IconData icon;
  final String label;

  _DesktopItem(this.icon, this.label);
}
