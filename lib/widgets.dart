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
    final size = MediaQuery.of(context).size;
    return MouseRegion(
      onEnter: (_) => _scaleController.forward(),
      onExit: (_) => _scaleController.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateX(vector.radians(-10)),
          alignment: Alignment.center,
          child: GlassmorphicContainer(
            width: size.width * 0.4,
            height: 70,
            borderRadius: 35,
            blur: 15,
            alignment: Alignment.bottomCenter,
            border: 2,
            linearGradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.15),
                Colors.white.withOpacity(0.05),
              ],
            ),
            borderGradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.3),
                Colors.white.withOpacity(0.1),
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(35),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 15,
                    spreadRadius: -5,
                  ),
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
    final size = MediaQuery.of(context).size;
    return Center(
      child: GlassmorphicContainer(
        width: size.width * 0.7,
        height: size.height * 0.7,
        borderRadius: 30,
        blur: 20,
        alignment: Alignment.center,
        border: 2,
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
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            children: [
              _buildSearchBar(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 6,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: 18, // Number of apps
                    itemBuilder: (context, index) {
                      final apps = [
                        {'icon': Icons.terminal, 'label': 'Terminal'},
                        {'icon': Icons.web, 'label': 'Browser'},
                        {'icon': Icons.folder, 'label': 'Files'},
                        {'icon': Icons.mail, 'label': 'Mail'},
                        {'icon': Icons.chat, 'label': 'Chat'},
                        {'icon': Icons.settings, 'label': 'Settings'},
                        {'icon': Icons.camera, 'label': 'Camera'},
                        {'icon': Icons.music_note, 'label': 'Music'},
                        {'icon': Icons.videocam, 'label': 'Videos'},
                        {'icon': Icons.brush, 'label': 'Paint'},
                        {'icon': Icons.calculate, 'label': 'Calculator'},
                        {'icon': Icons.calendar_today, 'label': 'Calendar'},
                        {'icon': Icons.games, 'label': 'Games'},
                        {'icon': Icons.book, 'label': 'Books'},
                        {'icon': Icons.movie, 'label': 'Movies'},
                        {'icon': Icons.photo_library, 'label': 'Gallery'},
                        {'icon': Icons.shop, 'label': 'Store'},
                        {'icon': Icons.description, 'label': 'Notes'},
                      ];
                      return _buildAppIcon(
                        context,
                        apps[index]['icon'] as IconData,
                        apps[index]['label'] as String,
                      );
                    },
                  ),
                ),
              ),
              _buildQuickActions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: const Row(
        children: [
          Icon(Icons.search, color: Colors.white70),
          SizedBox(width: 16),
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

  Widget _buildAppIcon(BuildContext context, IconData icon, String label) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 40),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _buildActionButton(Icons.account_circle, 'User'),
              const SizedBox(width: 16),
              _buildActionButton(Icons.settings, 'Settings'),
            ],
          ),
          _buildActionButton(Icons.power_settings_new, 'Power'),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
