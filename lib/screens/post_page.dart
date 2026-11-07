
import 'package:flutter/material.dart';

import '../models/post.dart';
import '../services/api_services.dart';
import 'detail_page.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final ApiService api = ApiService();

  late Future<List<Post>> futurePosts;

  final TextEditingController searchController =
      TextEditingController();

  String selectedCategory = 'SEMUA';
  bool _mengirim = false;

  // IDENTITAS WARNA RUANG KABAR
  static const Color cream = Color(0xFFF5EFE5);
  static const Color beige = Color(0xFFE8DCCB);
  static const Color orange = Color(0xFFC87545);
  static const Color darkBrown = Color(0xFF352B25);
  static const Color softBrown = Color(0xFF8A7565);
  static const Color white = Color(0xFFFFFCF7);

  final List<String> categories = [
    'SEMUA',
    'NASIONAL',
    'LIFESTYLE',
    'EDUKASI',
    'EKONOMI',
    'TEKNOLOGI',
    'DAERAH',
    'OLAHRAGA',
  ];

  @override
  void initState() {
    super.initState();
    futurePosts = api.fetchPosts();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // REFRESH BERITA
  void refreshPosts() {
    setState(() {
      futurePosts = api.fetchPosts();
    });
  }

  // FILTER BERITA
  List<Post> filterPosts(List<Post> posts) {
    return posts.where((post) {
      final keyword = searchController.text.toLowerCase();

      final matchesSearch =
          post.title.toLowerCase().contains(keyword);

      final matchesCategory =
          selectedCategory == 'SEMUA' ||
          post.category.toUpperCase().contains(selectedCategory);

      return matchesSearch && matchesCategory;
    }).toList();
  }

  // POST: MENGIRIM POSTINGAN
  Future<void> kirimPostingan(
    String title,
    String body,
    BuildContext dialogContext,
    StateSetter updateDialog,
  ) async {
    updateDialog(() {
      _mengirim = true;
    });

    try {
      final hasil = await api.createPost(title, body);

      if (!mounted) return;

      Navigator.pop(dialogContext);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Postingan berhasil dikirim! ID: ${hasil.id}',
          ),
          backgroundColor: darkBrown,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengirim postingan: $e'),
          backgroundColor: orange,
        ),
      );
    } finally {
      if (mounted && dialogContext.mounted) {
        updateDialog(() {
          _mengirim = false;
        });
      } else {
        _mengirim = false;
      }
    }
  }

  // FORM POST
  void tampilkanForm() {
    final titleController = TextEditingController();
    final bodyController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Row(
                children: [
                  Icon(
                    Icons.edit_note,
                    color: orange,
                    size: 28,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Buat Postingan',
                    style: TextStyle(
                      color: darkBrown,
                      fontWeight: FontWeight.bold,
                      fontSize: 19,
                    ),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      enabled: !_mengirim,
                      decoration: InputDecoration(
                        labelText: 'Judul Postingan',
                        filled: true,
                        fillColor: cream,
                        prefixIcon: const Icon(
                          Icons.title,
                          color: orange,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: bodyController,
                      enabled: !_mengirim,
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: 'Isi Postingan',
                        alignLabelWithHint: true,
                        filled: true,
                        fillColor: cream,
                        prefixIcon: const Icon(
                          Icons.description_outlined,
                          color: orange,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: _mengirim
                      ? null
                      : () => Navigator.pop(dialogContext),
                  child: const Text(
                    'Batal',
                    style: TextStyle(color: softBrown),
                  ),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: orange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _mengirim
                      ? null
                      : () {
                          final title =
                              titleController.text.trim();
                          final body =
                              bodyController.text.trim();

                          if (title.isEmpty || body.isEmpty) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Judul dan isi harus diisi!',
                                ),
                              ),
                            );
                            return;
                          }

                          kirimPostingan(
                            title,
                            body,
                            dialogContext,
                            setDialogState,
                          );
                        },
                  icon: _mengirim
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.send, size: 17),
                  label: Text(
                    _mengirim ? 'Mengirim...' : 'Kirim',
                  ),
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
      titleController.dispose();
      bodyController.dispose();
    });
  }

  // GAMBAR BERITA
  Widget newsImage(
    String imageUrl, {
    double? height,
    double? width,
    double radius = 12,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: imageUrl.isNotEmpty
          ? Image.network(
              imageUrl,
              height: height,
              width: width,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return imagePlaceholder(height, width);
              },
            )
          : imagePlaceholder(height, width),
    );
  }

  Widget imagePlaceholder(double? height, double? width) {
    return Container(
      height: height,
      width: width,
      color: beige,
      child: const Center(
        child: Icon(
          Icons.photo_outlined,
          color: softBrown,
          size: 38,
        ),
      ),
    );
  }

  // NAVIGASI DETAIL
  void bukaDetail(Post post) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailPage(post: post),
      ),
    );
  }

  // BERITA UTAMA
  Widget featuredNews(Post post) {
    return GestureDetector(
      onTap: () => bukaDetail(post),
      child: Container(
        height: 360,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: beige,
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: newsImage(
                post.imageUrl,
                radius: 18,
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.85),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 18,
              left: 18,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 8,
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
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              bottom: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'EDITOR\'S PICK',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    post.title,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      height: 1.3,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Georgia',
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      const Icon(
                        Icons.article_outlined,
                        color: Colors.white70,
                        size: 15,
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'SindoNews',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                      ),
                      const Spacer(),
                      const Text(
                        'Baca selengkapnya',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 15,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // BERITA TERBARU
  Widget latestNews(Post post) {
    return GestureDetector(
      onTap: () => bukaDetail(post),
      child: Container(
        margin: const EdgeInsets.only(bottom: 22),
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            newsImage(
              post.imageUrl,
              height: 185,
              width: double.infinity,
              radius: 14,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(13, 12, 13, 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.category.toUpperCase(),
                    style: const TextStyle(
                      color: orange,
                      fontSize: 10,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    post.title,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: darkBrown,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      height: 1.4,
                      fontFamily: 'Georgia',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(
                        Icons.public,
                        size: 13,
                        color: softBrown,
                      ),
                      const SizedBox(width: 5),
                      const Text(
                        'SindoNews',
                        style: TextStyle(
                          color: softBrown,
                          fontSize: 11,
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                        color: orange,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // JUDUL BAGIAN
  Widget sectionTitle(String title, {String? subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: darkBrown,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Georgia',
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 5),
          Text(
            subtitle,
            style: const TextStyle(
              color: softBrown,
              fontSize: 11,
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cream,
      body: SafeArea(
        child: FutureBuilder<List<Post>>(
          future: futurePosts,
          builder: (context, snapshot) {
            // LOADING
            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: orange,
                ),
              );
            }

            // ERROR
            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.cloud_off_outlined,
                        size: 55,
                        color: softBrown,
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'Berita belum dapat dimuat',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: darkBrown,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${snapshot.error}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: softBrown,
                        ),
                      ),
                      const SizedBox(height: 18),
                      ElevatedButton(
                        onPressed: refreshPosts,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: orange,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                ),
              );
            }

            final allPosts = snapshot.data ?? [];

            if (allPosts.isEmpty) {
              return const Center(
                child: Text(
                  'Belum ada berita tersedia',
                  style: TextStyle(color: darkBrown),
                ),
              );
            }

            final posts = filterPosts(allPosts);

            return Column(
              children: [
                // HEADER RUANG KABAR
                Container(
                  color: cream,
                  padding: const EdgeInsets.fromLTRB(
                    18, 15, 12, 15,
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          color: orange,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.menu_book_rounded,
                          color: Colors.white,
                          size: 27,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'RUANG KABAR',
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.1,
                                color: darkBrown,
                                fontFamily: 'Georgia',
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              'Temukan cerita, perluas wawasan.',
                              style: TextStyle(
                                fontSize: 10,
                                color: softBrown,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: tampilkanForm,
                        tooltip: 'Buat Postingan',
                        icon: const Icon(
                          Icons.edit_note,
                          color: orange,
                          size: 26,
                        ),
                      ),
                      IconButton(
                        onPressed: refreshPosts,
                        tooltip: 'Refresh Berita',
                        icon: const Icon(
                          Icons.refresh,
                          color: darkBrown,
                        ),
                      ),
                    ],
                  ),
                ),

                // SEARCH DAN KATEGORI
                Container(
                  color: cream,
                  padding: const EdgeInsets.only(
                    top: 5,
                    bottom: 15,
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                        ),
                        child: TextField(
                          controller: searchController,
                          onChanged: (_) => setState(() {}),
                          decoration: InputDecoration(
                            hintText: 'Cari sesuatu yang menarik...',
                            hintStyle: const TextStyle(
                              fontSize: 12,
                              color: softBrown,
                            ),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: orange,
                            ),
                            filled: true,
                            fillColor: white,
                            contentPadding:
                                const EdgeInsets.symmetric(
                              vertical: 13,
                            ),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        height: 38,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                          ),
                          itemCount: categories.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            final category = categories[index];
                            final selected =
                                selectedCategory == category;

                            return ChoiceChip(
                              label: Text(category),
                              selected: selected,
                              onSelected: (_) {
                                setState(() {
                                  selectedCategory = category;
                                });
                              },
                              selectedColor: orange,
                              backgroundColor: white,
                              labelStyle: TextStyle(
                                color: selected
                                    ? Colors.white
                                    : darkBrown,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              side: BorderSide(
                                color: selected
                                    ? orange
                                    : beige,
                              ),
                              showCheckmark: false,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(20),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // KONTEN BERITA
                Expanded(
                  child: posts.isEmpty
                      ? const Center(
                          child: Text(
                            'Berita tidak ditemukan',
                            style: TextStyle(
                              color: softBrown,
                              fontSize: 14,
                            ),
                          ),
                        )
                      : ListView(
                          padding: const EdgeInsets.fromLTRB(
                            18, 15, 18, 25,
                          ),
                          children: [
                            if (selectedCategory == 'SEMUA' &&
                                searchController.text.isEmpty) ...[
                              sectionTitle(
                                'Pilihan Hari Ini',
                                subtitle:
                                    'Berita yang menarik untuk kamu baca',
                              ),
                              const SizedBox(height: 16),
                              featuredNews(posts.first),
                              const SizedBox(height: 30),
                              Row(
                                children: [
                                  Expanded(
                                    child: sectionTitle(
                                      'Berita Terbaru',
                                      subtitle:
                                          'Informasi terkini dari berbagai kategori',
                                    ),
                                  ),
                                  Text(
                                    '${posts.length - 1} BERITA',
                                    style: const TextStyle(
                                      color: orange,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              ...posts.skip(1).map(latestNews),
                            ] else ...[
                              sectionTitle(
                                'Hasil Penelusuran',
                                subtitle:
                                    'Temukan berita sesuai minatmu',
                              ),
                              const SizedBox(height: 16),
                              ...posts.map(latestNews),
                            ],
                            const SizedBox(height: 10),
                            const Center(
                              child: Text(
                                'RUANG KABAR  •  SINDONEWS',
                                style: TextStyle(
                                  color: softBrown,
                                  fontSize: 9,
                                  letterSpacing: 1.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
