// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Posts {
  final String? id;
  final String? title;
  final String? desc;
  final dynamic image;
  final String? fileId;
  final String? date;
  final String? category;
  final String? accountId;
  final int? views;
  final String? author;
  Posts({
    this.id,
    this.title,
    this.desc,
    this.image,
    this.fileId,
    this.date,
    this.category,
    this.accountId,
    this.views,
    this.author,
  });

  Posts copyWith({
    String? id,
    String? title,
    String? desc,
    dynamic image,
    String? fileId,
    String? date,
    String? category,
    String? accountId,
    int? views,
    String? author,
  }) {
    return Posts(
      id: id ?? this.id,
      title: title ?? this.title,
      desc: desc ?? this.desc,
      image: image ?? this.image,
      fileId: fileId ?? this.fileId,
      date: date ?? this.date,
      category: category ?? this.category,
      accountId: accountId ?? this.accountId,
      views: views ?? this.views,
      author: author ?? this.author,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'desc': desc,
      'image': image,
      'fileId': fileId,
      'date': date,
      'category': category,
      'accountId': accountId,
      'views': views,
      'author': author,
    };
  }

  factory Posts.fromMap(Map<String, dynamic> map) {
    return Posts(
      id: map['\$id'] != null ? map['\$id'] as String : null,
      title: map['title'] as String,
      desc: map['desc'] != null ? map['desc'] as String : null,
      image: map['image'] as dynamic,
      fileId: map['fileId'] != null ? map['fileId'] as String : null,
      date: map['date'] != null ? map['date'] as String : null,
      category: map['category'] != null ? map['category'] as String : null,
      accountId: map['accountId'] != null ? map['accountId'] as String : null,
      views: map['views'] != null ? map['views'] as int : null,
      author: map['author'] != null ? map['author'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Posts.fromJson(String source) =>
      Posts.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Posts(id: $id, title: $title, desc: $desc, image: $image, fileId: $fileId, date: $date, category: $category, accountId: $accountId, views: $views, author: $author)';
  }

  @override
  bool operator ==(covariant Posts other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.desc == desc &&
        other.image == image &&
        other.fileId == fileId &&
        other.date == date &&
        other.category == category &&
        other.accountId == accountId &&
        other.views == views &&
        other.author == author;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        desc.hashCode ^
        image.hashCode ^
        fileId.hashCode ^
        date.hashCode ^
        category.hashCode ^
        accountId.hashCode ^
        views.hashCode ^
        author.hashCode;
  }
}
