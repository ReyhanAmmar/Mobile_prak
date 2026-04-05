class ProfileModel {
  final String nama;
  final String nip;
  final String email;
  final String jabatan;
  final String unitKerja;
  final String noTelp;

  ProfileModel({
    required this.nama,
    required this.nip,
    required this.email,
    required this.jabatan,
    required this.unitKerja,
    required this.noTelp,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      nama: json['nama'] ?? '',
      nip: json['nip'] ?? '',
      email: json['email'] ?? '',
      jabatan: json['jabatan'] ?? '',
      unitKerja: json['unitKerja'] ?? '',
      noTelp: json['noTelp'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'nip': nip,
      'email': email,
      'jabatan': jabatan,
      'unitKerja': unitKerja,
      'noTelp': noTelp,
    };
  }
}