// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserDetail {
  final String? alamat;
  final String? telepon;
  final dynamic image;
  final String? fileId;
  final String? role;
  final dynamic history;

  UserDetail(
      {this.alamat,
      this.telepon,
      required this.image,
      this.fileId,
      this.role,
      required this.history});

  UserDetail copyWith(
      {String? alamat,
      String? telepon,
      dynamic image,
      String? fileId,
      String? role,
      dynamic history}) {
    return UserDetail(
        alamat: alamat ?? this.alamat,
        telepon: telepon ?? this.telepon,
        image: image ?? this.image,
        fileId: fileId ?? this.fileId,
        role: role ?? this.role,
        history: history ?? this.history);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'alamat': alamat,
      'telepon': telepon,
      'image': image,
      'fileId': fileId,
      'role': role,
      'history': history
    };
  }

  factory UserDetail.fromMap(Map<String, dynamic> map) {
    return UserDetail(
        alamat: map['alamat'] != null ? map['alamat'] as String : null,
        telepon: map['telepon'] != null ? map['telepon'] as String : null,
        image: map['image'] as dynamic,
        fileId: map['fileId'] != null ? map['fileId'] as String : null,
        role: map['role'] != null ? map['role'] as String : null,
        history: map['history'] as dynamic);
  }

  String toJson() => json.encode(toMap());

  factory UserDetail.fromJson(String source) =>
      UserDetail.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserDetail(alamat: $alamat, telepon: $telepon, image: $image, fileId: $fileId, role: $role, history: $history)';
  }

  @override
  bool operator ==(covariant UserDetail other) {
    if (identical(this, other)) return true;

    return other.alamat == alamat &&
        other.telepon == telepon &&
        other.image == image &&
        other.fileId == fileId &&
        other.role == role &&
        other.history == history;
  }

  @override
  int get hashCode {
    return alamat.hashCode ^
        telepon.hashCode ^
        image.hashCode ^
        fileId.hashCode ^
        role.hashCode ^
        history.hashCode;
  }
}
