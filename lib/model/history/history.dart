// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class History {
  final String id;
  final String? item;
  final int? harga;
  final double? berat;
  final String? date;

  History({
    required this.id,
    this.item,
    this.harga,
    this.berat,
    this.date,
  });

  History copyWith({
    String? id,
    String? item,
    int? harga,
    double? berat,
    String? date,
  }) {
    return History(
      id: id ?? this.id,
      item: item ?? this.item,
      harga: harga ?? this.harga,
      berat: berat ?? this.berat,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'item': item,
      'harga': harga,
      'berat': berat,
      'date': date,
    };
  }

  factory History.fromMap(Map<String, dynamic> map) {
    return History(
      id: map['id'] as String,
      item: map['item'] != null ? map['item'] as String : null,
      harga: map['harga'] != null ? map['harga'] as int : null,
      berat: map['berat'] != null ? map['berat'] as double : null,
      date: map['date'] != null ? map['date'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory History.fromJson(String source) =>
      History.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'History(id: $id, item: $item, harga: $harga, berat: $berat, date: $date)';
  }

  @override
  bool operator ==(covariant History other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.item == item &&
        other.harga == harga &&
        other.berat == berat &&
        other.date == date;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        item.hashCode ^
        harga.hashCode ^
        berat.hashCode ^
        date.hashCode;
  }
}
