import 'dart:io';
import 'dart:convert';

bool containsHebrew(String s) {
  return s.runes.any((r) => r >= 0x0590 && r <= 0x05FF);
}

bool isLikelyUiString(String content, String context) {
  // Skip if too long or has newlines
  if (content.length > 100 || content.contains('\n')) return false;
  
  // Skip if contains code-like patterns
  if (content.contains('import ') || 
      content.contains('class ') || 
      content.contains('extends ') ||
      content.contains('final ') ||
      content.contains('const ') ||
      content.contains('var ') ||
      content.contains('=>') ||
      content.contains('?.') ||
      content.contains('??') ||
      content.contains('(') && content.contains(')') && content.contains('{') ||
      content.startsWith('assets/') ||
      content.contains('Path: ') ||
      content.contains('Error: ') ||
      content.contains('Exception: ') ||
      content.contains('Future<') ||
      content.contains('List<') ||
      content.contains('Map<') ||
      content.contains('Set<')) {
    return false;
  }
  
  // Must be near UI-related code
  final uiKeywords = [
    'Text(', 'title:', 'label:', 'hintText', 'tooltip', 'dialogTitle', 
    'subtitle:', 'caption:', 'labelText', 'child: Text', 'BottomNavigationBarItem', 
    'NavigationRailDestination', 'AppBar(', 'title:', 'subtitle:', 'body:', 
    'child:', 'children:', 'ListTile(', 'leading:', 'trailing:', 'icon:', 
    'IconButton(', 'FloatingActionButton(', 'ElevatedButton(', 'TextButton(',
    'OutlinedButton(', 'SimpleSettingsTile(', 'SwitchSettingsTile(', 
    'ColorPickerSettingsTile(', 'DropdownButton(', 'PopupMenuItem(',
    'AlertDialog(', 'showDialog(', 'SnackBar(', 'Tooltip('
  ];
  
  return uiKeywords.any((k) => context.contains(k));
}

void main() {
  final libDir = Directory('lib');
  if (!libDir.existsSync()) {
    print('lib directory not found');
    exit(1);
  }

  final Map<String, String> mapping = {};
  int keyCounter = 1;

  for (final file in libDir
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'))) {
    final text = file.readAsStringSync();
    var newText = text;

    // Find all string literals with better regex
    final stringRegex = RegExp(r'''(["'])([^"']*)\1''');
    final matches = stringRegex.allMatches(text).toList();
    if (matches.isEmpty) continue;

    // Only replace Hebrew strings that look like UI strings
    for (final m in matches.reversed) {
      final literal = m.group(0)!;
      final content = m.group(2)!;
      if (!containsHebrew(content)) continue;

      // Check context around the string
      final start = (m.start - 100).clamp(0, text.length);
      final end = (m.end + 100).clamp(0, text.length);
      final context = text.substring(start, end);
      
      if (!isLikelyUiString(content, context)) continue;

      final key = 'auto.$keyCounter';
      keyCounter++;
      mapping[key] = content;

      final replacement = "AppLocalizations.of(context)?.t('$key') ?? '$content'";

      newText = newText.replaceRange(m.start, m.end, replacement);
    }

    if (newText != text) {
      file.writeAsStringSync(newText);
      print('Updated ${file.path}');
    }
  }

  if (mapping.isNotEmpty) {
    final assetsDir = Directory('assets/lang');
    if (!assetsDir.existsSync()) assetsDir.createSync(recursive: true);
    final outFile = File('assets/lang/auto_en.json');
    outFile.writeAsStringSync(JsonEncoder.withIndent('  ').convert(mapping));
    print('Wrote ${outFile.path} with ${mapping.length} entries');
  } else {
    print('No UI Hebrew strings found for replacement');
  }
}