import '../internal/constants.dart';
import 'meta_data.dart' as moe;
import 'template.dart';

/// Card Campaign data
class Card {
  Card({
    required this.id,
    required this.cardId,
    required this.category,
    required this.template,
    required this.metaData,
  });

  factory Card.fromJson(Map<String, dynamic> json) {
    return Card(
      id: (json[keyId] ?? -1) as int,
      cardId: (json[keyCardId]) as String,
      category: (json[keyCategory] ?? '') as String,
      template:
          Template.fromJson(json[keyTemplateData] as Map<String, dynamic>),
      metaData:
          moe.MetaData.fromJson(json[keyMetaData] as Map<String, dynamic>),
    );
  }

  /// Internal Identifier for Card.
  int id;

  /// Unique identifier for the Card campaign
  String cardId;

  /// Category to which the campaign belongs.
  String category;

  /// Template payload for the campaign
  Template template;

  /// Meta data related to the campaign like status, delivery control etc.
  moe.MetaData metaData;

  Map<String, dynamic> toJson() => {
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
