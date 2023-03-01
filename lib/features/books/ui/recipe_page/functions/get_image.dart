import 'package:abis_recipes/features/books/ui/recipe_page/services/html_processor.dart';
import 'package:abis_recipes/features/home/providers/recipe_provider.dart';
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void getImage(BeautifulSoup bs, WidgetRef ref, {bool print = false}) {
  Bs4Element? image = bs.img;

  String? imageUrl;

  try {
    imageUrl = bs.head?.find('meta', attrs: {'property': 'og:image'})?.attributes['content'];

    if (imageUrl == null || imageUrl == '') {
      if (image?.attributes['src'] != null && image?.attributes['src'] != '') {
        imageUrl = image?.attributes['src'];
        debugPrint('src image: ' + imageUrl.toString());
      } else if (image?.attributes['data-src'] != null && image?.attributes['data-src'] != '') {
        imageUrl = image?.attributes['data-src'];
        debugPrint('data src image: ' + imageUrl.toString());
      } else {
        imageUrl = null;
      }

      if (imageUrl == null || !HtmlProcessor.isHttps(imageUrl)) {
        List<Bs4Element> images = bs.findAll('img');

        images.forEach((element) {
          // debugPrint('image: ' + element.toString());

          if (element.attributes['alt'] != null &&
              element.attributes['alt']?.toLowerCase().contains(ref.watch(recipeProvider)?.title?.toLowerCase() ?? '') != '') {
            imageUrl = element.attributes['src'];
            debugPrint('img image: ' + imageUrl.toString());
          }
        });
        //debugPrint('image 2: ' + image.toString());
      }

      if (imageUrl != null && !HtmlProcessor.isHttps(imageUrl!)) {
        debugPrint('Video: ' + (bs.find('div').toString()));
        imageUrl = bs.find('*', attrs: {'poster': true})?.attributes['poster'];
      }
    } else {
      debugPrint('Meta image: ' + imageUrl.toString());
    }

    if (print) debugPrint('image: ' + imageUrl.toString());
    ref.read(recipeProvider.notifier).updateRecipeImage(imageUrl);
  } catch (e) {
    debugPrint('getImage error: ' + e.toString());
  }
}
