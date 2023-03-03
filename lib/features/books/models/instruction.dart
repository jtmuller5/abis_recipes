import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';

part 'instruction.g.dart';

@embedded
@JsonSerializable(explicitToJson: true)
class Instruction {

  String? text;

  String? image;

  bool? shortened;

  String? shortText;

  Instruction({
    this.text,
    this.image,
    this.shortened = false,
    this.shortText,
  });

  factory Instruction.fromJson(Map<String, dynamic> json) => _$InstructionFromJson(json);

  Map<String, dynamic> toJson() => _$InstructionToJson(this);

  // Copy with
  Instruction copyWith({
    String? text,
    String? image,
    bool? shortened,
    String? shortText,
  }) {
    return Instruction(
      text: text ?? this.text,
      image: image ?? this.image,
      shortened: shortened ?? this.shortened,
      shortText: shortText ?? this.shortText,
    );
  }
}
