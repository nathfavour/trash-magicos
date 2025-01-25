import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Ensure this import is present
import 'dart:ui'; // Add this import for BackdropFilter
import 'theme.dart'; // Add this import

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
    final screenWidth = MediaQuery.of(context).size.width;
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Opacity(
        opacity: 0.8,
        child: Container(
          height: 60,
          width: screenWidth * 0.4, // Reduce dock width to 40% of screen width
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 0.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: [
              DockIcon(icon: Icons.terminal, label: 'Terminal'),
              DockIcon(icon: Icons.web, label: 'Browser'),
              DockIcon(icon: Icons.folder, label: 'Files'),
              DockIcon(
                icon: Icons.apps,
                label: 'Apps',
                onTap: _handleStartMenuTap,
                isCentral: true,
              ),
              DockIcon(icon: Icons.mail, label: 'Mail'),
              DockIcon(icon: Icons.chat, label: 'Chat'),
              DockIcon(icon: Icons.settings, label: 'Settings'),
            ],
          ),
        ),
      ),
    ); // Added missing closing parentheses
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
  final Animation<double> animation;

  const StartMenu({
    super.key,
    required this.onClose,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height; // Add this line

    return Stack(
      children: [
        // Blur overlay for background
        Positioned.fill(
          child: BackdropFilter(

        // Start menu content
        Center(
          child: AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return Container(
                width: screenWidth * 0.6, // 60% of screen width
                height: screenHeight * 0.8 * animation.value, // Responsive height
                decoration: BoxDecoration(
                  color: Colors.black87.withOpacity(0.9),
                width: screenWidth * 0.6, // 60% of screen width
                height: screenHeight * 0.8 * animation.value, // Responsive height
                decoration: BoxDecoration(
                  color: Colors.black87.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 0.5,
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildSearchBar(),
                      _buildAppGrid(),
                      _buildQuickActions(),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Icon(Icons.search, color: Colors.white70),
            ),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search apps, files, and more...',
                  hintStyle: TextStyle(color: Colors.white70),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppGrid() {
    final apps = [
      {'icon': Icons.terminal, 'label': 'Terminal', 'color': Colors.grey},
      {'icon': Icons.web, 'label': 'Browser', 'color': Colors.blue},
      {'icon': Icons.folder, 'label': 'Files', 'color': Colors.orange},
      {'icon': Icons.mail, 'label': 'Mail', 'color': Colors.red},
      {'icon': Icons.chat, 'label': 'Chat', 'color': Colors.green},
      {'icon': Icons.settings, 'label': 'Settings', 'color': Colors.purple},
      {'icon': Icons.camera, 'label': 'Camera', 'color': Colors.pink},
      {'icon': Icons.music_note, 'label': 'Music', 'color': Colors.teal},
      {'icon': Icons.videocam, 'label': 'Videos', 'color': Colors.indigo},
      {'icon': Icons.brush, 'label': 'Paint', 'color': Colors.amber},
      {'icon': Icons.calculate, 'label': 'Calculator', 'color': Colors.cyan},
      {
        'icon': Icons.calendar_today,
        'label': 'Calendar',
        'color': Colors.brown
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: apps.length,
      itemBuilder: (context, index) {
        return _buildAppTile(
          icon: apps[index]['icon'] as IconData,
          label: apps[index]['label'] as String,
          color: apps[index]['color'] as Color,
        );
      },
    );
  }

  Widget _buildAppTile({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32, color: color),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildQuickActionButton(Icons.power_settings_new, 'Power'),
          _buildQuickActionButton(Icons.account_circle, 'Account'),
          _buildQuickActionButton(Icons.settings, 'Settings'),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(IconData icon, String label) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon),
          onPressed: () {},
          color: Colors.white70,
        ),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
