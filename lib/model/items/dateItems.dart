// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class DateItems {
  final String? id;
  final String date;

  DateItems({
    this.id,
    required this.date,
  });

  DateItems copyWith({
    String? id,
    String? date,
  }) {
    return DateItems(
      id: id ?? this.id,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'date': date,
    };
  }

  factory DateItems.fromMap(Map<String, dynamic> map) {
    return DateItems(
      id: map['\$id'] != null ? map['\$id'] as String : null,
      date: map['date'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory DateItems.fromJson(String source) =>
      DateItems.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'DateItems(id: $id, date: $date)';

  @override
  bool operator ==(covariant DateItems other) {
    if (identical(this, other)) return true;

    return other.id == id && other.date == date;
  }

  @override
  int get hashCode => id.hashCode ^ date.hashCode;
}
