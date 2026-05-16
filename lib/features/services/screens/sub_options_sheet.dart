import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../helpers/image_helper.dart';
import '../../home/providers/services_provider.dart';
import 'service_details_screen.dart';

class SubOptionsSheet extends StatefulWidget {
  final String serviceId;
  final String serviceName;

  const SubOptionsSheet({
    super.key,
    required this.serviceId,
    required this.serviceName,
  });

  @override
  State<SubOptionsSheet> createState() => _SubOptionsSheetState();
}

class _SubOptionsSheetState extends State<SubOptionsSheet> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ServicesProvider>().fetchSubOptions(widget.serviceId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.xl),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          const SizedBox(height: AppSpacing.md),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.serviceName,
                    style: AppTextStyles.h3,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      size: 18,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const Divider(),

          // Content
          Flexible(
            child: Consumer<ServicesProvider>(
              builder: (context, provider, _) {
                if (provider.isSubOptionsLoading) {
                  return const Padding(
                    padding: EdgeInsets.all(AppSpacing.section),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                        strokeWidth: 2.5,
                      ),
                    ),
                  );
                }

                if (provider.currentSubOptions.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(AppSpacing.section),
                    child: Center(
                      child: Text(
                        'No options available',
                        style: AppTextStyles.bodyMedium,
                      ),
                    ),
                  );
                }

                return GridView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  itemCount: provider.currentSubOptions.length,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: AppSpacing.md,
                    mainAxisSpacing: AppSpacing.md,
                    childAspectRatio: 0.85,
                  ),
                  itemBuilder: (context, index) {
                    final option = provider.currentSubOptions[index];
                    return _SubOptionCard(
                      name: option.name,
                      imagePath: ImageHelper.getSubOptionImage(option.id),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ServiceDetailScreen(
                              serviceId: widget.serviceId,
                              subOptionId: option.id.toString(),
                              title: option.name,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SubOptionCard extends StatelessWidget {
  final String name;
  final String imagePath;
  final VoidCallback onTap;

  const _SubOptionCard({
    required this.name,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.borderLight),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: Image.asset(
                imagePath,
                height: 52,
                width: 52,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 52,
                  width: 52,
                  decoration: BoxDecoration(
                    color: AppColors.primarySurface,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: const Icon(
                    Icons.handyman_rounded,
                    color: AppColors.primary,
                    size: 28,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.labelSmall.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
