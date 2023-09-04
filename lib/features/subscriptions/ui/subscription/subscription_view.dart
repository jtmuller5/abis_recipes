import 'package:abis_recipes/app/constants.dart';
import 'package:abis_recipes/app/services.dart';
import 'package:abis_recipes/features/shared/ui/pastry_icon.dart';
import 'package:abis_recipes/features/subscriptions/ui/subscription/widgets/feature_card.dart';
import 'package:flutter/material.dart';
import 'subscription_view_model.dart';

class SubscriptionView extends StatelessWidget {
  const SubscriptionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SubscriptionViewModelBuilder(
      builder: (context, model) {
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
                      label: Text(
                        'Get Premium',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      onPressed: () {
                        subscriptionService.makePurchase(subscriptionService.offering.value!.monthly!);
                      }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
