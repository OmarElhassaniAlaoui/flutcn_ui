import 'package:flutcn_ui/src/core/utils/highlighter.dart';

class Questions {
  Questions._();

  static final Map<String, String> initCommandQuestions = {
    'theme_path':
        'Which path do you choose for setup ${"theme".highlight("theme", color: '\x1B[36m')} ?',
    'widgets_path':
        'Which path do you choose for ${"widgets".highlight("widgets", color: '\x1B[36m')} ?',
  };

  static final Map<String, Map<String, dynamic>> initCommandListQuestions = {
    'style': {
      "question":
          'Which ${"style".highlight("style", color: '\x1B[36m')} do you want to use?',
      "options": [
        "New York",
        "Default",
      ]
    },
    'base_color': {
      "question":
          "Which ${"color".highlight("color", color: '\x1B[36m')} do you want to use?",
      "options": [
        "Zinc",
        "Slate",
        "Gray",
      ]
    },
    'state_management': {
      "question":
          "Which ${"state managment".highlight("state managment", color: '\x1B[36m')} do you want to use?",
      "options": [
        "Bloc",
        "Provider",
        "Riverpod",
      ]
    },
  };
}
