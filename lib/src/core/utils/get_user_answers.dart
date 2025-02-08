import 'package:flatcn_ui/src/data/models/init_config_model.dart';
import 'package:cli_dialog/cli_dialog.dart';
class GetUserAnswers {
  GetUserAnswers._();

  static Future<InitConfigModel> getUserInput() async {
    final dialog = CLI_Dialog(questions: [
      [
        'Theme path',
        'lib/themes',
        'text',
        false // not required, will use default if empty
      ],
      [
        'Widgets path',
        'lib/widgets',
        'text',
        false
      ],
    ]);

    final answers = dialog.ask();

    // Style selection
    final styleDialog = CLI_Dialog(questions: [
      [
        'Style',
        'New York',
        'select',
        ['New York', 'Material You', 'Cupertino']
      ]
    ]);
    final styleAnswer = styleDialog.ask();

    // Color selection
    final colorDialog = CLI_Dialog(questions: [
      [
        'Base color',
        'Zinc',
        'select',
        ['Slate', 'Gray', 'Zinc', 'Neutral', 'Stone']
      ]
    ]);
    final colorAnswer = colorDialog.ask();

    // State management selection
    final stateDialog = CLI_Dialog(questions: [
      [
        'State management',
        'Bloc',
        'select',
        ['Bloc', 'Provider', 'Riverpod']
      ]
    ]);
    final stateAnswer = stateDialog.ask();

    return InitConfigModel(
      themePath: answers['Theme path'] ?? 'lib/themes',
      widgetsPath: answers['Widgets path'] ?? 'lib/widgets',
      style: styleAnswer['Style'],
      baseColor: colorAnswer['Base color'],
      stateManagement: stateAnswer['State management'],
    );
  }
} 