// ignore_for_file: public_member_api_docs
// ignore_for_file: type=lint

import 'package:collection/collection.dart';
import 'package:moengage_cards/moengage_cards.dart';

extension CardExtension on Card {
  Widget? getImageWidget() {
    return template.containers[0].widgets
        .firstWhereOrNull((Widget w) => w.widgetType == WidgetType.image);
  }

  Widget? getHeaderWidget() {
    return template.containers[0].widgets.firstWhereOrNull(
        (Widget w) => w.widgetType == WidgetType.text && w.id == 1);
  }

  Widget? getMessageWidget() {
    return template.containers[0].widgets.firstWhereOrNull(
        (Widget w) => w.widgetType == WidgetType.text && w.id == 2);
  }

  Widget? getButtonWidget() {
    return template.containers[0].widgets
        .firstWhereOrNull((Widget w) => w.widgetType == WidgetType.button);
  }

  Container? getContainer() {
    return template.containers.firstOrNull;
  }
}
