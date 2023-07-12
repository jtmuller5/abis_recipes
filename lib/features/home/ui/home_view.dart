import 'dart:ffi';

import 'package:abis_recipes/app/constants.dart';
import 'package:abis_recipes/features/books/ui/books_page/books_page.dart';
import 'package:abis_recipes/features/books/ui/recipe_page/recipe_page.dart';
import 'package:abis_recipes/features/books/ui/search/ui/search_view.dart';
import 'package:abis_recipes/features/home/providers/loading_provider.dart';
import 'package:abis_recipes/features/home/providers/recipe_provider.dart';
import 'package:abis_recipes/features/shared/ui/app_name.dart';
import 'package:abis_recipes/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/services.dart';
import 'package:wakelock/wakelock.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController urlController = useTextEditingController();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.search),
              onTap: () async {
                ref.watch(searchProvider.notifier).state = '';
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchView()));
              },
              title: Text('All Recipes'),
            ),
            ListTile(
              leading: Icon(Icons.menu_book_outlined),
              onTap: () async {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => BooksPage()));
              },
              title: Text('Recipe Books'),
            ),
            ListTile(
              leading: Icon(Icons.account_circle_outlined),
              onTap: () async {
                Navigator.of(context).pushNamed('/profile');
              },
              title: Text('Account'),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: ColoredBox(color: Theme.of(context).colorScheme.primaryContainer)),
          Positioned(
              child: SizedBox(
            width: double.infinity,
            height: 150,
            child: ColoredBox(color: Colors.white),
          )),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              gap32,
              AppName(),
              gap32,
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: urlController,
                  decoration: InputDecoration(
                      labelText: 'Recipe Url',
                      hintText: 'https://sallysbakingaddiction.com/homemade-eclairs/',
                      border: OutlineInputBorder(),
                      fillColor: Colors.white,
                      filled: true,
                      suffixIcon: IconButton(
                        icon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.download_outlined),
                        ),
                        onPressed: () {
                          amplitude.logEvent('press load recipe button', eventProperties: {'url': urlController.text});
                          if (urlController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter a url')));
                            return;
                          }

                          if (!checkValidUrl(urlController.text) || !urlController.text.startsWith('https')) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter a valid url')));
                            return;
                          }
                          //'https://www.delish.com/cooking/recipe-ideas/a26870200/split-pea-soup-recipe/'
                          //'https://www.allrecipes.com/recipe/239541/chef-johns-fresh-salmon-cakes/',
                          //'https://sallysbakingaddiction.com/homemade-eclairs/',
                          //'https://www.countryliving.com/food-drinks/a37396532/salisbury-steak-recipe/'

                          //String url = 'https://www.brit.co/pescatarian-vegetable-recipes/';

                          // Unfocus keyboard
                          FocusScope.of(context).unfocus();
                          String url = urlController.text;
                          loadRecipe(ref, url);
                          ref.watch(urlProvider.notifier).state = url;
                          ref.watch(errorProvider.notifier).state = false;
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => RecipePage(),
                          ));
                        },
                      )),
                ),
              ),
              Center(
                  child: ElevatedButton.icon(
                icon: Icon(Icons.paste),
                style: OutlinedButton.styleFrom(side: BorderSide(color: Colors.white), backgroundColor: Theme.of(context).canvasColor),
                onPressed: () async {
                  amplitude.logEvent('press paste from clipboard');
                  // Paste from clipboard
                  ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);

                  if (data != null) {
                    String url = data.text!;
                    urlController.text = url;
                    ref.watch(urlProvider.notifier).state = url;
                    ref.watch(errorProvider.notifier).state = false;
                  }
                },
                label: Text(
                  'Paste from Clipboard',
                  style: Theme.of(context).textTheme.bodySmall!,
                ),
              )
                      .animate(/*onPlay: (controller) => controller.repeat()*/)
                      .shake(delay: Duration(seconds: 1), duration: Duration(milliseconds: 1000), offset: Offset(0, .1), hz: 2)),
              gap32,
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: sharedPreferences.getBool('bake_mode') ?? false ? Colors.green : Colors.white,
        onPressed: () {
          ref.read(bakeModeProvider.notifier).toggle();

          if(ref.watch(bakeModeProvider)){
            amplitude.logEvent('press bake mode on');
            Wakelock.enable();
          } else {
            amplitude.logEvent('press bake mode off');
            Wakelock.disable();
          }

          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: ref.watch(bakeModeProvider) ? Colors.green : Colors.black,
              content: Text(ref.watch(bakeModeProvider) ? 'Bake Mode On' : 'Bake Mode Off')));
        },
        child: Icon(
          ref.watch(bakeModeProvider) ? Icons.cake : Icons.cake_outlined,
          color: ref.watch(bakeModeProvider) ? Colors.white: Colors.black,
        ),
      ),
    );
  }
}
