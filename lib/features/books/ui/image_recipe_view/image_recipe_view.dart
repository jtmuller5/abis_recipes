import 'package:abis_recipes/app/constants.dart';
import 'package:abis_recipes/features/books/models/recipe.dart';
import 'package:abis_recipes/features/books/ui/image_recipe_view/widgets/formatted_output.dart';
import 'package:abis_recipes/features/books/ui/image_recipe_view/widgets/image_loading_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'image_recipe_view_model.dart';

class ImageRecipeView extends StatelessWidget {
  const ImageRecipeView({Key? key, required this.name}) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return ImageRecipeViewModelBuilder(
      builder: (context, model) {
        return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('extractedText')
                .where('file', isEqualTo: 'gs://abi-s-recipes.appspot.com/users/${FirebaseAuth.instance.currentUser?.uid}/images/${name}')
                .limit(1)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null && snapshot.data!.docs.isNotEmpty) {
                return Scaffold(
                  appBar: AppBar(
                    title: Text('Your Recipe'),
                  ),
                  body: Center(
                    child: Builder(
                      builder: (context) {
                        if (snapshot.data!.docs.first.data()['status'] == null) {
                          return ImageLoadingPage();
                        } else if (snapshot.data!.docs.first.data()['status'] != null && snapshot.data!.docs.first.data()['status']['state'] == 'PROCESSING') {
                          return ImageLoadingPage();
                        } else if (snapshot.data!.docs.first.data()['status'] != null && snapshot.data!.docs.first.data()['status']['state'] == 'ERRORED') {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Animate(
                                effects: [ScaleEffect()],
                                child: Image.asset(
                                  'assets/burnt.png',
                                  height: 300,
                                ),
                              ),
                              gap16,
                              Text(
                                'There was something wrong with that recipe :(',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          );
                        } else {
                          return CustomScrollView(
                            slivers: [
                              if (snapshot.data!.docs.first.data()['output'] != null) ...[
                                SliverToBoxAdapter(
                                  child: FutureBuilder(
                                    future: model.loadImage(snapshot.data!.docs.first.data()['file']),
                                    builder: (context, snapshot) {

                                        return AnimatedSwitcher(
                                          duration: kThemeAnimationDuration,
                                          child:snapshot.connectionState == ConnectionState.waiting?SizedBox(
                                              height: 300,

                                              child: ColoredBox(color: Colors.grey.shade200)).animate(onPlay: (controller) => controller.repeat()).shimmer(): Center(
                                            child: Image.network(snapshot.data!),
                                          ),
                                        );
                                    },
                                  ),
                                ),
                                FormattedOutput(rawText: snapshot.data!.docs.first.data()['output']),
                              ],
                            ],
                          );
                        }
                      },
                    ),
                  ),
                  floatingActionButton: ValueListenableBuilder(
                    valueListenable: model.savingRecipe,
                    builder: (context,saving, _) {
                      bool complete = (snapshot.data!.docs.first.data()['status'] != null && snapshot.data!.docs.first.data()['status']['state'] == 'COMPLETED');

                      if(!complete) return SizedBox.shrink();

                      return FloatingActionButton.extended(
                        onPressed: saving? (){}: () async {
                          Recipe? recipe = model.getRecipeFromOutput(snapshot.data!.docs.first.data()['output']);

                          if (recipe == null) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error parsing recipe')));
                            return;
                          }

                          model.setSavingRecipe(true);
                          String? url = await model.loadImage(snapshot.data!.docs.first.data()['file']);

                          if(url != null) recipe = recipe.copyWith(images: [url]);
                          await model.saveImageRecipe(recipe);
                        },
                        label: Text('Save'),
                        icon: saving? SizedBox(height: 24,width: 24,child: CircularProgressIndicator(color: Colors.white,),):Icon(Icons.bookmark_border),
                      );
                    }
                  ),
                );
              }

              return Scaffold(
                  body: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Animate(
                      effects: [ScaleEffect()],
                      child: Image.asset(
                        'assets/danish.png',
                        height: 300,
                      ),
                    ),
                    gap16,
                    Text(
                      'Loading your recipe...',
                      textAlign: TextAlign.center,
                    ),
                    gap16,
                    CircularProgressIndicator(),
                  ],
                ),
              ));
            });
      },
    );
  }
}
