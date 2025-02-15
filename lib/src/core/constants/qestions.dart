class Questions {
  Questions._();

  static const List<List<String>> initCommandQuestions = [
    ['Which path do you choose for setup theme ?', 'theme_path'],
    ['Which path do you choose for widgets ?', 'widgets_path'],
  ];

  static const List<List<dynamic>> initCommandListQuestions = [
    [
      {
        "question": "Which style would you like to use ?",
        "options": [
          "New York",
        ]
      },
      'style'
    ],
    [
      {
        "question": "Which color would you like to use as base color?",
        "options": [
          "Zinc",
          "Slate",
          "Gray",
        ]
      },
      'base_color'
    ],
    [
      {
        "question": "Which state managment do you want to use for widgets",
        "options": [
          "Bloc",
          "Provider",
          "Riverpod",
        ]
      },
      'state_management'
    ],
  ];
}
