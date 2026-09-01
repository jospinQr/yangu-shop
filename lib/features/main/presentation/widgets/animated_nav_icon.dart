import 'package:flutter/material.dart';

class AnimatedNavIcon extends StatefulWidget {
  const AnimatedNavIcon({
    required this.icon,
    required this.isSelected,
    super.key,
  });

  final IconData icon;
  final bool isSelected;

  @override
  State<AnimatedNavIcon> createState() => _AnimatedNavIconState();
}

class _AnimatedNavIconState extends State<AnimatedNavIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _wiggleController;
  late final Animation<double> _wiggleAnimation;

  @override
  void initState() {
    super.initState();
    _wiggleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );

    // Séquence gauche -> droite -> centre, en radians.
    _wiggleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 0.0,
          end: -0.18,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: -0.18,
          end: 0.18,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 0.18,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 25,
      ),
    ]).animate(_wiggleController);

    if (widget.isSelected) {
      _wiggleController.forward();
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedNavIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && !oldWidget.isSelected) {
      _wiggleController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _wiggleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedScale(
      scale: widget.isSelected ? 1.12 : 1,
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      child: AnimatedOpacity(
        opacity: widget.isSelected ? 1 : .72,
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        child: AnimatedBuilder(
          animation: _wiggleAnimation,
          builder: (context, child) {
            return Transform.rotate(
              angle: _wiggleAnimation.value,
              child: child,
            );
          },
          child: Icon(
            widget.icon,
            color: widget.isSelected
                ? colorScheme.primary
                : colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
