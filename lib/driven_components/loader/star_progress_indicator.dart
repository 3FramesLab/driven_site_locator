import 'dart:async';

import 'package:driven_site_locator/driven_components/driven_components.dart';

class StarProgressIndicator extends StatefulWidget {
  final String label;
  final Duration animationDuration;
  final Color starColor;
  final Color inactiveColor;
  final double starSize;

  const StarProgressIndicator({
    Key? key,
    this.label = '',
    this.animationDuration = const Duration(milliseconds: 800),
    this.starColor = Colors.amber,
    this.inactiveColor = Colors.grey,
    this.starSize = 30.0,
  }) : super(key: key);

  @override
  State<StarProgressIndicator> createState() => _StarProgressIndicatorState();
}

class _StarProgressIndicatorState extends State<StarProgressIndicator>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    _controllers = List.generate(3, (index) {
      return AnimationController(
        duration: widget.animationDuration,
        vsync: this,
      );
    });

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );
    }).toList();
  }

  Future<void> _startAnimations() async {
    for (int i = 0; i < _controllers.length; i++) {
      await Future.delayed(Duration(milliseconds: i * 200));
      if (mounted) {
        unawaited(_controllers[i].repeat(reverse: true));
      }
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: Colors.grey[700],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(3, (index) {
              return AnimatedBuilder(
                animation: _animations[index],
                builder: (context, child) {
                  return Transform.scale(
                    scale: 0.5 + (_animations[index].value * 0.5),
                    child: Opacity(
                      opacity: 0.3 + (_animations[index].value * 0.7),
                      child: Icon(
                        Icons.star,
                        size: widget.starSize,
                        color: Color.lerp(
                          widget.inactiveColor,
                          widget.starColor,
                          _animations[index].value,
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
          if (widget.label.isNotEmpty) ...[
            const SizedBox(width: 2),
            Text(
              widget.label,
              style: f14SemiBoldWhite,
            ),
          ]
        ],
      ),
    );
  }
}
