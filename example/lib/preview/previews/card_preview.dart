import 'package:flutter/material.dart';
import '../../widgets/card.dart';
import '../../widgets/button.dart';
import '../../widgets/input.dart';

class CardPreview extends StatelessWidget {
  const CardPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
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
        _SubsectionTitle(title: 'Custom (decorationOverride)'),
        const SizedBox(height: 16),
        FlutCard(
          decorationOverride: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
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
