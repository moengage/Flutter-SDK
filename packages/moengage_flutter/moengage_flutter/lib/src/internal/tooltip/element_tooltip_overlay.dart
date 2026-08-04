import 'dart:io' show Platform;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:moengage_flutter_platform_interface/moengage_flutter_platform_interface.dart';

import 'moe_tooltip_controller.dart';

/// Renders the element tooltip as a Flutter-embedded `PlatformView` when
/// [MoETooltipController.renderMode] is [TooltipRenderMode.platformView].
/// Inserted as an [OverlayEntry] above the whole app by the design mode
/// wrapper widget, alongside the Design Mode picker overlay. No-op (renders
/// nothing) in [TooltipRenderMode.nativeOverlay], since native draws that
/// tooltip itself.
class ElementTooltipOverlay extends StatelessWidget {
  /// [ElementTooltipOverlay] Constructor
  const ElementTooltipOverlay({super.key});

  static const double _bubbleWidth = 260;
  static const double _bubbleHeight = 72;
  static const double _anchorGap = 8;

  @override
  Widget build(BuildContext context) {
    final MoETooltipController controller = MoETooltipController.instance();
    return ListenableBuilder(
      listenable: controller,
      builder: (BuildContext context, Widget? _) {
        final VisibleTooltip? tooltip = controller.current;
        if (tooltip == null ||
            controller.renderMode != TooltipRenderMode.platformView ||
            !Platform.isAndroid) {
          return const SizedBox.shrink();
        }
        return Positioned(
          left: tooltip.anchorRect.left,
          top: tooltip.anchorRect.bottom + _anchorGap,
          width: _bubbleWidth,
          height: _bubbleHeight,
          child: IgnorePointer(
            child: AndroidView(
              viewType: platformViewTypeElementTooltip,
              creationParams: <String, dynamic>{
                keyTooltipMessage: tooltip.message,
              },
              creationParamsCodec: const StandardMessageCodec(),
            ),
          ),
        );
      },
    );
  }
}
