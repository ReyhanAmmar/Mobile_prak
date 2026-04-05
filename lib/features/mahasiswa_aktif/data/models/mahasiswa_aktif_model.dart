class MahasiswaAktifModel {
  final int id;
  final int userId;
  final String title;
  final String body;

  MahasiswaAktifModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  });

  factory MahasiswaAktifModel.fromJson(Map<String, dynamic> json) {
    return MahasiswaAktifModel(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      title: json['title'] ?? '',
      body: json['body'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'body': body,
    };
  }
}