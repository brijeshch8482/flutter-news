import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(createToJson: false)
class Article {
  @JsonKey(defaultValue: 'unknown')
  late final String author;
  late final String? title;
  late final String? description;
  late final String? url;
  @JsonKey(name: 'urlToImage')
  late final String? imageUrl;
  late final String? publishedAt;
  late final String? content;
  late final ArticleSource source;

  Article(
      {required this.author,
      required this.title,
      required this.description,
      required this.url,
      required this.imageUrl,
      required this.publishedAt,
      required this.content,
      required this.source});


  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
        author: json['author'] ?? 'unknown',
        title: json['title'],
        description: json['description'],
        url: json['url'],
        imageUrl: json['urlToImage'],
        publishedAt: json['publishedAt'],
        content: json['content'],
        source: ArticleSource.fromJson(json['source'] as Map<String, dynamic>),
    );
  }
}

@JsonSerializable(createToJson: false)
class ArticleSource {
  late final String? id;
  late final String? name;

  ArticleSource({required this.id, required this.name});

  factory ArticleSource.fromJson(Map<String, dynamic> json) {
    return ArticleSource(
      id: json['id'],
      name: json['name'],
    );
  }
}
