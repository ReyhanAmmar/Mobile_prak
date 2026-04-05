import 'package:mobile_dua/features/dashboard/data/models/dashboard_model.dart';

class DashboardRepository {
  /// Mendapatkan data dashboard
  Future<DashboardData> getDashboardData() async {
    // network delay
    await Future.delayed(const Duration(seconds: 1));

    // Data dummy
    return DashboardData(
      userName: 'Admin D4TI',
      lastUpdate: DateTime.now(),
      stats: [
        DashboardStats(
          title: 'Total Mahasiswa',
          value: '1,200',
          subtitle: '',
        ),
        DashboardStats(
          title: 'Mahasiswa Aktif',
          value: '550',
          subtitle: '',
        ),
        DashboardStats(
          title: 'Dosen',
          value: '650',
          subtitle: '',
        ),
        DashboardStats(
          title: 'Profile',
          value: '',
          subtitle: '',
        ),
      ],
    );
  }

  /// Refresh dashboard data
  Future<DashboardData> refreshDashboard() async {
    return getDashboardData();
  }

  /// Get specific stat by title
  Future<DashboardStats?> getStatByTitle(String title) async {
    final data = await getDashboardData();
    try {
      return data.stats.firstWhere((stat) => stat.title == title);
    } catch (e) {
      return null;
    }
  }
}