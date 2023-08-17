import 'package:abis_recipes/app/constants.dart';
import 'package:abis_recipes/app/services.dart';
import 'package:abis_recipes/features/home/ui/widgets/bake_mode_button.dart';
import 'package:abis_recipes/features/home/ui/widgets/recent_recipes.dart';
import 'package:abis_recipes/features/shared/ui/app_name.dart';
import 'package:abis_recipes/features/shared/ui/pastry_icon.dart';
import 'package:abis_recipes/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'home_view_model.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HomeViewModelBuilder(
      builder: (context, model) {
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
                  leading: PastryIcon(pastry: Pastry.eclair, asset: 'assets/ingredients.png'),
                  onTap: () async {
                    searchService.setSearch('');
                    context.pop();
                    context.push('/recipes');
                  },
                  title: Text('All Recipes'),
                ),
                ListTile(
                  leading: PastryIcon(pastry: Pastry.eclair, asset: 'assets/book.png'),
                  onTap: () async {
                    context.pop();
                    context.push('/books');
                  },
                  title: Text('Recipe Books'),
                ),
                ListTile(
                  leading: PastryIcon(pastry: Pastry.eclair, asset: 'assets/chef.png'),
                  onTap: () async {
                    context.pop();
                    context.push('/profile');
                  },
                  title: Text('Account'),
                ),
              ],
            ),
          ),
          body: Stack(
            alignment: Alignment.topCenter,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: ColoredBox(color: Colors.white),
              ),
              Positioned(
                  child: SizedBox(
                width: double.infinity,
                height: 150,
                child: ColoredBox(color: Theme.of(context).colorScheme.inversePrimary),
              )),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  gap32,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      gap32,
                      AppName(),
                      PastryIcon(
                        pastry: Pastry.cupCake,
                      )
                    ],
                  ),
                  gap32,
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: model.urlController,
                      decoration: InputDecoration(
                          labelText: 'Recipe Url',
                          hintText: 'https://sallysbakingaddiction.com/homemade-eclairs/',
                          border: OutlineInputBorder(),
                          fillColor: Colors.white,
                          filled: true,
                          prefixIcon: IconButton(
                            icon: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.paste),
                            ),
                            onPressed: () async {
                              amplitude.logEvent('press paste from clipboard');
                              // Paste from clipboard
                              ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);

                              if (data != null) {
                                String url = data.text!;
                                model.urlController.text = url;
                                searchService.setUrl(url);
                              }
                            },
                          ).animate(/*onPlay: (controller) => controller.repeat()*/).shake(delay: Duration(seconds: 1), duration: Duration(milliseconds: 1000), offset: Offset(0, .1), hz: 2),
                          suffixIcon: IconButton(
                            icon: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.download_outlined),
                            ),
                            onPressed: () {
                              amplitude.logEvent('press load recipe button', eventProperties: {'url': model.urlController.text});
                              if (model.urlController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter a url')));
                                return;
                              }

                              if (!checkValidUrl(model.urlController.text) || !model.urlController.text.startsWith('https')) {
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
                              String url = model.urlController.text;
                              searchService.setUrl(url);
                              context.push(Uri(path: '/recipe-preview', queryParameters: {'url': url}).toString());
                            },
                          )),
                    ),
                  ),
                  gap16,
                  Expanded(child: RecentRecipes()),
                ],
              ),
            ],
          ),
          floatingActionButton: BakeModeButton(),
        );
      },
    );
  }
}
