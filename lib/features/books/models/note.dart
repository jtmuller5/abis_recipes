import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';

part 'note.g.dart';

@Collection()
@JsonSerializable(explicitToJson: true)
class Note {
  Id id = Isar.autoIncrement;
  String? text;
  int? recipeId;
  int? instructionId;
  int? ingredientId;
  DateTime? createdAt;
  DateTime? updatedAt;

  Note({
    this.id = Isar.autoIncrement,
    this.text,
    this.recipeId,
    this.ingredientId,
    this.instructionId,
    this.createdAt,
    this.updatedAt,
  });

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);

  Map<String, dynamic> toJson() => _$NoteToJson(this);
}
