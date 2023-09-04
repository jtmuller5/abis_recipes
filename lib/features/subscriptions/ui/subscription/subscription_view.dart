import 'dart:io';

import 'package:abis_recipes/app/constants.dart';
import 'package:abis_recipes/app/services.dart';
import 'package:abis_recipes/features/shared/ui/pastry_icon.dart';
import 'package:abis_recipes/features/subscriptions/ui/subscription/widgets/feature_card.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'subscription_view_model.dart';

class SubscriptionView extends StatelessWidget {
  const SubscriptionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SubscriptionViewModelBuilder(
      builder: (context, model) {
        return ValueListenableBuilder(
            valueListenable: subscriptionService.premium,
            builder: (context, premium, child) {
              if (premium) {
                return Scaffold(
                  appBar: AppBar(
                    title: Text('Thanks!'),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.more_vert),
                        onPressed: () {
                          // Manage subscriptions
                          if (Platform.isIOS) {
                            launchUrl(Uri.parse("https://apps.apple.com/account/subscriptions"));
                          } else {
                            launchUrl(Uri.parse('https://play.google.com/store/account/subscriptions'));
                          }
                        },
                      ),
                    ],
                  ),
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FadeInImage(placeholder: MemoryImage(kTransparentImage
                        ), image: AssetImage(
                          'assets/workstation.png',

                        ), height: 300,),
                        gap16,
                        Text('You are a premium user!',
                        style: Theme.of(context).textTheme.headlineSmall,),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                );
              }
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Get Premium'),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: PastryIcon(
                        asset: 'assets/oven.png',
                        pastry: Pastry.eclair,
                      ),
                    )
                  ],
                ),
                body: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    FeatureCard(
                      asset: 'assets/workstation.png',
                      title: 'Unlimited Recipe Extractions',
                      description: 'Extract as many recipes as you want on the web or with your camera',
                    ),
                    FeatureCard(
                      asset: 'assets/book_stack.png',
                      title: 'Unlimited Recipe Books',
                      description: 'Organize your recipes using as many recipe books as you want',
                    ),
                    FeatureCard(
                      asset: 'assets/feather.png',
                      title: 'Edit Ingredients and Instructions',
                      description: 'Clean up extracted recipes by editing, adding, or deleting ingredients and instructions',
                    ),
                    SizedBox(height: 100),
                  ],
                ),
                floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
                floatingActionButton: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: FloatingActionButton.extended(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            label: Text(
                              'Get Premium',
                              style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                            onPressed: () async {
                              await subscriptionService.makePurchase(subscriptionService.offering.value!.monthly!);
                            }),
                      ),
                    ],
                  ),
                ),
              );
            });
      },
    );
  }
}
