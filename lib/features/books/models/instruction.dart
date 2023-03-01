import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';

part 'instruction.g.dart';

@embedded
@JsonSerializable(explicitToJson: true)
class Instruction {
  String? text;

  String? image;

  Instruction({
    this.text,
    this.image,
  });

  factory Instruction.fromJson(Map<String, dynamic> json) => _$InstructionFromJson(json);

  Map<String, dynamic> toJson() => _$InstructionToJson(this);
}
