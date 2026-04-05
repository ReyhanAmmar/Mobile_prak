import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_dua/core/constants/app_constants.dart';
import 'package:mobile_dua/core/theme/app_theme.dart';
import 'package:mobile_dua/features/dashboard/data/models/dashboard_model.dart';

class StatCard extends StatelessWidget {
  final DashboardStats stats;
  final bool isSelected;
  final VoidCallback? onTap;

  const StatCard({
    super.key,
    required this.stats,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 8 : 2,
      color: isSelected
          ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
          : null,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                stats.title,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                stats.value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardHeader extends ConsumerWidget {
  final String userName;

  const DashboardHeader({super.key, required this.userName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(AppConstants.radiusLarge),
          bottomRight: Radius.circular(AppConstants.radiusLarge),
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selamat Datang,',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      userName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            Text(
              'Data Mahasiswa D4TI',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Modern Stat Card with Gradient and Glass Morphism
class ModernStatCard extends StatefulWidget {
  final DashboardStats stats;
  final IconData icon;
  final List<Color> gradientColors;
  final bool isSelected;
  final VoidCallback? onTap;

  const ModernStatCard({
    super.key,
    required this.stats,
    required this.icon,
    required this.gradientColors,
    this.isSelected = false,
    this.onTap,
  });

  @override
  State<ModernStatCard> createState() => _ModernStatCardState();
}

class _ModernStatCardState extends State<ModernStatCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    ); // AnimationController
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        _controller.forward();
      },
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap?.call();
      },
      onTapCancel: () {
        _controller.reverse();
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: widget.gradientColors,
            ), // LinearGradient
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: widget.gradientColors[0].withValues(alpha: 0.3),
                blurRadius: widget.isSelected ? 20 : 12,
                offset: Offset(0, widget.isSelected ? 8 : 4),
              ),
            ],
          ), // BoxDecoration
          child: Stack(
            children: [
              // Background decoration circles
              Positioned(
                right: -20,
                top: -20,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.1),
                  ), // BoxDecoration
                ), // Container
              ), // Positioned
              Positioned(
                left: -10,
                bottom: -10,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.1),
                  ), // BoxDecoration
                ), // Container
              ), // Positioned

              // Content
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ), // BoxDecoration
                      child: Icon(widget.icon,
                          color: Colors.white, size: 24), // Icon
                    ), // Container
                    const Spacer(),

                    // Value
                    Text(
                      widget.stats.value,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ), // Text
                    const SizedBox(height: 4),

                    // Title
                    Text(
                      widget.stats.title,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: 0.9),
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ), // Text
                  ],
                ), // Column
              ), // Padding
            ],
          ), // Stack
        ), // Container
      ), // ScaleTransition
    ); // GestureDetector
  }
}
