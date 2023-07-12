import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';

part 'book.g.dart';

@Collection()
@JsonSerializable(explicitToJson: true)
class Book {
  String? url;
  String title;
  String bookId;

  String? description;

  DateTime? dateCreated;

  Id id = Isar.autoIncrement;

  Book({
    required this.title,
    required this.bookId,
    this.id = Isar.autoIncrement,
    this.url,
    this.description,
    this.dateCreated,
  });

  factory Book.fromJson(Map<String, dynamic> json) => _$BookFromJson(json);

  Map<String, dynamic> toJson() => _$BookToJson(this);
}
