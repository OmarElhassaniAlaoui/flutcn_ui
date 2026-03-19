import 'package:flutter/material.dart' hide Badge;
import 'widgets/button.dart';
import 'widgets/avatar.dart';
import 'widgets/badge.dart';
import 'widgets/input.dart';
import 'widgets/card.dart';
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

              // Badge Section
              _BadgeSection(),
              const SizedBox(height: 40),

              // Input Section
              _InputSection(),
              const SizedBox(height: 40),

              // Card Section
              _CardSection(),
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

/// Badge showcase section
class _BadgeSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(title: 'Badge', subtitle: 'badge'),
        const SizedBox(height: 16),
        _ShowcaseCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Variants
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

              // With Icons
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

              // Helper Class
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

              // Custom
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
          ),
        ),
      ],
    );
  }
}

/// Input showcase section
class _InputSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(title: 'Input', subtitle: 'input'),
        const SizedBox(height: 16),
        _ShowcaseCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SubsectionTitle(title: 'Default'),
              const SizedBox(height: 16),
              const FlutInput(hintText: 'Enter text...'),

              const SizedBox(height: 32),

              _SubsectionTitle(title: 'With Label'),
              const SizedBox(height: 16),
              const FlutInput(
                label: 'Email',
                hintText: 'you@example.com',
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 32),

              _SubsectionTitle(title: 'With Icons'),
              const SizedBox(height: 16),
              const FlutInput(
                hintText: 'Enter email',
                prefixIcon: Icons.mail_outline,
              ),
              const SizedBox(height: 12),
              const FlutInput(
                hintText: 'Password',
                obscureText: true,
                prefixIcon: Icons.lock_outline,
                suffixIcon: Icons.visibility_off_outlined,
              ),

              const SizedBox(height: 32),

              _SubsectionTitle(title: 'Search'),
              const SizedBox(height: 16),
              const FlutInput.search(),

              const SizedBox(height: 32),

              _SubsectionTitle(title: 'States'),
              const SizedBox(height: 16),
              const FlutInput(
                label: 'Username',
                hintText: 'Enter username',
                errorText: 'Username is already taken.',
              ),
              const SizedBox(height: 12),
              const FlutInput(
                hintText: 'Not available',
                enabled: false,
              ),

              const SizedBox(height: 32),

              _SubsectionTitle(title: 'Textarea'),
              const SizedBox(height: 16),
              const FlutInput(
                hintText: 'Write a message...',
                maxLines: 4,
                minLines: 3,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Card showcase section
class _CardSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(title: 'Card', subtitle: 'card'),
        const SizedBox(height: 16),
        _ShowcaseCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _SubsectionTitle(title: 'Simple Card'),
              const SizedBox(height: 16),
              FlutCard(
                child: FlutCardContent(
                  child: Text(
                    'A minimal card with just content padding.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              _SubsectionTitle(title: 'With Header'),
              const SizedBox(height: 16),
              FlutCard(
                child: Column(
                  children: [
                    const FlutCardHeader(
                      children: [
                        FlutCardTitle(text: 'Card Title'),
                        FlutCardDescription(
                            text: 'A short description of the card.'),
                      ],
                    ),
                    FlutCardContent(
                      child: Text(
                        'This is the main content area.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              _SubsectionTitle(title: 'With Header, Content & Footer'),
              const SizedBox(height: 16),
              FlutCard(
                child: Column(
                  children: [
                    const FlutCardHeader(
                      children: [
                        FlutCardTitle(text: 'Create project'),
                        FlutCardDescription(
                            text: 'Deploy your new project in one-click.'),
                      ],
                    ),
                    const FlutCardContent(
                      child: FlutInput(
                        label: 'Project name',
                        hintText: 'my-awesome-app',
                      ),
                    ),
                    FlutCardFooter(
                      children: [
                        FlutButton(
                          text: 'Cancel',
                          variant: ButtonVariant.outline,
                          onPressed: () {},
                        ),
                        FlutButton(
                          text: 'Deploy',
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              _SubsectionTitle(title: 'Tappable Card'),
              const SizedBox(height: 16),
              FlutCard(
                onTap: () {},
                child: const FlutCardHeader(
                  children: [
                    FlutCardTitle(text: 'Tap me'),
                    FlutCardDescription(
                        text: 'This card is interactive — try tapping it.'),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              _SubsectionTitle(title: 'Custom Decoration'),
              const SizedBox(height: 16),
              FlutCard(
                decorationOverride: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const FlutCardHeader(
                  children: [
                    FlutCardTitle(
                      text: 'Gradient Card',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                    FlutCardDescription(
                      text: 'Using decorationOverride for full control.',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
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
