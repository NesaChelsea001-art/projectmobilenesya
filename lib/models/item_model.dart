
class ItemModel {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String sourceName;
  final String pubDate;
  final String link;

  ItemModel({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl = '',
    this.sourceName = '',
    this.pubDate = '',
    this.link = '',
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['article_id'] ?? '',
      title: json['title'] ?? 'Tidak ada judul',
      description: json['description'] ?? 'Tidak ada deskripsi',
      imageUrl: json['image_url'] ?? '',
      sourceName: json['source_name'] ?? 'Tidak diketahui',
      pubDate: json['pubDate'] ?? '',
      link: json['link'] ?? '',
    );
  }
}
