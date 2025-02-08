import 'dart:io';
import '../interfaces/command.dart';
import '../../core/errors/exceptions.dart';

class CommandInterfaceImpl implements CommandInterface {
  
  @override
  Future<void> init() async {
    try {
      // Create necessary directories
      await _createDirectory('lib/components');
      await _createDirectory('lib/themes');
      
      // Create initial configuration file
      await _createConfigFile();
      
      // Create initial theme file
      await _createDefaultTheme();
      
      print('✓ Successfully initialized FlatCN UI');
    } catch (e) {
      throw InitializationException();
    }
  }

  Future<void> _createDirectory(String path) async {
    final directory = Directory(path);
    if (!directory.existsSync()) {
      await directory.create(recursive: true);
    }
  }

  Future<void> _createConfigFile() async {
    final file = File('flatcn.config.json');
    if (!file.existsSync()) {
      await file.writeAsString('''
{
  "style": "default",
  "tailwind": {
    "config": "tailwind.config.js",
    "css": "src/app/globals.css",
    "baseColor": "slate",
    "cssVariables": true
  },
  "aliases": {
    "components": "@/components",
    "utils": "@/lib/utils"
  }
}
''');
    }
  }

  Future<void> _createDefaultTheme() async {
    final file = File('lib/themes/default_theme.dart');
    if (!file.existsSync()) {
      await file.writeAsString('''
class DefaultTheme {
  static const Map<String, dynamic> theme = {
    'colors': {
      'primary': '#1a73e8',
      'secondary': '#5f6368',
      'background': '#ffffff',
      'text': '#202124',
    },
    'borderRadius': {
      'small': '4px',
      'medium': '8px',
      'large': '12px',
    },
    // Add more theme properties as needed
  };
}
''');
    }
  }
}
