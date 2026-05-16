import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_strings.dart';
import '../../../shared/widgets/service_card.dart';
import '../../../shared/widgets/search_bar.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/shimmer_loading.dart';
import '../../../shared/widgets/empty_state.dart';
import '../providers/services_provider.dart';
import '../../services/screens/sub_options_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedLocation = 'Nellore';

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ServicesProvider>().fetchServices();
    });
  }

  void _onServiceTap(String serviceId, String serviceName) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SubOptionsSheet(
        serviceId: serviceId,
        serviceName: serviceName,
      ),
    );
  }

  void _showLocationPicker() {
    final locations = [
      'Nellore',
      'Hyderabad',
      'Bangalore',
      'Chennai',
      'Mumbai',
      'Pune',
      'Delhi',
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.xl),
        ),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text('Select City', style: AppTextStyles.h3),
            const SizedBox(height: AppSpacing.lg),
            ...locations.map(
              (city) => ListTile(
                leading: Icon(
                  Icons.location_on_rounded,
                  color: city == _selectedLocation
                      ? AppColors.primary
                      : AppColors.textHint,
                  size: 22,
                ),
                title: Text(
                  city,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: city == _selectedLocation
                        ? FontWeight.w600
                        : FontWeight.w400,
                    color: city == _selectedLocation
                        ? AppColors.primary
                        : AppColors.textPrimary,
                  ),
                ),
                trailing: city == _selectedLocation
                    ? const Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.primary,
                        size: 22,
                      )
                    : null,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                onTap: () {
                  setState(() => _selectedLocation = city);
                  Navigator.pop(context);
                },
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverToBoxAdapter(child: _buildAppBar()),

            // Hero Section
            SliverToBoxAdapter(child: _buildHeroSection()),

            // Quick Actions
            SliverToBoxAdapter(child: _buildQuickActions()),

            // Services Grid
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: AppSpacing.section),
                child: SectionHeader(
                  title: AppStrings.allServices,
                  actionText: AppStrings.viewAll,
                  onAction: () {},
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: AppSpacing.lg),
            ),
            _buildServicesGrid(),

            // How It Works
            SliverToBoxAdapter(child: _buildHowItWorks()),

            // Why Choose Us
            SliverToBoxAdapter(child: _buildWhyChooseUs()),

            // Bottom spacing
            const SliverToBoxAdapter(
              child: SizedBox(height: 100),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.md,
      ),
      color: AppColors.surface,
      child: Row(
        children: [
          // Location
          GestureDetector(
            onTap: _showLocationPicker,
            child: Row(
              children: [
                const Icon(
                  Icons.location_on_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
                const SizedBox(width: AppSpacing.xs),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedLocation,
                      style: AppTextStyles.labelMedium.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Andhra Pradesh, India',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
                const SizedBox(width: AppSpacing.xs),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
              ],
            ),
          ),
          const Spacer(),

          // Notification
          _AppBarIcon(
            icon: Icons.notifications_outlined,
            onTap: () {},
            badge: true,
          ),
          const SizedBox(width: AppSpacing.md),
          _AppBarIcon(
            icon: Icons.shopping_cart_outlined,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.lg,
        AppSpacing.xl,
        AppSpacing.xxl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Book reliable\nprofessionals',
            style: AppTextStyles.h1.copyWith(
              fontSize: 28,
              height: 1.15,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'for your home',
            style: AppTextStyles.h1.copyWith(
              fontSize: 28,
              color: AppColors.primary,
              height: 1.15,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          AppSearchBar(
            onTap: () {
              Navigator.pushNamed(context, '/search');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      _QuickAction('Offers', Icons.local_offer_rounded, AppColors.accent),
      _QuickAction('Top Rated', Icons.star_rounded, const Color(0xFFEAB308)),
      _QuickAction('Near You', Icons.near_me_rounded, AppColors.info),
      _QuickAction('New', Icons.new_releases_rounded, AppColors.success),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.xxl,
        AppSpacing.xl,
        0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: actions.map((action) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.md,
                  ),
                  decoration: BoxDecoration(
                    color: action.color.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(
                      color: action.color.withOpacity(0.15),
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(action.icon, color: action.color, size: 24),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        action.label,
                        style: AppTextStyles.caption.copyWith(
                          color: action.color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildServicesGrid() {
    return Consumer<ServicesProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: ServiceGridSkeleton(),
            ),
          );
        }

        if (provider.error != null) {
          return SliverToBoxAdapter(
            child: ErrorState(
              message: provider.error!,
              onRetry: provider.fetchServices,
            ),
          );
        }

        if (provider.services.isEmpty) {
          return const SliverToBoxAdapter(
            child: EmptyState(
              icon: Icons.home_repair_service_rounded,
              title: 'No services available',
              subtitle: 'Check back later for available services.',
            ),
          );
        }

        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final service = provider.services[index];
                return ServiceCategoryCard(
                  service: service,
                  onTap: () => _onServiceTap(service.id, service.name),
                );
              },
              childCount: provider.services.length,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: AppSpacing.md,
              mainAxisSpacing: AppSpacing.md,
              childAspectRatio: 0.82,
            ),
          ),
        );
      },
    );
  }

  Widget _buildHowItWorks() {
    final steps = [
      _StepData(
        '1',
        'Choose Service',
        'Select from our wide range of home services',
        Icons.touch_app_rounded,
      ),
      _StepData(
        '2',
        'Book a Slot',
        'Pick a convenient date and time',
        Icons.calendar_month_rounded,
      ),
      _StepData(
        '3',
        'Get It Done',
        'Verified professionals at your doorstep',
        Icons.check_circle_rounded,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.section,
        AppSpacing.xl,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.howItWorks, style: AppTextStyles.h3),
          const SizedBox(height: AppSpacing.xl),
          ...steps.map(
            (step) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.lg),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.primarySurface,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      child: Icon(
                        step.icon,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            step.title,
                            style: AppTextStyles.labelMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            step.description,
                            style: AppTextStyles.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          step.number,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWhyChooseUs() {
    final reasons = [
      _ReasonData(
        'Verified Pros',
        'Background-checked & certified professionals',
        Icons.verified_user_rounded,
        AppColors.success,
      ),
      _ReasonData(
        'Upfront Pricing',
        'No hidden charges, transparent pricing',
        Icons.payments_rounded,
        AppColors.info,
      ),
      _ReasonData(
        'Satisfaction Guarantee',
        'Not happy? We\'ll make it right',
        Icons.thumb_up_rounded,
        AppColors.accent,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.section,
        AppSpacing.xl,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.whyChooseUs, style: AppTextStyles.h3),
          const SizedBox(height: AppSpacing.xl),
          ...reasons.map(
            (reason) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: reason.color.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(
                    color: reason.color.withOpacity(0.12),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(reason.icon, color: reason.color, size: 28),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            reason.title,
                            style: AppTextStyles.labelMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            reason.description,
                            style: AppTextStyles.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AppBarIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool badge;

  const _AppBarIcon({
    required this.icon,
    required this.onTap,
    this.badge = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          shape: BoxShape.circle,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(icon, size: 22, color: AppColors.textSecondary),
            if (badge)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.accent,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _QuickAction {
  final String label;
  final IconData icon;
  final Color color;
  _QuickAction(this.label, this.icon, this.color);
}

class _StepData {
  final String number;
  final String title;
  final String description;
  final IconData icon;
  _StepData(this.number, this.title, this.description, this.icon);
}

class _ReasonData {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  _ReasonData(this.title, this.description, this.icon, this.color);
}
