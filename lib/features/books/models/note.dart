import 'package:json_annotation/json_annotation.dart';

part 'note.g.dart';

@JsonSerializable(explicitToJson: true)
class Note {
  String? text;
  String? recipeId;
  DateTime? createdAt;
  DateTime? updatedAt;

  Note({
    this.text,
    this.recipeId,
    this.createdAt,
    this.updatedAt,
  });

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);

  Map<String, dynamic> toJson() => _$NoteToJson(this);
}
