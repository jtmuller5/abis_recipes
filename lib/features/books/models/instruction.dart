import 'package:json_annotation/json_annotation.dart';

import 'note.dart';

part 'instruction.g.dart';

@JsonSerializable(explicitToJson: true)
class Instruction {

  String? text;

  String? image;

  bool? shortened;

  String? shortText;

  Note? note;

  Instruction({
    this.text,
    this.image,
    this.shortened = false,
    this.shortText,
    this.note,
  });

  factory Instruction.fromJson(Map<String, dynamic> json) => _$InstructionFromJson(json);

  Map<String, dynamic> toJson() => _$InstructionToJson(this);

  // Copy with and handle nulls
  Instruction copyWith({
    String? text,
    String? image,
    bool? shortened,
    String? shortText,
    Note? note,
  }) {
    return Instruction(
      text: text ?? this.text,
      image: image ?? this.image,
      shortened: shortened ?? this.shortened,
      shortText: shortText ?? this.shortText,
      note: note ?? this.note,
    );
  }

  // Copy with and remove note
  Instruction copyWithNoNote() {
    return Instruction(
      text: this.text,
      image: this.image,
      shortened: this.shortened,
      shortText: this.shortText,
      note: null,
    );
  }
}
