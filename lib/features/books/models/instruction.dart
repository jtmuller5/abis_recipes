import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';

part 'instruction.g.dart';

@embedded
@JsonSerializable(explicitToJson: true)
class Instruction {
  int id = Isar.autoIncrement;

  String? text;

  String? image;

  bool? shortened;

  String? shortText;

  Instruction({
    this.id = Isar.autoIncrement,
    this.text,
    this.image,
    this.shortened = false,
    this.shortText,
  });

  factory Instruction.fromJson(Map<String, dynamic> json) => _$InstructionFromJson(json);

  Map<String, dynamic> toJson() => _$InstructionToJson(this);

  // Copy with
  Instruction copyWith({
    int? id,
    String? text,
    String? image,
    bool? shortened,
    String? shortText,
  }) {
    return Instruction(
      id: id ?? this.id,
      text: text ?? this.text,
      image: image ?? this.image,
      shortened: shortened ?? this.shortened,
      shortText: shortText ?? this.shortText,
    );
  }
}
