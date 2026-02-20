import 'package:flutter/material.dart';
import '../../widgets/avatar.dart';

class AvatarPreview extends StatelessWidget {
  const AvatarPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SubsectionTitle(title: 'Sizes'),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Column(
              children: [
                FlutAvatar(
                  size: AvatarSize.sm,
                  fallbackText: 'U',
                ),
                const SizedBox(height: 8),
                Text('Small', style: TextStyle(fontSize: 12)),
              ],
            ),
            Column(
              children: [
                FlutAvatar(
                  size: AvatarSize.md,
                  fallbackText: 'U',
                ),
                const SizedBox(height: 8),
                Text('Medium', style: TextStyle(fontSize: 12)),
              ],
            ),
            Column(
              children: [
                FlutAvatar(
                  size: AvatarSize.lg,
                  fallbackText: 'U',
                ),
                const SizedBox(height: 8),
                Text('Large', style: TextStyle(fontSize: 12)),
              ],
            ),
            Column(
              children: [
                FlutAvatar(
                  size: AvatarSize.xl,
                  fallbackText: 'U',
                ),
                const SizedBox(height: 8),
                Text('XL', style: TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 32),
        _SubsectionTitle(title: 'Shapes'),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            Column(
              children: [
                FlutAvatar(
                  size: AvatarSize.lg,
                  fallbackText: 'AB',
                  shape: BoxShape.circle,
                ),
                const SizedBox(height: 8),
                Text('Circle', style: TextStyle(fontSize: 12)),
              ],
            ),
            Column(
              children: [
                FlutAvatar(
                  size: AvatarSize.lg,
                  fallbackText: 'AB',
                  shape: BoxShape.rectangle,
                ),
                const SizedBox(height: 8),
                Text('Square', style: TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 32),
        _SubsectionTitle(title: 'Custom Colors'),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            FlutAvatar(
              size: AvatarSize.lg,
              fallbackText: 'OM',
              backgroundColor: Colors.blue,
              textColor: Colors.white,
            ),
            FlutAvatar(
              size: AvatarSize.lg,
              fallbackText: 'JD',
              backgroundColor: Colors.green,
              textColor: Colors.white,
            ),
            FlutAvatar(
              size: AvatarSize.lg,
              fallbackText: 'SK',
              backgroundColor: Colors.purple,
              textColor: Colors.white,
            ),
            FlutAvatar(
              size: AvatarSize.lg,
              fallbackText: 'AL',
              backgroundColor: Colors.orange,
              textColor: Colors.white,
            ),
          ],
        ),
        const SizedBox(height: 32),
        _SubsectionTitle(title: 'With Borders'),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            FlutAvatar(
              size: AvatarSize.lg,
              fallbackText: 'U',
              borderWidth: 2,
              borderColor: Colors.blue,
            ),
            FlutAvatar(
              size: AvatarSize.lg,
              fallbackText: 'U',
              borderWidth: 3,
              borderColor: Colors.red,
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
