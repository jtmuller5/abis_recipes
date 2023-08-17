import 'package:abis_recipes/app/constants.dart';
import 'package:abis_recipes/features/books/models/recipe.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'book.freezed.dart';

part 'book.g.dart';

@freezed
class Book with _$Book {
  const factory Book({
    required String? url,
    required String title,
    required String bookId,
    required String? description,
    required Pastry pastry,
    @JsonKey(fromJson: getDateTimeFromTimestamp, toJson: getTimestampFromDateTime) required DateTime? dateCreated,
    required Recipe? lastRecipe,
    required int? recipeCount,
  }) = _Book;

  const Book._();

  factory Book.fromJson(Map<String, Object?> json) => _$BookFromJson(json);
}
