import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A single action shown in the [BoomMenu] fan-out.
class BoomMenuAction {
  /// [BoomMenuAction] Constructor
  const BoomMenuAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isPrimary = false,
  });

  /// Icon shown on the action button.
  final IconData icon;

  /// Accessibility label / tooltip for the action.
  final String label;

  /// Invoked when the action is tapped. The menu does not auto-close itself
  /// - callers decide whether the picker stays open.
  final VoidCallback onTap;

  /// Whether this action should be visually emphasized (e.g. "Confirm").
  final bool isPrimary;
}

/// A small "boom menu": a draggable trigger button that fans out into a ring
/// of [actions] around it. Used by Design Mode to offer pause/resume,
/// confirm, find-in-scroll, and parent/child navigation without covering the
/// highlighted element with a fixed toolbar.
class BoomMenu extends StatefulWidget {
  /// [BoomMenu] Constructor
  const BoomMenu({
    required this.actions,
    required this.anchor,
    super.key,
  });

  /// Actions to fan out when the trigger is tapped.
  final List<BoomMenuAction> actions;

  /// Logical-pixel position of the trigger button's center.
  final Offset anchor;

  @override
  State<BoomMenu> createState() => _BoomMenuState();
}

class _BoomMenuState extends State<BoomMenu>
    with SingleTickerProviderStateMixin {
  static const double _triggerRadius = 26;
  static const double _actionRadius = 22;
  static const double _fanRadius = 92;

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 220),
  );
  bool _open = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _open = !_open);
    if (_open) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final int count = widget.actions.length;
    const double extent = (_fanRadius + _actionRadius * 2) * 2;
    return Positioned(
      left: widget.anchor.dx - extent / 2,
      top: widget.anchor.dy - extent / 2,
      width: extent,
      height: extent,
      child: IgnorePointer(
        ignoring: false,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: <Widget>[
            for (int i = 0; i < count; i++)
              AnimatedBuilder(
                animation: _controller,
                builder: (BuildContext context, Widget? child) {
                  // Fan the actions across the top half-circle above the trigger.
                  final double angle = math.pi +
                      (count == 1
                          ? math.pi / 2
                          : (math.pi * (i / (count - 1))));
                  final double t = Curves.easeOutBack.transform(
                    _controller.value,
                  );
                  final double dx = math.cos(angle) * _fanRadius * t;
                  final double dy = math.sin(angle) * _fanRadius * t;
                  return Transform.translate(
                    offset: Offset(dx, dy),
                    child: Opacity(
                      opacity: _controller.value.clamp(0, 1),
                      child: child,
                    ),
                  );
                },
                child: _ActionButton(
                  action: widget.actions[i],
                  radius: _actionRadius,
                ),
              ),
            GestureDetector(
              onTap: _toggle,
              child: CircleAvatar(
                radius: _triggerRadius,
                backgroundColor: Colors.blueAccent,
                child: Icon(
                  _open ? Icons.close : Icons.touch_app,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.action, required this.radius});

  final BoomMenuAction action;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: action.label,
      child: GestureDetector(
        onTap: action.onTap,
        child: CircleAvatar(
          radius: radius,
          backgroundColor: action.isPrimary ? Colors.green : Colors.white,
          child: Icon(
            action.icon,
            size: radius,
            color: action.isPrimary ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}
