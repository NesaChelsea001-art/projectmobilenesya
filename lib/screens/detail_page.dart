
import 'package:flutter/material.dart';

import '../models/post.dart';

class DetailPage extends StatelessWidget {
  final Post post;

  const DetailPage({
    super.key,
    required this.post,
  });

  static const Color cream = Color(0xFFF5EFE5);
  static const Color beige = Color(0xFFE8DCCB);
  static const Color orange = Color(0xFFC87545);
  static const Color darkBrown = Color(0xFF352B25);
  static const Color softBrown = Color(0xFF8A7565);
  static const Color white = Color(0xFFFFFCF7);

  // GAMBAR BERITA
  Widget newsImage() {
    return post.imageUrl.isNotEmpty
        ? Image.network(
            post.imageUrl,
            width: double.infinity,
            height: 280,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return imagePlaceholder();
            },
          )
        : imagePlaceholder();
  }

  Widget imagePlaceholder() {
    return Container(
      height: 280,
      width: double.infinity,
      color: beige,
      child: const Center(
        child: Icon(
          Icons.photo_outlined,
          size: 55,
          color: softBrown,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cream,
      body: CustomScrollView(
        slivers: [
          // APP BAR DAN GAMBAR
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: cream,
            foregroundColor: darkBrown,
            elevation: 0,
            title: const Text(
              'RUANG KABAR',
              style: TextStyle(
                color: darkBrown,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                fontFamily: 'Georgia',
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  newsImage(),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.25),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ISI ARTIKEL
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: cream,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(22),
                ),
              ),
              transform: Matrix4.translationValues(0, -15, 0),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  20, 25, 20, 35,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // IDENTITAS ARTIKEL
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: orange,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            post.category.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        const Spacer(),
                        const Text(
                          'RUANG BACA',
                          style: TextStyle(
                            color: softBrown,
                            fontSize: 9,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // JUDUL
                    Text(
                      post.title,
                      style: const TextStyle(
                        color: darkBrown,
                        fontSize: 27,
                        height: 1.35,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Georgia',
                      ),
                    ),

                    const SizedBox(height: 18),

                    // SUMBER DAN TANGGAL
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 13,
                      ),
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(color: beige),
                          bottom: BorderSide(color: beige),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.newspaper_outlined,
                            size: 17,
                            color: orange,
                          ),
                          const SizedBox(width: 7),
                          const Text(
                            'SindoNews',
                            style: TextStyle(
                              color: darkBrown,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 15),
                          const Icon(
                            Icons.access_time,
                            size: 15,
                            color: softBrown,
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              post.pubDate.isEmpty
                                  ? 'Tanggal tidak tersedia'
                                  : post.pubDate,
                              style: const TextStyle(
                                color: softBrown,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    // PEMBUKA ARTIKEL
                    const Text(
                      'TENTANG BERITA INI',
                      style: TextStyle(
                        color: orange,
                        fontSize: 10,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      post.body,
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                        color: darkBrown,
                        fontSize: 15,
                        height: 1.9,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // SUMBER BERITA
                    if (post.link.isNotEmpty) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: beige),
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.link,
                                  color: orange,
                                  size: 18,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'SUMBER REFERENSI',
                                  style: TextStyle(
                                    color: darkBrown,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            SelectableText(
                              post.link,
                              style: const TextStyle(
                                color: orange,
                                fontSize: 12,
                                decoration:
                                    TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 35),

                    // FOOTER
                    const Center(
                      child: Column(
                        children: [
                          Divider(color: beige),
                          SizedBox(height: 15),
                          Text(
                            'RUANG KABAR',
                            style: TextStyle(
                              color: darkBrown,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                              fontFamily: 'Georgia',
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Setiap berita, punya cerita.',
                            style: TextStyle(
                              color: softBrown,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
