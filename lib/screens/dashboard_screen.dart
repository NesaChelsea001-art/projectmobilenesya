import 'package:flutter/material.dart';

import '../models/item_model.dart';
import '../services/api_services.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ApiService api = ApiService();

  late Future<List<ItemModel>> futureNews;

  static const Color cream = Color(0xFFF4F7FB);
  static const Color beige = Color(0xFFDCE5EF);
  static const Color orange = Color(0xFFE85D4A);
  static const Color darkBrown = Color(0xFF10213D);
  static const Color softBrown = Color(0xFF68778C);
  static const Color white = Color(0xFFFFFFFF);

  @override
  void initState() {
    super.initState();
    futureNews = api.fetchNews();
  }

  // REFRESH BERITA
  void refreshNews() {
    setState(() {
      futureNews = api.fetchNews();
    });
  }

  // WIDGET GAMBAR
  Widget newsImage(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: imageUrl.isNotEmpty
          ? Image.network(
              imageUrl,
              width: 95,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return imagePlaceholder();
              },
            )
          : imagePlaceholder(),
    );
  }

  Widget imagePlaceholder() {
    return Container(
      width: 95,
      height: 100,
      decoration: BoxDecoration(
        color: beige,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.photo_outlined, color: softBrown, size: 30),
    );
  }

  // JUDUL BAGIAN
  Widget sectionTitle(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: darkBrown,
            fontSize: 21,
            fontWeight: FontWeight.bold,
            fontFamily: 'Georgia',
          ),
        ),
        const SizedBox(height: 5),
        Text(subtitle, style: const TextStyle(color: softBrown, fontSize: 11)),
      ],
    );
  }

  // KARTU INFORMASI
  Widget informationCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: beige),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 38,
            width: 38,
            decoration: BoxDecoration(
              color: color.withOpacity(0.13),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, color: color, size: 21),
          ),
          const SizedBox(height: 13),
          Text(
            title,
            style: const TextStyle(
              color: darkBrown,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            description,
            style: const TextStyle(color: softBrown, fontSize: 10, height: 1.4),
          ),
        ],
      ),
    );
  }

  // KARTU BERITA
  Widget newsCard(ItemModel item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 13),
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: beige),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          newsImage(item.imageUrl),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.sourceName.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: orange,
                    fontSize: 9,
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  item.title,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: darkBrown,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    height: 1.35,
                    fontFamily: 'Georgia',
                  ),
                ),
                const SizedBox(height: 9),
                const Row(
                  children: [
                    Icon(Icons.article_outlined, size: 12, color: softBrown),
                    SizedBox(width: 5),
                    Text(
                      'Berita terkini',
                      style: TextStyle(color: softBrown, fontSize: 10),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cream,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 25),
          children: [
            // HEADER
            Row(
              children: [
                Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                    color: orange,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: const Icon(
                    Icons.menu_book_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 11),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'RUANG KABAR',
                        style: TextStyle(
                          color: darkBrown,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          fontFamily: 'Georgia',
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Your daily reading space',
                        style: TextStyle(color: softBrown, fontSize: 10),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: refreshNews,
                  tooltip: 'Refresh',
                  icon: const Icon(Icons.refresh, color: darkBrown),
                ),
              ],
            ),

            const SizedBox(height: 25),

            // BANNER SAMBUTAN
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: darkBrown,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -8,
                    top: -5,
                    child: Icon(
                      Icons.auto_stories,
                      size: 105,
                      color: Colors.white.withOpacity(0.08),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 11,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: orange,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'WELCOME TO RUANG KABAR',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            letterSpacing: 1,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 19),
                      const Text(
                        'Setiap berita,\npunya cerita.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 29,
                          height: 1.25,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Georgia',
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Temukan informasi terbaru dan perluas '
                        'wawasanmu bersama Ruang Kabar.',
                        style: TextStyle(
                          color: Color(0xFFD8CFC4),
                          fontSize: 12,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Row(
                        children: [
                          Text(
                            'READ MORE, KNOW MORE',
                            style: TextStyle(
                              color: Color(0xFFE4B18E),
                              fontSize: 9,
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward,
                            color: Color(0xFFE4B18E),
                            size: 14,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // INFORMASI
            sectionTitle(
              'Jelajahi Ruang Kabar',
              'Temukan berbagai informasi dalam satu tempat.',
            ),

            const SizedBox(height: 15),

            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.15,
              children: [
                informationCard(
                  icon: Icons.newspaper_rounded,
                  title: 'Berita Terkini',
                  description: 'Ikuti informasi dan peristiwa terbaru.',
                  color: orange,
                ),
                informationCard(
                  icon: Icons.travel_explore_rounded,
                  title: 'Wawasan Baru',
                  description:
                      'Baca berbagai topik untuk menambah pengetahuan.',
                  color: softBrown,
                ),
              ],
            ),

            const SizedBox(height: 30),

            // BERITA TERBARU
            Row(
              children: [
                Expanded(
                  child: sectionTitle(
                    'Berita Terbaru',
                    'Informasi pilihan untuk menemani harimu.',
                  ),
                ),
                TextButton(
                  onPressed: refreshNews,
                  child: const Text(
                    'Refresh',
                    style: TextStyle(
                      color: orange,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            FutureBuilder<List<ItemModel>>(
              future: futureNews,
              builder: (context, snapshot) {
                // LOADING
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(25),
                    child: Center(
                      child: CircularProgressIndicator(color: orange),
                    ),
                  );
                }

                // ERROR
                if (snapshot.hasError) {
                  return Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.cloud_off_outlined,
                          size: 35,
                          color: softBrown,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Berita belum dapat dimuat',
                          style: TextStyle(
                            color: darkBrown,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '${snapshot.error}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: softBrown,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: refreshNews,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: orange,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  );
                }

                // DATA KOSONG
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(
                      child: Text(
                        'Belum ada berita tersedia',
                        style: TextStyle(color: softBrown),
                      ),
                    ),
                  );
                }

                final news = snapshot.data!;

                return Column(
                  children: news.take(5).map((item) => newsCard(item)).toList(),
                );
              },
            ),

            const SizedBox(height: 15),

            // FOOTER
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: beige)),
              ),
              child: const Column(
                children: [
                  Text(
                    'RUANG KABAR',
                    style: TextStyle(
                      color: darkBrown,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      fontFamily: 'Georgia',
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Tempat menemukan informasi dan cerita terkini.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: softBrown, fontSize: 10),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
