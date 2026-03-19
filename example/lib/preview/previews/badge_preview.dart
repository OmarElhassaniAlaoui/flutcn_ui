import 'package:flutter/material.dart' hide Badge;
import '../../widgets/badge.dart';

class BadgePreview extends StatelessWidget {
  const BadgePreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SubsectionTitle(title: 'Variants'),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            FlutBadge(
              text: 'Primary',
              variant: BadgeVariant.primary,
            ),
            FlutBadge(
              text: 'Secondary',
              variant: BadgeVariant.secondary,
            ),
            FlutBadge(
              text: 'Destructive',
              variant: BadgeVariant.destructive,
            ),
            FlutBadge(
              text: 'Outline',
              variant: BadgeVariant.outline,
            ),
          ],
        ),
        const SizedBox(height: 32),
        _SubsectionTitle(title: 'With Icons'),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            FlutBadge(
              text: 'New',
              icon: Icons.star,
              variant: BadgeVariant.primary,
            ),
            FlutBadge(
              text: 'Info',
              icon: Icons.info_outline,
              variant: BadgeVariant.secondary,
            ),
            FlutBadge(
              text: 'Error',
              icon: Icons.error_outline,
              variant: BadgeVariant.destructive,
            ),
            FlutBadge(
              text: 'Tag',
              icon: Icons.label_outline,
              variant: BadgeVariant.outline,
            ),
          ],
        ),
        const SizedBox(height: 32),
        _SubsectionTitle(title: 'Helper Class'),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            Badge.primary(text: 'Badge'),
            Badge.secondary(text: 'Badge'),
            Badge.destructive(text: 'Badge'),
            Badge.outline(text: 'Badge'),
          ],
        ),
        const SizedBox(height: 32),
        _SubsectionTitle(title: 'Custom'),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            Badge.custom(
              text: 'Success',
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            Badge.custom(
              text: 'Warning',
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            Badge.custom(
              text: 'Info',
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            Badge.custom(
              text: 'Bordered',
              borderColor: Colors.purple,
              foregroundColor: Colors.purple,
              borderWidth: 1.5,
              borderRadius: 6,
            ),
          ],
        ),
      ],
    );
  }
}

class _SubsectionTitle extends StatelessWidget {
  final String title;

  const _SubsectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
      ),
    );
  }
}
