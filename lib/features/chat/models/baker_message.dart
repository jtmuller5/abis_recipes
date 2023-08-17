import 'package:abis_recipes/features/books/models/recipe.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'baker_message.freezed.dart';

part 'baker_message.g.dart';

@freezed
class BakerMessage with _$BakerMessage {
  const factory BakerMessage({
    required String? prompt,
    required String? response,
    @JsonKey(fromJson: getDateTimeFromTimestamp, toJson: getTimestampFromDateTime) required DateTime? createdAt,
  }) = _BakerMessage;

  const BakerMessage._();

  factory BakerMessage.fromJson(Map<String, Object?> json) => _$BakerMessageFromJson(json);
}
