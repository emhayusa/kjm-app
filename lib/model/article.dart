import 'package:kjm_app/model/user.dart';

class Article {
  String uuid;
  String title;
  String writer;
  String content;
  String url;
  bool isActive;
  DateTime createdAt;
  String createdBy;
  DateTime updatedAt;
  String updatedBy;
  User user;
  ArticleCategoryClass articleCategory;
  ArticleCategoryClass articleType;

  Article({
    required this.uuid,
    required this.title,
    required this.writer,
    required this.content,
    required this.url,
    required this.isActive,
    required this.createdAt,
    required this.createdBy,
    required this.updatedAt,
    required this.updatedBy,
    required this.user,
    required this.articleCategory,
    required this.articleType,
  });

  factory Article.fromJson(Map<String, dynamic> json) => Article(
        uuid: json["uuid"],
        title: json["title"],
        writer: json["writer"],
        content: json["content"],
        url: json["url"],
        isActive: json["is_active"],
        createdAt: DateTime.parse(json["createdAt"]),
        createdBy: json["created_by"],
        updatedAt: DateTime.parse(json["updatedAt"]),
        updatedBy: json["updated_by"],
        user: User.fromJson(json["user"]),
        articleCategory:
            ArticleCategoryClass.fromJson(json["article_category"]),
        articleType: ArticleCategoryClass.fromJson(json["article_type"]),
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "title": title,
        "writer": writer,
        "content": content,
        "url": url,
        "is_active": isActive,
        "createdAt": createdAt.toIso8601String(),
        "created_by": createdBy,
        "updatedAt": updatedAt.toIso8601String(),
        "updated_by": updatedBy,
        "user": user.toJson(),
        "article_category": articleCategory.toJson(),
        "article_type": articleType.toJson(),
      };
}

class ArticleCategoryClass {
  String uuid;
  String name;

  ArticleCategoryClass({
    required this.uuid,
    required this.name,
  });

  factory ArticleCategoryClass.fromJson(Map<String, dynamic> json) =>
      ArticleCategoryClass(
        uuid: json["uuid"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "name": name,
      };
}
