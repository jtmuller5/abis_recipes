import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ingredient.g.dart';

@embedded
@JsonSerializable(explicitToJson: true)
class Ingredient{

  int id = Isar.autoIncrement;

  String? name;

  String? amount;

  String? unit;

  Ingredient({
    this.id = Isar.autoIncrement,
    this.name,
    this.amount,
    this.unit,
  });

factory Ingredient.fromJson(Map<String, dynamic> json) => _$IngredientFromJson(json);

 Map<String, dynamic> toJson() => _$IngredientToJson(this);
 }