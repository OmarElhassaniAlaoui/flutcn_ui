class Questions {
  Questions._();

  static const Map<String, String> initCommandQuestions = {
    'theme_path': 'Which path do you choose for setup theme ?',
    'widgets_path': 'Which path do you choose for widgets ?',
  };

  static const Map<String, Map<String, dynamic>> initCommandListQuestions = {
    'style': {
      "question": "Which style would you like to use ?",
      "options": [
        "New York",
      ]
    },
    'base_color': {
      "question": "Which color would you like to use as base color?",
      "options": [
        "Zinc",
        "Slate",
        "Gray",
      ]
    },
    'state_management': {
      "question": "Which state managment do you want to use for widgets",
      "options": [
        "Bloc",
        "Provider",
        "Riverpod",
      ]
    },
  };
}
