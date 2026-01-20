import 'package:flutter/material.dart';
import 'package:otzaria/bookmarks/bookmark_screen.dart';
import 'package:otzaria/widgets/reusable_items_dialog.dart';

class BookmarksDialog extends StatelessWidget {
  const BookmarksDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return ReusableItemsDialog(
      title: AppLocalizations.of(context)?.t('auto.836') ?? 'סימניות',
      child: const BookmarkView(),
    );
  }
}
