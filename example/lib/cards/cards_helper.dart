import 'package:collection/collection.dart';
import 'package:moengage_cards/moengage_cards.dart';

extension CardExtension on Card {
  Widget? getImageWidget() {
    return this
        .template
        .containers[0]
        .widgets
        .firstWhereOrNull((w) => w.widgetType == WidgetType.image);
  }

  Widget? getHeaderWidget() {
    return this
        .template
        .containers[0]
        .widgets
        .firstWhereOrNull((w) => w.widgetType == WidgetType.text && w.id == 1);
  }

  Widget? getMessageWidget() {
    return this
        .template
        .containers[0]
        .widgets
        .firstWhereOrNull((w) => w.widgetType == WidgetType.text && w.id == 2);
  }

  Widget? getButtonWidget() {
    return this
        .template
        .containers[0]
        .widgets
        .firstWhereOrNull((w) => w.widgetType == WidgetType.button);
  }

  Container? getContainer() {
    return this.template.containers.firstOrNull;
  }
}
