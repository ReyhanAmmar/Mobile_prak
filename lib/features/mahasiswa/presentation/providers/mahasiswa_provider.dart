import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_dua/core/services/local_storage_service.dart';
import 'package:mobile_dua/features/mahasiswa/data/models/mahasiswa_model.dart';
import 'package:mobile_dua/features/mahasiswa/data/repositories/mahasiswa_repository.dart';
import 'package:mobile_dua/features/dosen/presentation/providers/dosen_provider.dart';

// Repository Provider
final mahasiswaRepositoryProvider = Provider<MahasiswaRepository>((ref) {
  return MahasiswaRepository();
});

// Key khusus untuk saved mahasiswa di SharedPreferences
const String _savedMahasiswaKey = 'saved_mahasiswa';

// Provider untuk saved mahasiswa
final savedMahasiswaProvider =
FutureProvider<List<Map<String, String>>>((ref) async {
  final storage = ref.watch(localStorageServiceProvider);
  return storage.getSavedMahasiswa();
});

// StateNotifier untuk mengelola state mahasiswa
class MahasiswaNotifier
    extends StateNotifier<AsyncValue<List<MahasiswaModel>>> {
  final MahasiswaRepository _repository;
  final LocalStorageService _storage;

  MahasiswaNotifier(this._repository, this._storage)
      : super(const AsyncValue.loading()) {
    loadMahasiswaList();
  }

  Future<void> loadMahasiswaList() async {
    state = const AsyncValue.loading();
    try {
      final data = await _repository.getMahasiswaList();
      state = AsyncValue.data(data);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> refresh() async {
    await loadMahasiswaList();
  }

  /// Simpan mahasiswa yang dipilih ke local storage
  Future<void> saveSelectedMahasiswa(MahasiswaModel mahasiswa) async {
    await _storage.addMahasiswaToSavedList(
      mahasiswaId: mahasiswa.id.toString(),
      name: mahasiswa.name,
      email: mahasiswa.email,
    );
  }

  /// Hapus mahasiswa tertentu dari list
  Future<void> removeSavedMahasiswa(String mahasiswaId) async {
    await _storage.removeSavedMahasiswa(mahasiswaId);
  }

  /// Hapus semua mahasiswa dari list
  Future<void> clearSavedMahasiswa() async {
    await _storage.clearSavedMahasiswa();
  }
}

// Mahasiswa Notifier Provider
final mahasiswaNotifierProvider = StateNotifierProvider.autoDispose<
    MahasiswaNotifier, AsyncValue<List<MahasiswaModel>>>(
      (ref) {
    final repository = ref.watch(mahasiswaRepositoryProvider);
    final storage = ref.watch(localStorageServiceProvider);
    return MahasiswaNotifier(repository, storage);
  },
);