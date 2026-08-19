import 'dart:ui' show PlatformDispatcher;

import 'package:flutter/rendering.dart';
import 'package:moengage_flutter_platform_interface/moengage_flutter_platform_interface.dart';

/// How much of a registered element is on screen right now, and where it is.
class MoEElementMeasurement {
  /// [MoEElementMeasurement] Constructor
  const MoEElementMeasurement({
    required this.bounds,
    required this.visibleFraction,
  });

  /// The element's bounds in physical pixels, as native expects them.
  final DesignModeElementBounds bounds;

  /// Fraction of the element's area currently inside the screen: `1.0` when
  /// fully on screen, `0.0` when entirely off it.
  ///
  /// Note this measures *clipping by the screen*, not occlusion - a widget
  /// covered by a bottom sheet still reports `1.0`, because Flutter offers no
  /// general "is anything painted over me" query.
  final double visibleFraction;

  /// Whether the element is entirely on screen - the gate a campaign uses
  /// before anchoring to it.
  bool get isFullyVisible => visibleFraction >= 1.0;
}

/// Index of every element wrapped in a `MoEngageView`, keyed by its id.
///
/// This is the alternative to walking the element tree: the wrapper registers
/// its render object when it mounts and drops it when it unmounts, so resolving
/// an element is a map lookup plus one `localToGlobal` - constant time, and
/// unaffected by how large the widget tree is.
///
/// Nothing is cached. The map holds the **live render object**, so every
/// measurement is taken at the moment it is asked for, which is correct
/// mid-scroll, mid-animation and after a rotation - there is no stale rect to
/// invalidate.
class MoEElementRegistry {
  /// Factory Constructor
  factory MoEElementRegistry.instance() => _instance;

  MoEElementRegistry._internal();

  static final MoEElementRegistry _instance = MoEElementRegistry._internal();

  /// Registered render objects per id. Ids are expected to be unique, but the
  /// value is a list so a duplicate can be observed and reported rather than
  /// silently overwriting the earlier entry.
  final Map<String, List<RenderBox>> _entries = <String, List<RenderBox>>{};

  /// Called by a `MoEngageView`'s render object when it attaches.
  void register(String id, RenderBox box) {
    final List<RenderBox> list =
        _entries.putIfAbsent(id, () => <RenderBox>[]);
    list.removeWhere((RenderBox e) => identical(e, box));
    list.add(box);
    assert(() {
      final int live = list.where((RenderBox e) => e.attached).length;
      if (live > 1) {
        Logger.w('MoEElementRegistry id "$id" is now used by $live mounted '
            'MoEngageViews. An id must be unique: a campaign names the id and '
            'nothing else, so this resolves to whichever attached first.');
      }
      return true;
    }());
  }

  /// Called when a `MoEngageView`'s render object detaches.
  void unregister(RenderBox box) {
    _entries.forEach((String _, List<RenderBox> list) {
      list.removeWhere((RenderBox e) => identical(e, box));
    });
    _entries.removeWhere((String _, List<RenderBox> list) => list.isEmpty);
  }

  /// Ids currently registered, for a "what can a campaign target here?" query.
  List<String> get registeredIds => _entries.keys.toList(growable: false);

  /// Whether anything usable is registered under [id].
  bool isRegistered(String id) => _resolve(id) != null;

  /// Measures [id] now. Returns `null` when nothing is registered under it, or
  /// the element isn't laid out yet.
  MoEElementMeasurement? measure(String id) {
    final RenderBox? box = _resolve(id);
    if (box == null) {
      return null;
    }
    final Rect? logical = _logicalRectOf(box);
    if (logical == null || logical.isEmpty) {
      return null;
    }
    final double ratio = _pixelRatio;
    return MoEElementMeasurement(
      bounds: DesignModeElementBounds(
        top: (logical.top * ratio).round(),
        left: (logical.left * ratio).round(),
        bottom: (logical.bottom * ratio).round(),
        right: (logical.right * ratio).round(),
      ),
      visibleFraction: _visibleFractionOf(logical),
    );
  }

  /// The first still-usable registration for [id] - attached and laid out.
  RenderBox? _resolve(String id) {
    final List<RenderBox>? list = _entries[id];
    if (list == null) {
      return null;
    }
    for (final RenderBox box in list) {
      if (box.attached && box.hasSize) {
        return box;
      }
    }
    return null;
  }

  /// Logical-pixel rect of [box] relative to the view origin.
  ///
  /// `localToGlobal` with no ancestor resolves to the render tree root, which is
  /// what native wants. It walks the box's own ancestor chain accumulating each
  /// transform and scroll offset - a depth walk of tens of nodes, not a search
  /// of the tree.
  Rect? _logicalRectOf(RenderBox box) {
    try {
      return box.localToGlobal(Offset.zero) & box.size;
    } catch (_) {
      return null;
    }
  }

  /// Intersection of [logical] with the screen, over the element's own area.
  double _visibleFractionOf(Rect logical) {
    final Size screen = _screenSize;
    final Rect clipped = logical.intersect(Offset.zero & screen);
    if (clipped.isEmpty) {
      return 0;
    }
    final double area = logical.width * logical.height;
    if (area <= 0) {
      return 0;
    }
    return ((clipped.width * clipped.height) / area).clamp(0.0, 1.0);
  }

  Size get _screenSize {
    try {
      final view = PlatformDispatcher.instance.views.first;
      return view.physicalSize / view.devicePixelRatio;
    } catch (_) {
      return Size.zero;
    }
  }

  double get _pixelRatio {
    try {
      return PlatformDispatcher.instance.views.first.devicePixelRatio;
    } catch (_) {
      return 1.0;
    }
  }
}
