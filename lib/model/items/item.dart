// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Item {
  String? id;
  String? nama_item;
  String? nama_kota;
  int? harga;
  dynamic dateItems;
  num? berat;
  Item({
    this.id,
    this.nama_item,
    this.nama_kota,
    this.harga,
    this.dateItems,
    this.berat,
  });

  Item copyWith({
    String? id,
    String? nama_item,
    String? nama_kota,
    int? harga,
    dynamic dateItems,
    num? berat,
  }) {
    return Item(
      id: id ?? this.id,
      nama_item: nama_item ?? this.nama_item,
      nama_kota: nama_kota ?? this.nama_kota,
      harga: harga ?? this.harga,
      dateItems: dateItems ?? this.dateItems,
      berat: berat ?? this.berat,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nama_item': nama_item,
      'nama_kota': nama_kota,
      'harga': harga,
      'dateItems': dateItems,
      'berat': berat,
    };
  }

  Map<String, dynamic> toMapDate() {
    return <String, dynamic>{
      'id': id,
      'nama_item': nama_item,
      'nama_kota': nama_kota,
      'harga': harga,
      'dateItems': dateItems["date"],
      'berat': berat,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['\$id'] != null ? map['\$id'] as String : null,
      nama_item: map['nama_item'] != null ? map['nama_item'] as String : null,
      nama_kota: map['nama_kota'] != null ? map['nama_kota'] as String : null,
      harga: map['harga'] != null ? map['harga'] as int : null,
      dateItems: map['dateItems'] as dynamic,
      berat: map['berat'] != null ? map['berat'] as num : null,
    );
  }

  String toJson() => json.encode(toMap());
  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['\$id'],
      nama_item: json['nama_item'],
      nama_kota: json['nama_kota'],
      harga: json['harga'],
      dateItems: json['dateItems'],
      berat: json['berat'],
    );
  }

  @override
  String toString() {
    return 'Item(id: $id, nama_item: $nama_item, nama_kota: $nama_kota, harga: $harga, dateItems: $dateItems, berat: $berat)';
  }

  @override
  bool operator ==(covariant Item other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.nama_item == nama_item &&
        other.nama_kota == nama_kota &&
        other.harga == harga &&
        other.dateItems == dateItems &&
        other.berat == berat;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        nama_item.hashCode ^
        nama_kota.hashCode ^
        harga.hashCode ^
        dateItems.hashCode ^
        berat.hashCode;
  }
}
