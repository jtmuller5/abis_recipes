import 'package:abis_recipes/features/books/models/recipe.dart';
import 'package:abis_recipes/features/books/providers/books_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BookPage extends ConsumerWidget {
  const BookPage({Key? key, required this.bookId}) : super(key: key);

  final int bookId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SliverAppBar(
          title: Text(ref.watch(bookProvider(bookId))?.title ?? 'No title'),
          actions: [
            Builder(
              builder: (context) {
                return IconButton(
                  icon: Icon(Icons.more_vert),
                  onPressed: () async {
                    Rect? rect;
                    RenderBox? overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
                    final renderObject = context.findRenderObject();
                    final translation = renderObject?.getTransformTo(null).getTranslation();
                    if (translation != null && renderObject?.paintBounds != null) {
                      final offset = Offset(translation.x, translation.y);
                      rect = renderObject!.paintBounds.shift(offset);
                    }
                    if (rect != null) {
                      var value = await showMenu<String>(
                        context: context,
                        position: RelativeRect.fromRect(
                          rect,
                          Offset.zero & overlay.size,
                        ),
                        items: [
                          const PopupMenuItem(value: 'rename', child: Text('Rename Book')),

                          const PopupMenuItem(value: 'delete', child: Text('Delete Book')),
                        ],
                      );
                      if (value != null) {
                        debugPrint(value);
                      }
                    }
                  },
                );
              }
            )
          ],
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              Recipe recipe = ref.watch(bookRecipesProvider(bookId))[index];
              return ListTile(
                title: Text(recipe.title ?? 'No title'),
              );
            },
            childCount: ref.watch(bookRecipesProvider(bookId)).length,
          ),
        ),
      ],
    ));
  }
}
