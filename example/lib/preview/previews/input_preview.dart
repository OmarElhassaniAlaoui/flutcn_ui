import 'package:flutter/material.dart';
import '../../widgets/input.dart';

class InputPreview extends StatelessWidget {
  const InputPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
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
        _SubsectionTitle(title: 'Error State'),
        const SizedBox(height: 16),
        const FlutInput(
          label: 'Username',
          hintText: 'Enter username',
          errorText: 'Username is already taken.',
        ),
        const SizedBox(height: 32),
        _SubsectionTitle(title: 'Disabled'),
        const SizedBox(height: 16),
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
        const SizedBox(height: 32),
        _SubsectionTitle(title: 'Custom (decorationOverride)'),
        const SizedBox(height: 16),
        FlutInput(
          hintText: 'Custom style',
          decorationOverride: InputDecoration(
            filled: true,
            fillColor: Colors.blue.shade50,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: const BorderSide(color: Colors.blue),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: const BorderSide(color: Colors.blue, width: 2),
            ),
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
