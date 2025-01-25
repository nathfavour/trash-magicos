import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

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

class _DesktopIconState extends State<_DesktopIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _elevationAnimation;
  double _rotateX = 0;
  double _rotateY = 0;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _elevationAnimation = Tween<double>(begin: 0, end: 8).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeOutBack),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _isHovered = true;
          _hoverController.forward();
        });
      },
      onExit: (_) {
        setState(() {
          _isHovered = false;
          _hoverController.reverse();
        });
      },
      onHover: (event) {
        setState(() {
          final size = context.size ?? Size.zero;
          _rotateX = (event.localPosition.dy - size.height / 2) / 10;
          _rotateY = (event.localPosition.dx - size.width / 2) / 10;
        });
      },
      child: AnimatedBuilder(
        animation: _hoverController,
        builder: (context, child) {
          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateX(vector.radians(_rotateX))
              ..rotateY(vector.radians(_rotateY))
              ..translate(0.0, 0.0, _elevationAnimation.value),
            alignment: Alignment.center,
            child: child,
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: _isHovered ? Colors.white10 : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Use custom 3D folder icon asset
              Image.asset(
                'assets/icons/folder_3d.png',
                width: 48,
                height: 48,
                fit: BoxFit.contain,
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

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
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
