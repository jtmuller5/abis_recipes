import 'package:abis_recipes/app/constants.dart';
import 'package:abis_recipes/features/books/models/book.dart';
import 'package:abis_recipes/features/books/models/recipe.dart';
import 'package:abis_recipes/features/books/providers/books_provider.dart';
import 'package:abis_recipes/features/books/ui/book_page/book_page.dart';
import 'package:abis_recipes/main.dart';
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';

class BooksPage extends HookConsumerWidget {
  const BooksPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController bookTitleController = useTextEditingController();
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text('My Recipe Books'),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                Book book = ref.watch(booksProvider)[index];
                return ListTile(
                  leading: Hero(
                  tag: 'recipe-${isar.recipes.filter().bookIdsElementEqualTo(book.id).findFirstSync()?.id ?? book.title}',
                    child: SizedBox(
                        height: 64,
                        width: 64,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: isar.recipes.filter().bookIdsElementEqualTo(book.id).findFirstSync()?.images?.firstOrNull != null
                              ? Image.network(
                                isar.recipes.filter().bookIdsElementEqualTo(book.id).findFirstSync()?.images?.first ?? '',
                                fit: BoxFit.cover,
                              )
                              : ColoredBox(color: Theme.of(context).colorScheme.secondary, child: Icon(Icons.book)),
                        )),
                  ),
                  title: Text(book.title),
                  subtitle: Text('${isar.recipes.filter().bookIdsElementEqualTo(book.id).findAllSync().length} recipes'),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => BookPage(bookId: book.id)));
                  },
                );
              },
              childCount: (ref.watch(booksProvider) ?? []).length,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return DecoratedBox(
                decoration: const BoxDecoration(borderRadius: BorderRadius.vertical(top: Radius.circular(8))),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          'New Recipe Book',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: bookTitleController,
                          decoration: InputDecoration(hintText: 'Name'),
                        ),
                      ),
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Cancel')),
                                gap16,
                                OutlinedButton(
                                    onPressed: () async {
                                      ref.read(booksProvider.notifier).addBook(Book(
                                            title: bookTitleController.text,
                                            dateCreated: DateTime.now(),
                                            description: null,
                                            url: null,
                                          ));

                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Save'))
                              ],
                            ),
                          )
                        ],
                      ))
                    ],
                  ),
                ),
              );
            },
          );
        },
        label: Text('New'),
        icon: Icon(Icons.add),
      ),
    );
  }
}
