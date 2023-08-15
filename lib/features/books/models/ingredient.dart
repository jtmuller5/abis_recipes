import 'package:json_annotation/json_annotation.dart';

import 'note.dart';

part 'ingredient.g.dart';

@JsonSerializable(explicitToJson: true)
class Ingredient {
  String? name;

  String? amount;

  String? unit;

  Note? note;

  Ingredient({
    this.name,
    this.amount,
    this.unit,
    this.note,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) => _$IngredientFromJson(json);

  Map<String, dynamic> toJson() => _$IngredientToJson(this);

  // Copy with
  Ingredient copyWith({
    String? name,
    String? amount,
    String? unit,
    Note? note,
  }) {
    return Ingredient(
      name: name ?? this.name,
      amount: amount ?? this.amount,
      unit: unit ?? this.unit,
      note: note ?? this.note,
    );
  }

  // Copy with and remove note
  Ingredient copyWithNoNote() {
    return Ingredient(
      name: this.name,
      amount: this.amount,
      unit: this.unit,
      note: null,
    );
  }
}
