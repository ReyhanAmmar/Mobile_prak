import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_dua/core/widgets/common_widgets.dart';
import 'package:mobile_dua/features/mahasiswa/data/models/mahasiswa_model.dart';
import 'package:mobile_dua/features/mahasiswa/presentation/providers/mahasiswa_provider.dart';

class MahasiswaPage extends ConsumerWidget {
  const MahasiswaPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mahasiswaState = ref.watch(mahasiswaNotifierProvider);
    final savedMahasiswa = ref.watch(savedMahasiswaProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Total Mahasiswa'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => ref.invalidate(mahasiswaNotifierProvider),
            tooltip: 'Refresh',
          ), // IconButton
        ],
      ), // AppBar
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // — Section: Data Tersimpan di SharedPreferences ——
          _SavedMahasiswaSection(savedMahasiswa: savedMahasiswa, ref: ref),

          // — Section Title ——————————————————————————————
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Text(
              'Daftar Mahasiswa',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ), // Text
          ), // Padding

          // — Mahasiswa List —————————————————————————————
          Expanded(
            child: mahasiswaState.when(
              loading: () => const LoadingWidget(),
              error: (error, stack) => CustomErrorWidget(
                message: 'Gagal memuat data mahasiswa: ${error.toString()}',
                onRetry: () {
                  ref.read(mahasiswaNotifierProvider.notifier).refresh();
                },
              ), // CustomErrorWidget
              data: (mahasiswaList) => _MahasiswaListWithSave(
                mahasiswaList: mahasiswaList,
                onRefresh: () => ref.invalidate(mahasiswaNotifierProvider),
              ), // _MahasiswaListWithSave
            ),
          ), // Expanded
        ],
      ), // Column
    ); // Scaffold
  }
}

class _SavedMahasiswaSection extends ConsumerWidget {
  final AsyncValue<List<Map<String, String>>> savedMahasiswa;
  final WidgetRef ref;

  const _SavedMahasiswaSection(
      {required this.savedMahasiswa, required this.ref});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header dengan tombol hapus semua
          Row(
            children: [
              const Icon(Icons.storage_rounded, size: 16),
              const SizedBox(width: 6),
              const Text(
                'Data Tersimpan di Local Storage',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ), // Text
              const Spacer(),
              savedMahasiswa.maybeWhen(
                data: (list) => list.isNotEmpty
                    ? TextButton.icon(
                  onPressed: () async {
                    await ref
                        .read(mahasiswaNotifierProvider.notifier)
                        .clearSavedMahasiswa();
                    ref.invalidate(savedMahasiswaProvider);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Semua data tersimpan dihapus'),
                        ), // SnackBar
                      );
                    }
                  },
                  icon: const Icon(
                    Icons.delete_sweep_outlined,
                    size: 14,
                    color: Colors.red,
                  ), // Icon
                  label: const Text(
                    'Hapus Semua',
                    style: TextStyle(fontSize: 12, color: Colors.red),
                  ), // Text
                ) // TextButton.icon
                    : const SizedBox.shrink(),
                orElse: () => const SizedBox.shrink(),
              ),
            ],
          ), // Row
          const SizedBox(height: 8),

          // Content
          savedMahasiswa.when(
            loading: () => const LinearProgressIndicator(),
            error: (_, __) => const Text(
              'Gagal membaca data tersimpan',
              style: TextStyle(color: Colors.red, fontSize: 12),
            ), // Text
            data: (list) {
              if (list.isEmpty) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ), // BoxDecoration
                  child: const Row(
                    children: [
                      Icon(Icons.info_outline, size: 16, color: Colors.grey),
                      SizedBox(width: 8),
                      Text(
                        'Belum ada data. Tap ikon 💾 untuk menyimpan.',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ), // Text
                    ],
                  ), // Row
                ); // Container
              }

              return Container(
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ), // BoxDecoration
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: list.length,
                  separatorBuilder: (_, __) => Divider(
                    height: 1,
                    color: Colors.blue.shade100,
                    indent: 12,
                    endIndent: 12,
                  ), // Divider
                  itemBuilder: (context, index) {
                    final item = list[index];
                    return ListTile(
                      dense: true,
                      leading: CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.blue.shade100,
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ), // Text
                      ), // CircleAvatar
                      title: Text(item['name'] ?? '-'),
                      subtitle: Text(
                        'ID: ${item['mahasiswa_id']} • ${_formatDate(item['saved_at'] ?? '')}',
                        style: const TextStyle(fontSize: 11),
                      ), // Text
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.close,
                          size: 16,
                          color: Colors.red,
                        ), // Icon
                        onPressed: () async {
                          await ref
                              .read(mahasiswaNotifierProvider.notifier)
                              .removeSavedMahasiswa(
                              item['mahasiswa_id'] ?? '');
                          ref.invalidate(savedMahasiswaProvider);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                Text('${item['name']} dihapus'),
                              ), // SnackBar
                            );
                          }
                        },
                      ), // IconButton
                    ); // ListTile
                  },
                ), // ListView.separated
              ); // Container
            },
          ), // savedMahasiswa.when
        ],
      ), // Column
    ); // Padding
  }

  String _formatDate(String isoString) {
    if (isoString.isEmpty) return '-';
    try {
      final date = DateTime.parse(isoString);
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
    } catch (e) {
      return isoString;
    }
  }
}

class _MahasiswaListWithSave extends ConsumerWidget {
  final List<MahasiswaModel> mahasiswaList;
  final VoidCallback onRefresh;

  const _MahasiswaListWithSave({
    required this.mahasiswaList,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: ListView.builder(
        itemCount: mahasiswaList.length,
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        itemBuilder: (context, index) {
          final mahasiswa = mahasiswaList[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              leading: CircleAvatar(
                child: Text('${mahasiswa.id}'),
              ), // CircleAvatar
              title: Text(mahasiswa.name),
              subtitle: Text(
                '${mahasiswa.email}\nPost ID: ${mahasiswa.postId}',
              ), // Text
              isThreeLine: true,
              trailing: IconButton(
                icon: const Icon(Icons.save, size: 18),
                tooltip: 'Simpan mahasiswa ini',
                onPressed: () async {
                  await ref
                      .read(mahasiswaNotifierProvider.notifier)
                      .saveSelectedMahasiswa(mahasiswa);
                  ref.invalidate(savedMahasiswaProvider);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${mahasiswa.name} berhasil disimpan ke local storage',
                        ), // Text
                      ), // SnackBar
                    );
                  }
                },
              ), // IconButton
            ), // ListTile
          ); // Card
        },
      ), // ListView.builder
    ); // RefreshIndicator
  }
}