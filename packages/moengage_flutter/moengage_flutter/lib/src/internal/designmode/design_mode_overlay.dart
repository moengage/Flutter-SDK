import 'package:flutter/material.dart';

import 'boom_menu.dart';
import 'design_mode_controller.dart';
import 'element_node.dart';

/// Renders the Design Mode picker chrome: a persistent trigger [FloatingActionButton]
/// shown on every screen by default, plus - once activated - a full-screen
/// tap-catcher, a highlight box around the currently selected [ElementNode],
/// and the [BoomMenu] of pick actions. Inserted as an [OverlayEntry] above the
/// whole app by the design mode wrapper widget so it can draw over any screen.
class DesignModeOverlay extends StatelessWidget {
  /// [DesignModeOverlay] Constructor
  const DesignModeOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final DesignModeController controller = DesignModeController.instance();
    return ListenableBuilder(
      listenable: controller,
      builder: (BuildContext context, Widget? _) {
        final bool active = controller.state != DesignModePickerState.inactive;
        final bool paused = controller.state == DesignModePickerState.paused;
        final double pixelRatio = MediaQuery.of(context).devicePixelRatio;
        final ElementNode? node = controller.current;
        final Rect? logicalRect =
            node == null ? null : _toLogical(node.bounds, pixelRatio);

        return Stack(
          children: <Widget>[
            if (active)
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTapUp: paused
                      ? null
                      : (TapUpDetails details) =>
                          controller.selectAt(details.globalPosition),
                  child: CustomPaint(
                    painter: logicalRect == null
                        ? null
                        : _HighlightPainter(rect: logicalRect, paused: paused),
                  ),
                ),
              ),
            if (active && logicalRect != null)
              BoomMenu(
                anchor: Offset(
                  logicalRect.center.dx,
                  (logicalRect.top - 48).clamp(48, double.infinity),
                ),
                actions: _actionsFor(controller, paused),
              ),
            _DesignModeTriggerFab(active: active),
          ],
        );
      },
    );
  }

  List<BoomMenuAction> _actionsFor(
    DesignModeController controller,
    bool paused,
  ) {
    return <BoomMenuAction>[
      BoomMenuAction(
        icon: Icons.check,
        label: 'Confirm selection',
        isPrimary: true,
        onTap: controller.confirmSelection,
      ),
      BoomMenuAction(
        icon: paused ? Icons.play_arrow : Icons.pause,
        label: paused ? 'Resume picking' : 'Pause picking',
        onTap: paused ? controller.resume : controller.pause,
      ),
      BoomMenuAction(
        icon: Icons.search,
        label: 'Find in scroll',
        onTap: controller.findInScroll,
      ),
      BoomMenuAction(
        icon: Icons.arrow_upward,
        label: 'Select parent',
        onTap: controller.navigateToParent,
      ),
      BoomMenuAction(
        icon: Icons.arrow_downward,
        label: 'Select child',
        onTap: controller.navigateToChild,
      ),
      BoomMenuAction(
        icon: Icons.close,
        label: 'Cancel',
        onTap: controller.cancelSelection,
      ),
    ];
  }

  Rect _toLogical(Rect physicalRect, double pixelRatio) {
    return Rect.fromLTRB(
      physicalRect.left / pixelRatio,
      physicalRect.top / pixelRatio,
      physicalRect.right / pixelRatio,
      physicalRect.bottom / pixelRatio,
    );
  }
}

class _HighlightPainter extends CustomPainter {
  _HighlightPainter({required this.rect, required this.paused});

  final Rect rect;
  final bool paused;

  @override
  void paint(Canvas canvas, Size size) {
    final Color color = paused ? Colors.orange : Colors.blueAccent;
    final Paint fill = Paint()..color = color.withValues(alpha: 0.12);
    final Paint stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRect(rect, fill);
    canvas.drawRect(rect, stroke);
  }

  @override
  bool shouldRepaint(covariant _HighlightPainter oldDelegate) =>
      oldDelegate.rect != rect || oldDelegate.paused != paused;
}

/// Persistent trigger shown on every screen by default, letting a
/// marketer/QA user start or stop a Design Mode picking session directly from
/// the app, without requiring an explicit activation call from native.
class _DesignModeTriggerFab extends StatelessWidget {
  const _DesignModeTriggerFab({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    final DesignModeController controller = DesignModeController.instance();
    return Positioned(
      right: 16,
      bottom: 16,
      child: SafeArea(
        child: FloatingActionButton(
          heroTag: 'moeDesignModeTriggerFab',
          backgroundColor: active ? Colors.redAccent : Colors.blueAccent,
          onPressed: active ? controller.deactivate : controller.activate,
          child: Icon(active ? Icons.close : Icons.touch_app),
        ),
      ),
    );
  }
}
