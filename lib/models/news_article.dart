class NewsArticle {
  final String title;
  final String description;
  final String link;
  final String pubDate;
  final String imageUrl;
  final String source;

  NewsArticle({
    required this.title,
    required this.description,
    required this.link,
    required this.pubDate,
    required this.imageUrl,
    required this.source,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? 'No Description',
      link: json['link'] ?? '',
      pubDate: json['pubDate'] ?? '',
      imageUrl: json['image_url'] ?? ' ',
      source: json['source_id'] ?? 'Unknown Source',
    );
  }
}
