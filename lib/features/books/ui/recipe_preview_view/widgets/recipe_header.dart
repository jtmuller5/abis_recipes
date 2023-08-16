import 'package:abis_recipes/app/constants.dart';
import 'package:abis_recipes/features/shared/ui/browser/browser_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RecipeHeader extends StatelessWidget {
  const RecipeHeader(
    this.title,
    this.image,
    this.url, {
    Key? key,
  }) : super(key: key);

  final String title;
  final String image;
  final String url;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 100,
            width: 100,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: FadeInImage(
                placeholder: AssetImage('assets/transparent.png'),
                 image: NetworkImage(image),
                fit: BoxFit.cover,

              ),
            ),
          ),
          gap16,
          Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w600, fontSize: 24),
              ),
              gap8,
              GestureDetector(
                onTap: () async {
                  // Copy to clipboard
                 //  await Clipboard.setData(ClipboardData(text: url));
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => BrowserView(url: url),));
                },
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    url,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 16),
                  ),
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }
}
