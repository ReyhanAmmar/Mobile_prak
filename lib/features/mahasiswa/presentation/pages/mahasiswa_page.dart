import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_dua/core/widgets/common_widgets.dart';
import 'package:mobile_dua/features/mahasiswa/presentation/providers/mahasiswa_provider.dart';
import 'package:mobile_dua/features/mahasiswa/presentation/widgets/mahasiswa_widget.dart';

class MahasiswaPage extends ConsumerWidget {
  const MahasiswaPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mahasiswaState = ref.watch(mahasiswaNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Total Mahasiswa'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => ref.invalidate(mahasiswaNotifierProvider),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: mahasiswaState.when(
        loading: () => const LoadingWidget(),
        error: (error, stack) => CustomErrorWidget(
          message: 'Gagal memuat data mahasiswa: ${error.toString()}',
          onRetry: () => ref.read(mahasiswaNotifierProvider.notifier).refresh(),
        ),
        data: (mahasiswaList) {
          return MahasiswaListView(
            mahasiswaList: mahasiswaList,
            onRefresh: () => ref.invalidate(mahasiswaNotifierProvider),
          );
        },
      ),
    );
  }
}