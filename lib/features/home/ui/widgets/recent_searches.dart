import 'package:abis_recipes/app/router.dart';
import 'package:abis_recipes/main.dart';
import 'package:flutter/material.dart';

class RecentSearches extends StatelessWidget {
  const RecentSearches({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList.list(
      children: (sharedPreferences.getStringList('recent_searches')?? []).map((e) => ListTile(
        onTap: (){
          router.push(Uri(path: '/recipe-preview', queryParameters: {'url': e.toString()}).toString());
        },
        leading: Icon(Icons.link,size: 16, color: Theme.of(context).colorScheme.secondary,),
        title: Text(e,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,),
      )).toList(),
    );
  }
}
