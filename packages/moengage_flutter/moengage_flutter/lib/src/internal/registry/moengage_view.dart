import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'moe_element_registry.dart';

/// Marks its [child] as targetable by a MoEngage element-anchored campaign.
///
/// Wrap anything you want a campaign to be able to point at:
///
/// ```dart
/// MoEngageView(
///   id: 'checkout_btn',
///   child: ElevatedButton(onPressed: onCheckout, child: const Text('Checkout')),
/// )
/// ```
///
/// This is the whole per-element integration - there is no `ValueKey` to add
/// alongside it. The wrapper registers itself with the SDK when it mounts, so
/// resolving `'checkout_btn'` later is a map lookup rather than a search of the
/// widget tree, and unregisters when it leaves so a campaign can never resolve
/// against a widget that is gone.
///
/// **[id] must be unique across the app.** A campaign names an element by its id
/// and nothing else, so an id used twice is ambiguous - the SDK anchors to
/// whichever instance mounted first, and logs a warning in debug builds.
///
/// The wrapper adds no layout of its own: it takes exactly the size and position
/// its child would have had, and delegates painting straight to it.
class MoEngageView extends SingleChildRenderObjectWidget {
  /// [MoEngageView] Constructor
  const MoEngageView({
    required this.id,
    required Widget child,
    super.key,
  }) : super(child: child);

  /// Identity of the element - unique across the app. This is what a campaign
  /// names.
  final String id;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      MoEElementRegistrationBox(id: id);

  @override
  void updateRenderObject(
    BuildContext context,
    covariant MoEElementRegistrationBox renderObject,
  ) {
    renderObject.id = id;
  }
}

/// Render object behind [MoEngageView]. Registers itself for as long as it is in
/// the tree, so the registry holds a live reference rather than a snapshot.
///
/// It reports no position of its own. The registry measures *through* this object
/// when something asks (`MoEElementRegistry.measure`), so the answer is whatever
/// is true at that instant - correct mid-scroll, mid-animation and after a
/// rotation, with nothing to invalidate and no per-frame work when nobody is
/// asking.
class MoEElementRegistrationBox extends RenderProxyBox {
  /// [MoEElementRegistrationBox] Constructor
  MoEElementRegistrationBox({required String id}) : _id = id;

  String _id;

  /// Identity of the element - see [MoEngageView.id].
  String get id => _id;
  set id(String value) {
    if (_id == value) {
      return;
    }
    MoEElementRegistry.instance().unregister(this);
    _id = value;
    if (attached) {
      MoEElementRegistry.instance().register(_id, this);
    }
  }

  @override
  void attach(PipelineOwner owner) {
    // `super` first, so `attached` is already true when the registry inspects
    // this box for its duplicate-id check.
    super.attach(owner);
    MoEElementRegistry.instance().register(_id, this);
  }

  @override
  void detach() {
    // Drop first: once detached the element is gone, and a campaign resolving
    // against it would measure a render object no longer in the tree.
    MoEElementRegistry.instance().unregister(this);
    super.detach();
  }
}
