import 'package:flutter/material.dart';
import 'widgets/button.dart';
import 'widgets/avatar.dart';
import 'widgets/theme_toggle_button.dart';

/// Component Showcase Page
/// Displays all Flutcn UI widgets with their variants and configurations
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Page Header
              _PageHeader(),
              const SizedBox(height: 40),

              // Button Section
              _ButtonSection(),
              const SizedBox(height: 40),

              // Avatar Section
              _AvatarSection(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

/// Page header with title
class _PageHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Component Showcase',
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Flutcn UI - shadcn/ui inspired components for Flutter',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            const ThemeToggleButton(),
          ],
        ),
      ],
    );
  }
}

/// Button showcase section
class _ButtonSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(title: 'Button', subtitle: 'button'),
        const SizedBox(height: 16),
        _ShowcaseCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Default size buttons
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

              // Sizes
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

              // States
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
          ),
        ),
      ],
    );
  }
}

/// Avatar showcase section
class _AvatarSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(title: 'Avatar', subtitle: 'avatar'),
        const SizedBox(height: 16),
        _ShowcaseCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sizes with fallback text
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

              // Shapes
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

              // Custom colors
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

              // With borders
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
          ),
        ),
      ],
    );
  }
}

/// Section title with main title and subtitle
class _SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionTitle({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          title,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          subtitle,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

/// Subsection title for grouping within sections
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

/// Card wrapper for showcase sections
class _ShowcaseCard extends StatelessWidget {
  final Widget child;

  const _ShowcaseCard({required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: child,
    );
  }
}
