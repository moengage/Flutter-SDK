import 'package:moengage_cards/src/internal/contants.dart';
import 'package:moengage_cards/src/model/template.dart';

import 'meta_data.dart' as moe;

class Card {
  int id;
  String cardId;
  String category;
  Template template;
  moe.MetaData metaData;

  Card({required this.id, required this.cardId, required this.category, required this.template, required this.metaData});

  factory Card.fromJson(Map<String, dynamic> json) {
    return Card(
        id: json[keyId] ?? -1,
        cardId: json[keyCardId],
        category: json[keyCategory] ?? "",
        template: Template.fromJson(json[keyTemplateData]),
        metaData: moe.MetaData.fromJson(json[keyMetaData]));
  }

  Map<String, dynamic> toJson() =>
      {
        keyId: id,
        keyCardId: cardId,
        keyCategory: category,
        keyTemplateData: template.toJson(),
        keyMetaData: metaData.toJson()
      };

  @override
  String toString() {
    return 'Card{id: $id, cardId: $cardId, category: $category, template: $template, metaData: $metaData}';
  }
}
