import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:otzaria/settings/settings_repository.dart';
import 'package:updat/updat.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// רכיב לחיצה (chip) בעברית - דומה ל-flatChip המקורי
Widget hebrewFlatChip({
  required BuildContext context,
  required String? latestVersion,
  required String appVersion,
  required UpdatStatus status,
  required void Function() checkForUpdate,
  required void Function() openDialog,
  required void Function() startUpdate,
  required Future<void> Function() launchInstaller,
  required void Function() dismissUpdate,
}) {
  if (UpdatStatus.available == status ||
      UpdatStatus.availableWithChangelog == status) {
    // בדוק אם הדיאלוג כבר הוצג לגרסה זו
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final prefs = await SharedPreferences.getInstance();
      final shownKey = 'update_dialog_shown_$latestVersion';
      final alreadyShown = prefs.getBool(shownKey) ?? false;

      if (!alreadyShown && context.mounted) {
        // סמן שהדיאלוג הוצג לגרסה זו
        await prefs.setBool(shownKey, true);
        openDialog();
      }
    });
    return Tooltip(
      message: 'עדכון לגרסה ${latestVersion!.toString()}',
      child: TextButton.icon(
        onPressed: openDialog,
        icon: const Icon(FluentIcons.arrow_download_24_regular),
        label: const Text(AppLocalizations.of(context)?.t('auto.729') ?? 'עדכון זמין'),
      ),
    );
  }

  if (UpdatStatus.downloading == status) {
    return Tooltip(
      message: AppLocalizations.of(context)?.t('auto.728') ?? 'אנא המתן...',
      child: TextButton.icon(
        onPressed: () {},
        icon: const SizedBox(
          width: 15,
          height: 15,
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
        label: const Text(AppLocalizations.of(context)?.t('auto.727') ?? 'מוריד...'),
      ),
    );
  }

  if (UpdatStatus.readyToInstall == status) {
    return Tooltip(
      message: AppLocalizations.of(context)?.t('auto.726') ?? 'לחץ להתקנה',
      child: TextButton.icon(
        onPressed: launchInstaller,
        icon: const Icon(FluentIcons.checkmark_circle_24_regular),
        label: const Text(AppLocalizations.of(context)?.t('auto.725') ?? 'מוכן להתקנה'),
      ),
    );
  }

  if (UpdatStatus.error == status) {
    // לא להציג הודעת שגיאה במצב אופליין
    final isOfflineMode =
        Settings.getValue<bool>(SettingsRepository.keyOfflineMode) ?? false;
    if (isOfflineMode) {
      return Container();
    }
    return Tooltip(
      message: AppLocalizations.of(context)?.t('auto.724') ?? 'אירעה שגיאה בעדכון. אנא נסה שוב.',
      child: TextButton.icon(
        onPressed: startUpdate,
        icon: const Icon(FluentIcons.warning_24_regular),
        label: const Text(AppLocalizations.of(context)?.t('auto.723') ?? 'שגיאה בחיבור לרשת במהלך בדיקת עדכונים'),
      ),
    );
  }

  return Container();
}

/// רכיב לחיצה מורחב בעברית עם הורדה שקטה - דומה ל-floatingExtendedChipWithSilentDownload
Widget hebrewFloatingExtendedChipWithSilentDownload({
  required BuildContext context,
  required String? latestVersion,
  required String appVersion,
  required UpdatStatus status,
  required void Function() checkForUpdate,
  required void Function() openDialog,
  required void Function() startUpdate,
  required Future<void> Function() launchInstaller,
  required void Function() dismissUpdate,
}) {
  if (UpdatStatus.available == status ||
      UpdatStatus.availableWithChangelog == status) {
    startUpdate();
  }

  if (UpdatStatus.downloading == status) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)?.t('auto.722') ?? 'מוריד עדכון...',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              "מוריד גרסה ${latestVersion.toString()}",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 15),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 10),
                Text(AppLocalizations.of(context)?.t('auto.721') ?? 'אנא המתן...'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  if (UpdatStatus.readyToInstall == status) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)?.t('auto.720') ?? 'עדכון מוכן',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              "גרסה ${latestVersion.toString()} מוכנה להתקנה!",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)?.t('auto.719') ?? 'אתה משתמש כרגע בגרסה $appVersion.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)?.t('auto.718') ?? 'עדכן כעת כדי לקבל את התכונות והתיקונים החדשים.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: dismissUpdate,
                  child: const Text(AppLocalizations.of(context)?.t('auto.717') ?? 'מאוחר יותר'),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: startUpdate,
                  icon: const Icon(FluentIcons.desktop_arrow_down_24_regular),
                  label: const Text(AppLocalizations.of(context)?.t('auto.716') ?? 'התקן כעת'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  return Container();
}

/// דיאלוג ברירת מחדל בעברית - דומה ל-defaultDialog
void hebrewDefaultDialog({
  required BuildContext context,
  required String? latestVersion,
  required String appVersion,
  required UpdatStatus status,
  required String? changelog,
  required void Function() checkForUpdate,
  required void Function() openDialog,
  required void Function() startUpdate,
  required Future<void> Function() launchInstaller,
  required void Function() dismissUpdate,
}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      scrollable: true,
      title: Flex(
        direction:
            Theme.of(context).useMaterial3 ? Axis.vertical : Axis.horizontal,
        children: const [
          Icon(FluentIcons.arrow_sync_24_regular),
          Text(AppLocalizations.of(context)?.t('auto.715') ?? 'עדכון זמין'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(AppLocalizations.of(context)?.t('auto.714') ?? 'גרסה חדשה של האפליקציה זמינה.'),
          const SizedBox(width: 10),
          Text('גרסה חדשה: ${latestVersion!.toString()}'),
          const SizedBox(height: 10),
          if (status == UpdatStatus.availableWithChangelog) ...[
            Text(
              AppLocalizations.of(context)?.t('auto.713') ?? 'יומן שינויים:',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Markdown(data: changelog!),
            ),
          ],
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: const Text(AppLocalizations.of(context)?.t('auto.712') ?? 'מאוחר יותר'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            startUpdate();
          },
          child: const Text(AppLocalizations.of(context)?.t('auto.711') ?? 'עדכן כעת'),
        ),
      ],
    ),
  );
}

/// פונקציה שעוטפת את _flatChipAutoHideError אבל עם הרכיב העברי
Widget hebrewFlatChipAutoHideError({
  required BuildContext context,
  required String? latestVersion,
  required String appVersion,
  required UpdatStatus status,
  required void Function() checkForUpdate,
  required void Function() openDialog,
  required void Function() startUpdate,
  required Future<void> Function() launchInstaller,
  required void Function() dismissUpdate,
}) {
  if (status == UpdatStatus.error) {
    Future.delayed(const Duration(seconds: 3), dismissUpdate);
  }
  return hebrewFlatChip(
    context: context,
    latestVersion: latestVersion,
    appVersion: appVersion,
    status: status,
    checkForUpdate: checkForUpdate,
    openDialog: openDialog,
    startUpdate: startUpdate,
    launchInstaller: launchInstaller,
    dismissUpdate: dismissUpdate,
  );
}
