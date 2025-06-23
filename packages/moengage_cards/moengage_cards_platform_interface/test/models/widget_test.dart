import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:moengage_cards_platform_interface/src/model/enums/widget_type.dart';
import 'package:moengage_cards_platform_interface/src/model/style/widget_style.dart';
import 'package:moengage_cards_platform_interface/src/model/widget.dart' as card_widget;
import 'package:moengage_flutter/moengage_flutter.dart';

void main() {
  group('Widget Model', () {
    test('fromJson creates correct Widget instance', () {
      final json = {
        'id': 123,
        'type': 'image',
        'content': 'https://picsum.photos/200/200',
        'style': {'bgColor': '#1a2a3a'},
        'actions': [],
        'accessibility': {
          'text': 'Sample Label',
          'hint': 'Sample Hint',
        }
      };

      final widget = card_widget.Widget.fromJson(json);

      expect(widget.id, 123);
      expect(widget.content, 'https://picsum.photos/200/200');
      expect(widget.widgetType, WidgetType.image);
      expect(widget.style, isA<WidgetStyle>());
      expect(widget.accessibilityData, isA<AccessibilityData>());
      expect(widget.accessibilityData?.text, 'Sample Label');
    });

    test('fromJson handles missing accessibility fields', () {
      final json = {
        'id': 0,
        'type': 'image',
        'content': 'https://picsum.photos/200/200',
        'style': {'bgColor': '#1a2a3a'},
        'actions': []
      };

      final widget = card_widget.Widget.fromJson(json);
      expect(widget.accessibilityData, isNull);
    });

    test('toJson returns correct map when accessibility key is missing', () {
      final widget = card_widget.Widget(
        id: 1,
        widgetType: WidgetType.image,
        content: 'Image Content',
        style: null,
        actionList: [],
      );

      final json = widget.toJson();

      expect(json['id'], 1);
      expect(json['content'], 'Image Content');
      expect(json['widgetStyle'], null);
      expect(json['actions'], []);
      expect(json['accessibility'], null);
    });

    test('toJson returns correct map when accessibility key is present', () {
      final widget = card_widget.Widget(
        id: 1,
        widgetType: WidgetType.image,
        content: 'Image Content',
        style: null,
        actionList: [],
        accessibilityData: AccessibilityData('Accessible text', 'Accessible hint'),
      );

      final json = widget.toJson();

      expect(json['id'], 1);
      expect(json['content'], 'Image Content');
      expect(json['widgetStyle'], null);
      expect(json['actions'], []);
      expect(json['accessibility'], isNotNull);
      expect(json['accessibility']['text'], 'Accessible text');
      expect(json['accessibility']['hint'], 'Accessible hint');
    });
  });
}
