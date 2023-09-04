import 'package:abis_recipes/app/constants.dart';
import 'package:abis_recipes/app/router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'dart:io' show Platform;

@singleton
class SubscriptionService {
  String _premiumId = 'premium';

  ValueNotifier<bool> premium = ValueNotifier(false);

  ValueNotifier<Offering?> offering = ValueNotifier(null);

  void setOffering(Offering? val){
    offering.value = val;
  }

  void setPremium(bool val) {
    premium.value = val;
  }

  Future<void> initPlatformState() async {
    await Purchases.setDebugLogsEnabled(true);

    late PurchasesConfiguration configuration;
    if (Platform.isAndroid) {
      configuration = PurchasesConfiguration(const String.fromEnvironment('google_sdk_key'));
      if (false) {
        // use your preferred way to determine if this build is for Amazon store
        // checkout our MagicWeather sample for a suggestion
        configuration = AmazonConfiguration(const String.fromEnvironment('amazon_sdk_key'));
      }
    } else if (Platform.isIOS) {
      configuration = PurchasesConfiguration(const String.fromEnvironment('ios_sdk_key'));
    }

    await Purchases.configure(configuration..appUserID = FirebaseAuth.instance.currentUser?.uid);
    await checkSubscription();

    Purchases.addCustomerInfoUpdateListener((purchaserInfo)  {

      debugPrint('purchaserInfo.activeSubscriptions: ' + purchaserInfo.activeSubscriptions.toString());
      debugPrint('purchaserInfo.entitlements.all: ' + purchaserInfo.entitlements.all.toString());
      debugPrint('purchaserInfo.entitlements.active: ' + purchaserInfo.entitlements.active.toString());
      debugPrint('purchaserInfo.entitlements.all[_premiumId]: ' + purchaserInfo.entitlements.all[_premiumId].toString());
      debugPrint('purchaserInfo.allExpirationDates: ' + (purchaserInfo.allExpirationDates.toString()));
      // handle any changes to purchaserInfo
      if(purchaserInfo.entitlements.all[_premiumId]?.isActive ?? false){
        setPremium(purchaserInfo.entitlements.all[_premiumId]?.isActive ?? false);
      }
    });
  }

  Future<void> checkSubscription() async {
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      if (customerInfo.entitlements.all[_premiumId]?.isActive ?? false) {
        // Grant user "pro" access
        setPremium(true);
      }
    } on PlatformException catch (e) {
      // Error fetching purchaser info
      setPremium(false);
    }
  }

  Future<Offerings?> fetchOfferings() async {
    try {
      Offerings offerings = await Purchases.getOfferings();
      if (offerings.current != null) {
        setOffering(offerings.current);
      }
    } on PlatformException catch (e) {
      // optional error handling

      return null;
    }
    return null;
  }

  Future<void> makePurchase(Package package) async {
    try {
      CustomerInfo customerInfo = await Purchases.purchasePackage(package);
      var isPremium = customerInfo.entitlements.all[_premiumId]?.isActive ?? false;
      if (isPremium) {
        setPremium(true);
      }
    } on PlatformException catch (e) {
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
        // showError(e);
      }
    }
  }

  Future<void> showPremiumPopup() async {
    await showModalBottomSheet(context: router.routerDelegate.navigatorKey.currentContext!,isScrollControlled: true,

      builder: (context) {
      return FractionallySizedBox(
        heightFactor: .7,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              SizedBox(
                height: 350,
                child: Stack(
                  children: [

                    Positioned(
                        top: 0,
                        left: 0,
                        child: Opacity(
                          opacity: .7,
                          child: Image.asset('assets/workstation.png',
                          height: 300,),
                        )),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: Image.asset('assets/feather.png',
                        height: 200,),
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: Image.asset('assets/book_stack.png',height: 150,))
                  ],
                ),
              ),
              Text('You need to be a premium member to access this feature.'),
              gap16,
              OutlinedButton(onPressed: (){
                router.pop();
               router.push('/subscriptions');
              }, child: const Text('Subscribe'))
            ],
          ),
        ),
      );
    },);
  }
}
