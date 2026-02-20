import 'package:flutter/material.dart';
import '../../widgets/button.dart';

class ButtonPreview extends StatelessWidget {
  const ButtonPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SubsectionTitle(title: 'Variants'),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            FlutButton(
              text: 'Primary',
              variant: ButtonVariant.primary,
              onPressed: () {},
            ),
            FlutButton(
              text: 'Secondary',
              variant: ButtonVariant.secondary,
              onPressed: () {},
            ),
            FlutButton(
              text: 'Outline',
              variant: ButtonVariant.outline,
              onPressed: () {},
            ),
            FlutButton(
              text: 'Ghost',
              variant: ButtonVariant.ghost,
              onPressed: () {},
            ),
            FlutButton(
              text: 'Link',
              variant: ButtonVariant.link,
              onPressed: () {},
            ),
            FlutButton(
              text: 'Destructive',
              variant: ButtonVariant.destructive,
              onPressed: () {},
            ),
          ],
        ),
        const SizedBox(height: 32),
        _SubsectionTitle(title: 'Sizes'),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            FlutButton(
              text: 'Small',
              size: ButtonSize.sm,
              onPressed: () {},
            ),
            FlutButton(
              text: 'Medium',
              size: ButtonSize.md,
              onPressed: () {},
            ),
            FlutButton(
              text: 'Large',
              size: ButtonSize.lg,
              onPressed: () {},
            ),
            FlutButton(
              icon: Icons.star,
              iconOnly: true,
              size: ButtonSize.icon,
              onPressed: () {},
            ),
          ],
        ),
        const SizedBox(height: 32),
        _SubsectionTitle(title: 'States'),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            FlutButton(
              text: 'Default',
              onPressed: () {},
            ),
            FlutButton(
              text: 'With Icon',
              icon: Icons.mail,
              onPressed: () {},
            ),
            FlutButton(
              text: 'Loading',
              isLoading: true,
              onPressed: () {},
            ),
            FlutButton(
              text: 'Disabled',
              isDisabled: true,
              onPressed: () {},
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
