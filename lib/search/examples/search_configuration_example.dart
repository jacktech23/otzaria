// דוגמה לשימוש ב-SearchConfiguration החדש
// קובץ זה מראה איך להשתמש בהגדרות החיפוש המרוכזות

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otzaria/search/bloc/search_bloc.dart';
import 'package:otzaria/search/bloc/search_event.dart';
import 'package:otzaria/search/bloc/search_state.dart';
import 'package:otzaria/search/models/search_configuration.dart';

/// דוגמה לווידג'ט שמציג את הגדרות החיפוש הנוכחיות
class SearchConfigurationDisplay extends StatelessWidget {
  const SearchConfigurationDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        final config = state.configuration;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('הגדרות חיפוש נוכחיות:',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),

                // הגדרות קיימות
                Text('מרחק: ${config.distance}'),
                Text('חיפוש מטושטש: ${config.fuzzy ? AppLocalizations.of(context)?.t('auto.429') ?? 'מופעל' : AppLocalizations.of(context)?.t('auto.428') ?? 'כבוי'}'),
                Text('מספר תוצאות: ${config.numResults}'),
                Text('סדר מיון: ${config.sortBy}'),

                const Divider(),

                // הגדרות רגקס חדשות
                Text('הגדרות רגקס:',
                    style: Theme.of(context).textTheme.titleSmall),
                Text('רגקס מופעל: ${config.regexEnabled ? AppLocalizations.of(context)?.t('auto.427') ?? 'כן' : AppLocalizations.of(context)?.t('auto.426') ?? 'לא'}'),
                Text('רגיש לאותיות: ${config.caseSensitive ? AppLocalizations.of(context)?.t('auto.425') ?? 'כן' : AppLocalizations.of(context)?.t('auto.424') ?? 'לא'}'),
                Text('מרובה שורות: ${config.multiline ? AppLocalizations.of(context)?.t('auto.423') ?? 'כן' : AppLocalizations.of(context)?.t('auto.422') ?? 'לא'}'),
                Text('נקודה כוללת הכל: ${config.dotAll ? AppLocalizations.of(context)?.t('auto.421') ?? 'כן' : AppLocalizations.of(context)?.t('auto.420') ?? 'לא'}'),
                Text('יוניקוד: ${config.unicode ? AppLocalizations.of(context)?.t('auto.419') ?? 'כן' : AppLocalizations.of(context)?.t('auto.418') ?? 'לא'}'),

                if (config.regexEnabled) ...[
                  const SizedBox(height: 8),
                  Text('דגלי רגקס: ${config.regexFlags}'),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

/// דוגמה לווידג'ט שמאפשר לשנות הגדרות רגקס
class RegexSettingsPanel extends StatelessWidget {
  const RegexSettingsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        final config = state.configuration;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppLocalizations.of(context)?.t('auto.417') ?? 'הגדרות רגקס:',
                    style: Theme.of(context).textTheme.titleMedium),
                SwitchListTile(
                  title: const Text(AppLocalizations.of(context)?.t('auto.416') ?? 'הפעל חיפוש רגקס'),
                  value: config.regexEnabled,
                  onChanged: (_) =>
                      context.read<SearchBloc>().add(ToggleRegex()),
                ),
                if (config.regexEnabled) ...[
                  SwitchListTile(
                    title: const Text(AppLocalizations.of(context)?.t('auto.415') ?? 'רגיש לאותיות גדולות/קטנות'),
                    subtitle: const Text(AppLocalizations.of(context)?.t('auto.414') ?? 'אם כבוי, A ו-a נחשבים זהים'),
                    value: config.caseSensitive,
                    onChanged: (_) =>
                        context.read<SearchBloc>().add(ToggleCaseSensitive()),
                  ),
                  SwitchListTile(
                    title: const Text(AppLocalizations.of(context)?.t('auto.413') ?? 'מצב מרובה שורות'),
                    subtitle: const Text(AppLocalizations.of(context)?.t('auto.412') ?? '^ ו-\$ מתייחסים לתחילת/סוף שורה'),
                    value: config.multiline,
                    onChanged: (_) =>
                        context.read<SearchBloc>().add(ToggleMultiline()),
                  ),
                  SwitchListTile(
                    title: const Text(AppLocalizations.of(context)?.t('auto.411') ?? 'נקודה כוללת הכל'),
                    subtitle: const Text(AppLocalizations.of(context)?.t('auto.410') ?? '. כולל גם תווי שורה חדשה'),
                    value: config.dotAll,
                    onChanged: (_) =>
                        context.read<SearchBloc>().add(ToggleDotAll()),
                  ),
                  SwitchListTile(
                    title: const Text(AppLocalizations.of(context)?.t('auto.409') ?? 'תמיכה ביוניקוד'),
                    subtitle: const Text(AppLocalizations.of(context)?.t('auto.408') ?? 'תמיכה מלאה בתווי יוניקוד'),
                    value: config.unicode,
                    onChanged: (_) =>
                        context.read<SearchBloc>().add(ToggleUnicode()),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

/// דוגמה ליצירת הגדרות מותאמות אישית
class CustomSearchConfiguration {
  /// יוצר הגדרות לחיפוש רגקס בסיסי
  static SearchConfiguration basicRegex() {
    return const SearchConfiguration(
      regexEnabled: true,
      caseSensitive: false,
      multiline: false,
      dotAll: false,
      unicode: true,
    );
  }

  /// יוצר הגדרות לחיפוש רגקס מתקדם
  static SearchConfiguration advancedRegex() {
    return const SearchConfiguration(
      regexEnabled: true,
      caseSensitive: true,
      multiline: true,
      dotAll: true,
      unicode: true,
      distance: 1,
      searchMode: SearchMode.exact,
      numResults: 50,
    );
  }

  /// יוצר הגדרות לחיפוש מטושטש
  static SearchConfiguration fuzzySearch() {
    return const SearchConfiguration(
      regexEnabled: false,
      searchMode: SearchMode.fuzzy,
      distance: 3,
      numResults: 200,
    );
  }
}

/// דוגמה לשמירה וטעינה של הגדרות
class SearchConfigurationManager {
  /// שמירת הגדרות (דוגמה - צריך להתאים לשיטת השמירה בפרויקט)
  static Future<void> saveConfiguration(SearchConfiguration config) async {
    // כאן תהיה השמירה ב-SharedPreferences או במקום אחר
    final configMap = config.toMap();
    debugPrint('שמירת הגדרות: $configMap');
  }

  /// טעינת הגדרות (דוגמה - צריך להתאים לשיטת הטעינה בפרויקט)
  static Future<SearchConfiguration> loadConfiguration() async {
    // כאן תהיה הטעינה מ-SharedPreferences או ממקום אחר
    // לעת עתה מחזיר הגדרות ברירת מחדל
    return const SearchConfiguration();
  }
}