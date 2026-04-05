import 'package:mobile_dua/features/profile/data/models/profile_model.dart';

class ProfileRepository {
  /// Mendapatkan data profile admin
  Future<ProfileModel> getProfile() async {
    // Simulasi network delay
    await Future.delayed(const Duration(seconds: 1));

    // Data dummy profile
    return ProfileModel(
      nama: 'Admin D4TI',
      nip: '198501012010011001',
      email: 'admin.d4ti@example.com',
      jabatan: 'Administrator',
      unitKerja: 'D4 Teknik Informatika Vokasi',
      noTelp: '+62 812-3456-7890',
    );
  }
}