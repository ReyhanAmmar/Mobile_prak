import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_dua/core/widgets/common_widgets.dart';
import 'package:mobile_dua/features/profile/data/models/profile_model.dart';
import 'package:mobile_dua/features/profile/presentation/providers/profile_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileNotifierProvider);

    return Scaffold(
      body: profileState.when(
        // State: Loading
        loading: () => const LoadingWidget(),

        // State: Error
        error: (error, stack) => CustomErrorWidget(
          message: 'Gagal memuat data profile: ${error.toString()}',
          onRetry: () {
            ref.read(profileNotifierProvider.notifier).refresh();
          },
        ), // CustomErrorWidget

        // State: Data berhasil dimuat
        data: (profile) => _buildProfileContent(context, ref, profile),
      ),
    ); // Scaffold
  }

  Widget _buildProfileContent(
      BuildContext context, WidgetRef ref, ProfileModel profile) {
    return CustomScrollView(
      slivers: [
        // Header dengan gradient
        SliverToBoxAdapter(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withBlue(220),
                ],
              ), // LinearGradient
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ), // BoxDecoration
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                child: Column(
                  children: [
                    // AppBar row
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_rounded,
                              color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Expanded(
                          child: Text(
                            'Profile',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.refresh_rounded,
                              color: Colors.white),
                          onPressed: () {
                            ref.invalidate(profileNotifierProvider);
                          },
                        ),
                      ],
                    ), // Row
                    const SizedBox(height: 16),

                    // Avatar
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Colors.white.withOpacity(0.5), width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ), // BoxDecoration
                      child: const Icon(
                        Icons.person_rounded,
                        color: Colors.white,
                        size: 55,
                      ), // Icon
                    ), // Container
                    const SizedBox(height: 16),

                    // Nama
                    Text(
                      profile.nama,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ), // Text
                    const SizedBox(height: 6),

                    // Jabatan badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: Colors.white.withOpacity(0.3), width: 1),
                      ), // BoxDecoration
                      child: Text(
                        profile.jabatan,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.95),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ), // Text
                    ), // Container
                  ],
                ), // Column
              ), // Padding
            ), // SafeArea
          ), // Container
        ), // SliverToBoxAdapter

        // Info Cards
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Informasi Akun',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ), // Text
                const SizedBox(height: 16),

                // Info items
                _buildInfoCard(
                  context,
                  icon: Icons.badge_outlined,
                  label: 'NIP',
                  value: profile.nip,
                  gradient: const [Color(0xFF667eea), Color(0xFF764ba2)],
                ),
                _buildInfoCard(
                  context,
                  icon: Icons.email_outlined,
                  label: 'Email',
                  value: profile.email,
                  gradient: const [Color(0xFFf093fb), Color(0xFFf5576c)],
                ),
                _buildInfoCard(
                  context,
                  icon: Icons.work_outline_rounded,
                  label: 'Unit Kerja',
                  value: profile.unitKerja,
                  gradient: const [Color(0xFF4facfe), Color(0xFF00f2fe)],
                ),
                _buildInfoCard(
                  context,
                  icon: Icons.phone_outlined,
                  label: 'No. Telepon',
                  value: profile.noTelp,
                  gradient: const [Color(0xFF43e97b), Color(0xFF38f9d7)],
                ),

                const SizedBox(height: 24),

                // Logout Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Aksi logout (bisa dikembangkan)
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Konfirmasi'),
                          content: const Text('Apakah Anda yakin ingin keluar?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('Batal'),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(ctx),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red),
                              child: const Text('Keluar',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: const Icon(Icons.logout_rounded, color: Colors.white),
                    label: const Text(
                      'Keluar',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ), // ElevatedButton.styleFrom
                  ), // ElevatedButton.icon
                ), // SizedBox

                const SizedBox(height: 24),
              ],
            ), // Column
          ), // SliverToBoxAdapter
        ), // SliverPadding
      ],
    ); // CustomScrollView
  }

  Widget _buildInfoCard(
      BuildContext context, {
        required IconData icon,
        required String label,
        required String value,
        required List<Color> gradient,
      }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: gradient[0].withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: gradient[0].withOpacity(0.15)),
      ), // BoxDecoration
      child: Row(
        children: [
          // Icon container
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradient,
              ),
              borderRadius: BorderRadius.circular(12),
            ), // BoxDecoration
            child: Icon(icon, color: Colors.white, size: 22), // Icon
          ), // Container
          const SizedBox(width: 14),

          // Text info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w500,
                  ),
                ), // Text
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ), // Text
              ],
            ), // Column
          ), // Expanded
        ],
      ), // Row
    ); // Container
  }
}