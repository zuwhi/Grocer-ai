// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AccountModel {
  final String? id;
  final String? name;
  final String? email;
  final String? password;
  final String? role;
  final String? alamat;
  final String? telepon;
  final dynamic image;
  final String? fileId;
  final dynamic history;

  AccountModel(
      {this.id,
      this.name,
      this.email,
      this.password,
      this.role,
      this.alamat,
      this.telepon,
      this.image,
      this.fileId,
      this.history});

  AccountModel copyWith(
      {String? id,
      String? name,
      String? email,
      String? password,
      String? role,
      String? alamat,
      String? telepon,
      dynamic image,
      String? fileId,
      dynamic history}) {
    return AccountModel(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        password: password ?? this.password,
        role: role ?? this.role,
        alamat: alamat ?? this.alamat,
        telepon: telepon ?? this.telepon,
        image: image ?? this.image,
        fileId: fileId ?? this.fileId,
        history: history ?? this.history);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'role': role,
      'alamat': alamat,
      'telepon': telepon,
      'image': image,
      'fileId': fileId,
      'history': history
    };
  }

  factory AccountModel.fromMap(Map<String, dynamic> map) {
    return AccountModel(
        id: map['\$id'] != null ? map['\$id'] as String : null,
        name: map['name'] as String,
        email: map['email'] as String,
        password: map['password'] as String,
        role: map['role'] as String,
        alamat: map['alamat'] != null ? map['alamat'] as String : null,
        telepon: map['telepon'] != null ? map['telepon'] as String : null,
        image: map['image'] as dynamic,
        fileId: map['fileId'] != null ? map['fileId'] as String : null,
        history: map['history'] as dynamic);
  }

  String toJson() => json.encode(toMap());

  factory AccountModel.fromJson(String source) =>
      AccountModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AccountModel(id: $id, name: $name, email: $email, password: $password, role: $role, alamat: $alamat, telepon: $telepon, image: $image, fileId: $fileId, history: $history)';
  }

  @override
  bool operator ==(covariant AccountModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.email == email &&
        other.password == password &&
        other.role == role &&
        other.alamat == alamat &&
        other.telepon == telepon &&
        other.image == image &&
        other.fileId == fileId &&
        other.history == history;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        password.hashCode ^
        role.hashCode ^
        alamat.hashCode ^
        telepon.hashCode ^
        image.hashCode ^
        fileId.hashCode ^
        history.hashCode;
  }
}
