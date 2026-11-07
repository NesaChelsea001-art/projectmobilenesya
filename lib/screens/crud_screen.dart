
import 'package:flutter/material.dart';

import '../models/item_model.dart';
import '../services/api_services.dart';

class CrudScreen extends StatefulWidget {
  const CrudScreen({super.key});

  @override
  State<CrudScreen> createState() => _CrudScreenState();
}

class _CrudScreenState extends State<CrudScreen> {
  final ApiService api = ApiService();

  List<ItemModel> _items = [];

  bool _isLoading = false;
  bool _isSubmitting = false;

  String? _errorMessage;

  // TEMA RUANG KABAR
  static const Color navy = Color(0xFF10213D);
  static const Color coral = Color(0xFFE85D4A);
  static const Color background = Color(0xFFF4F7FB);
  static const Color secondary = Color(0xFF68778C);

  Future<void> _loadItems() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await api.fetchCrudPosts();

      if (!mounted) return;

      setState(() {
        _items = data;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  // ==========================================
  // MEMBUKA FORM POSTINGAN
  // ==========================================
  Future<void> _showForm({ItemModel? item}) async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (dialogContext) {
        return _PostFormDialog(item: item);
      },
    );

    if (!mounted || result == null) return;

    await _saveItem(
      result['title']!,
      result['description']!,
      item: item,
    );
  }

  // ==========================================
  // POST DAN PUT DATA
  // ==========================================
  Future<void> _saveItem(
    String title,
    String desc, {
    ItemModel? item,
  }) async {
    if (_isSubmitting) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      // UPDATE DATA MENGGUNAKAN PUT
      if (item != null) {
        await api.updatePost(
          item.id,
          title,
          desc,
        );

        if (!mounted) return;

        setState(() {
          final index = _items.indexWhere(
            (element) => element.id == item.id,
          );

          if (index != -1) {
            _items[index] = ItemModel(
              id: item.id,
              title: title,
              description: desc,
              sourceName: item.sourceName,
              imageUrl: item.imageUrl,
              pubDate: item.pubDate,
              link: item.link,
            );
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Postingan berhasil diperbarui!'),
            backgroundColor: Colors.green,
          ),
        );
      }

      // CREATE DATA MENGGUNAKAN POST
      else {
        final hasil = await api.createPost(title, desc);

        if (!mounted) return;

        setState(() {
          _items.insert(
            0,
            ItemModel(
              id: hasil.id,
              title: title,
              description: desc,
              sourceName: 'JSONPlaceholder',
            ),
          );
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Postingan berhasil dikirim! ID: ${hasil.id}',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan data: $e'),
          backgroundColor: coral,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  // ==========================================
  // DELETE DATA MENGGUNAKAN API
  // ==========================================
  Future<void> _deleteItem(ItemModel item) async {
    if (_isSubmitting) return;

    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Hapus Postingan?'),
          content: Text(
            'Apakah kamu yakin ingin menghapus '
            '"${item.title}"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: coral,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (!mounted || konfirmasi != true) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      await api.deletePost(item.id);

      if (!mounted) return;

      setState(() {
        _items.removeWhere(
          (element) => element.id == item.id,
        );
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Postingan berhasil dihapus!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menghapus data: $e'),
          backgroundColor: coral,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  // ==========================================
  // CARD DATA POSTINGAN
  // ==========================================
  Widget _itemCard(ItemModel item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 13),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFDCE5EF),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: coral.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: const Text(
                  'POSTINGAN',
                  style: TextStyle(
                    color: coral,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: _isSubmitting
                    ? null
                    : () => _showForm(item: item),
                icon: const Icon(
                  Icons.edit_outlined,
                  color: navy,
                  size: 20,
                ),
                tooltip: 'Edit',
              ),
              IconButton(
                onPressed: _isSubmitting
                    ? null
                    : () => _deleteItem(item),
                icon: const Icon(
                  Icons.delete_outline,
                  color: coral,
                  size: 20,
                ),
                tooltip: 'Hapus',
              ),
            ],
          ),

          const SizedBox(height: 5),

          Text(
            item.title,
            style: const TextStyle(
              color: navy,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 7),

          Text(
            item.description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: secondary,
              fontSize: 12,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'ID: ${item.id}',
            style: const TextStyle(
              color: secondary,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // TAMPILAN KETIKA LOADING
  // ==========================================
  Widget _loadingWidget() {
    return const Padding(
      padding: EdgeInsets.all(40),
      child: Center(
        child: CircularProgressIndicator(
          color: coral,
        ),
      ),
    );
  }

  // ==========================================
  // TAMPILAN KETIKA API ERROR
  // ==========================================
  Widget _errorWidget() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.wifi_off_rounded,
            color: coral,
            size: 45,
          ),
          const SizedBox(height: 12),
          const Text(
            'Gagal Mengambil Data',
            style: TextStyle(
              color: navy,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _errorMessage ?? 'Terjadi kesalahan.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: secondary,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 15),
          ElevatedButton.icon(
            onPressed: _loadItems,
            icon: const Icon(Icons.refresh),
            label: const Text('Coba Lagi'),
            style: ElevatedButton.styleFrom(
              backgroundColor: coral,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // TAMPILAN KETIKA DATA KOSONG
  // ==========================================
  Widget _emptyWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 40,
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFDCE5EF),
        ),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.article_outlined,
            size: 55,
            color: Color(0xFF9AA8B8),
          ),
          SizedBox(height: 12),
          Text(
            'Belum Ada Postingan',
            style: TextStyle(
              color: navy,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Tekan tombol tambah untuk membuat '
            'postingan pertamamu.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: secondary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // TAMPILAN UTAMA
  // ==========================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,

      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Container(
              padding: const EdgeInsets.fromLTRB(
                20, 20, 20, 18,
              ),
              color: Colors.white,
              child: Row(
                children: [
                  Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      color: navy,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: const Icon(
                      Icons.edit_note_rounded,
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
                          'Kelola Data',
                          style: TextStyle(
                            color: navy,
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Ruang Kabar • Manajemen Postingan',
                          style: TextStyle(
                            color: secondary,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: _isLoading ? null : _loadItems,
                    icon: const Icon(
                      Icons.refresh,
                      color: navy,
                    ),
                    tooltip: 'Refresh Data',
                  ),
                ],
              ),
            ),

            // KONTEN
            Expanded(
              child: RefreshIndicator(
                color: coral,
                onRefresh: _loadItems,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(18),
                  children: [
                    // BANNER
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: navy,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.dashboard_customize,
                            color: Color(0xFFE85D4A),
                            size: 30,
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Kelola Postinganmu',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 7),
                          Text(
                            'Buat, edit, dan hapus postingan '
                            'dengan mudah melalui Ruang Kabar.',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    // JUDUL DAFTAR
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Daftar Postingan',
                            style: TextStyle(
                              color: navy,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          '${_items.length} Data',
                          style: const TextStyle(
                            color: coral,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    // KONDISI DATA
                    if (_isLoading)
                      _loadingWidget()
                    else if (_errorMessage != null)
                      _errorWidget()
                    else if (_items.isEmpty)
                      _emptyWidget()
                    else
                      ..._items.map(
                        (item) => _itemCard(item),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // TOMBOL TAMBAH POST
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (_isSubmitting || _isLoading)
            ? null
            : () => _showForm(),
        backgroundColor: coral,
        foregroundColor: Colors.white,
        icon: _isSubmitting
            ? const SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Icon(Icons.add),
        label: Text(
          _isSubmitting ? 'Memproses...' : 'Buat Post',
        ),
      ),
    );
  }
}

// ==========================================
// FORM POSTINGAN (DIPISAH DARI CRUD SCREEN)
// ==========================================
class _PostFormDialog extends StatefulWidget {
  final ItemModel? item;

  const _PostFormDialog({this.item});

  @override
  State<_PostFormDialog> createState() =>
      _PostFormDialogState();
}

class _PostFormDialogState extends State<_PostFormDialog> {
  late final TextEditingController titleController;
  late final TextEditingController descController;

  final formKey = GlobalKey<FormState>();

  static const Color navy = Color(0xFF10213D);
  static const Color coral = Color(0xFFE85D4A);
  static const Color secondary = Color(0xFF68778C);

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(
      text: widget.item?.title ?? '',
    );

    descController = TextEditingController(
      text: widget.item?.description ?? '',
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Row(
        children: [
          const Icon(Icons.edit_note, color: coral),
          const SizedBox(width: 10),
          Text(
            widget.item == null
                ? 'Buat Postingan'
                : 'Edit Postingan',
            style: const TextStyle(
              color: navy,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Judul Postingan',
                  hintText: 'Masukkan judul berita',
                  prefixIcon: const Icon(Icons.title),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Judul tidak boleh kosong';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: descController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Isi Postingan',
                  hintText: 'Tuliskan isi berita di sini...',
                  alignLabelWithHint: true,
                  prefixIcon: const Icon(Icons.description),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Isi postingan tidak boleh kosong';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Batal',
            style: TextStyle(color: secondary),
          ),
        ),

        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: coral,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            if (formKey.currentState!.validate()) {
              Navigator.pop(context, {
                'title': titleController.text.trim(),
                'description': descController.text.trim(),
              });
            }
          },
          child: Text(
            widget.item == null ? 'Kirim POST' : 'Simpan',
          ),
        ),
      ],
    );
  }
}
