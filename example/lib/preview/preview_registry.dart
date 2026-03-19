import 'package:flutter/material.dart';
import 'previews/button_preview.dart';
import 'previews/avatar_preview.dart';
import 'previews/badge_preview.dart';
import 'previews/input_preview.dart';
import 'previews/card_preview.dart';

final Map<String, Widget Function()> previewRegistry = {
  'button': () => const ButtonPreview(),
  'avatar': () => const AvatarPreview(),
  'badge': () => const BadgePreview(),
  'input': () => const InputPreview(),
  'card': () => const CardPreview(),
};
