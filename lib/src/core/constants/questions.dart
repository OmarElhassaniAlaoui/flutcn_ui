import 'package:flutcn_ui/src/core/utils/highlighter.dart';

class Questions {
  Questions._();

  static final Map<String, String> initCommandQuestions = {
    'theme_path':
        'Which path do you choose for setup ${"theme".highlight('\x1B[36m')} ?',
    'widgets_path':
        'Which path do you choose for ${"widgets".highlight('\x1B[36m')} ?',
  };

  static final Map<String, Map<String, dynamic>> initCommandListQuestions = {
    'style': {
      "question": 'Which ${"style".highlight('\x1B[36m')} do you want to use?',
      "options": [
        "new-york",
        "default",
      ]
    },
    'base_color': {
      "question": "Which ${"color".highlight('\x1B[36m')} do you want to use?",
      "options": [
        "Zinc",
        "Slate",
        "Gray",
      ]
    },
    'state_management': {
      "question":
          "Which ${"state managment".highlight('\x1B[36m')} do you want to use?",
      "options": [
        "Bloc",
        "Provider",
        "Riverpod",
      ]
    },
  };
}
