
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/post.dart';
import '../models/item_model.dart';

class ApiService {
  // API BERITA SINDONEWS
  static const String newsUrl =
      'https://ikhlasapi.web.id/api/berita/sindonews';

  // API KHUSUS CRUD
  static const String crudUrl =
      'https://jsonplaceholder.typicode.com/posts';

  // ==========================================
  // GET BERITA SINDONEWS (UNTUK DASHBOARD)
  // ==========================================
  Future<List<Post>> fetchPosts() async {
    try {
      final response = await http.get(
        Uri.parse(newsUrl),
        headers: {
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        List<dynamic> data = [];

        if (decoded is List) {
          data = decoded;
        } else if (decoded is Map<String, dynamic>) {
          dynamic result = decoded;

          for (final key in [
            'data',
            'result',
            'results',
            'articles',
            'posts',
            'items',
          ]) {
            if (result is Map<String, dynamic> &&
                result[key] != null) {
              result = result[key];
            }
          }

          if (result is List) {
            data = result;
          } else if (result is Map<String, dynamic>) {
            if (result.containsKey('title') ||
                result.containsKey('headline')) {
              data = [result];
            }
          }
        }

        return data
            .whereType<Map>()
            .map(
              (item) => Post.fromJson(
                Map<String, dynamic>.from(item),
              ),
            )
            .toList();
      }

      throw Exception(
        'Gagal mengambil berita: ${response.statusCode}',
      );
    } catch (e) {
      print('ERROR BERITA: $e');
      rethrow;
    }
  }

  // ==========================================
  // GET DATA POSTINGAN (UNTUK CRUD)
  // ==========================================
  Future<List<ItemModel>> fetchCrudPosts() async {
    try {
      final response = await http.get(
        Uri.parse('$crudUrl?_start=0&_limit=20'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        return data.map((item) {
          return ItemModel(
            id: item['id'].toString(),
            title: item['title'] ?? 'Tidak ada judul',
            description: item['body'] ?? 'Tidak ada isi',
            sourceName: 'JSONPlaceholder',
          );
        }).toList();
      }

      throw Exception(
        'Gagal mengambil postingan: ${response.statusCode}',
      );
    } catch (e) {
      print('ERROR GET CRUD: $e');
      rethrow;
    }
  }

  // ==========================================
  // POST: MENAMBAH POSTINGAN
  // ==========================================
  Future<Post> createPost(String title, String body) async {
    try {
      final response = await http.post(
        Uri.parse(crudUrl),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'title': title,
          'body': body,
          'userId': 1,
        }),
      );

      if (response.statusCode == 201) {
        return Post.fromJson(
          jsonDecode(response.body),
        );
      }

      throw Exception(
        'Gagal menambahkan postingan: ${response.statusCode}',
      );
    } catch (e) {
      print('ERROR POST: $e');
      rethrow;
    }
  }

  // ==========================================
  // PUT: MENGEDIT POSTINGAN
  // ==========================================
  Future<void> updatePost(
    String id,
    String title,
    String body,
  ) async {
    final response = await http.put(
      Uri.parse('$crudUrl/$id'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'id': int.tryParse(id) ?? id,
        'title': title,
        'body': body,
        'userId': 1,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Gagal mengedit postingan: ${response.statusCode}',
      );
    }
  }

  // ==========================================
  // DELETE: MENGHAPUS POSTINGAN
  // ==========================================
  Future<void> deletePost(String id) async {
    final response = await http.delete(
      Uri.parse('$crudUrl/$id'),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Gagal menghapus postingan: ${response.statusCode}',
      );
    }
  }

  // ==========================================
  // GET BERITA UNTUK DASHBOARD
  // ==========================================
  Future<List<ItemModel>> fetchNews() async {
    final posts = await fetchPosts();

    return posts.map((post) {
      return ItemModel(
        id: post.id,
        title: post.title,
        description: post.body,
        imageUrl: post.imageUrl,
        sourceName: 'SindoNews',
        pubDate: post.pubDate,
        link: post.link,
      );
    }).toList();
  }
}
