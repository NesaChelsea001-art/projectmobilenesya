class Post {
  final String id;
  final String title;
  final String body;
  final String category;
  final String imageUrl;
  final String link;
  final String pubDate;

  Post({
    required this.id,
    required this.title,
    required this.body,
    required this.category,
    required this.imageUrl,
    required this.link,
    required this.pubDate,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    String readValue(List<String> keys, String fallback) {
      for (final key in keys) {
        final value = json[key];

        if (value != null && value.toString().trim().isNotEmpty) {
          return value.toString();
        }
      }
      return fallback;
    }

    return Post(
      id: readValue(['id', '_id'], ''),
      title: readValue(
        ['title', 'judul', 'headline'],
        'Tidak ada judul',
      ),
      body: readValue(
        ['description', 'body', 'content', 'summary', 'excerpt'],
        'Baca berita selengkapnya melalui sumber berita.',
      ),
      category: readValue(
        ['category', 'kategori'],
        'Nasional',
      ),
      imageUrl: readValue(
        ['imageUrl', 'image_url', 'thumbnail', 'image', 'gambar'],
        '',
      ),
      link: readValue(
        ['link', 'url', 'articleUrl'],
        '',
      ),
      pubDate: readValue(
        ['timestamp', 'pubDate', 'publishedAt', 'date'],
        '',
      ),
    );
  }
}