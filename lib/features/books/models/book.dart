import 'package:abis_recipes/features/books/models/recipe.dart';
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
    required DateTime dateCreated,
    required Recipe? lastRecipe
  }) = _Book;


  const Book._();

  factory Book.fromJson(Map<String, Object?> json) => _$BookFromJson(json);
}