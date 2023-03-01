import 'package:abis_recipes/features/books/models/book.dart';
import 'package:abis_recipes/features/books/models/recipe.dart';
import 'package:abis_recipes/features/books/ui/recipe_page/recipe_page.dart';
import 'package:abis_recipes/features/home/ui/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sharing_intent/flutter_sharing_intent.dart';
import 'package:flutter_sharing_intent/model/sharing_file.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';

late Isar isar;

Future<void> main() async {
  isar = await Isar.open([
    RecipeSchema,
    BookSchema,
  ]);


  runApp(ProviderScope(child: const MyApp()));
}

GlobalObjectKey<NavigatorState> navigatorKey = GlobalObjectKey<NavigatorState>(NavigatorState());

class MyApp extends StatefulHookConsumerWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark));

    return MaterialApp(
      title: 'Abi\'s Recipes',
      navigatorKey: navigatorKey,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: flexSchemeLight,
        fontFamily: GoogleFonts.imprima().fontFamily,
        buttonTheme: const ButtonThemeData(
          shape: StadiumBorder(),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            shape: const StadiumBorder(),
          ),
        ),
        appBarTheme: AppBarTheme(
           iconTheme: IconThemeData(color: flexSchemeLight.primary),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(36)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(36)),
            borderSide: BorderSide(color: Color(0xffa4c4ed)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(36)),
            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
          ),
        ),
      ),
      home: const HomeView(),
    );
  }

  @override
  void initState() {
    super.initState();

    FlutterSharingIntent.instance.getMediaStream().listen((List<SharedFile> value) {
      print("Shared: getMediaStream ${value.map((f) => f.value).join(",")}");

      debugPrint('value.first.value: ' + value.first.value.toString());
      if (value.isNotEmpty && checkValidUrl(value.first.value ?? "")) {
        loadRecipe(ref, value.first.value!);
        Navigator.of(navigatorKey.currentContext!).push(MaterialPageRoute(builder: (context) => RecipePage()));
      }
    }, onError: (err) {
      print("getIntentDataStream error: $err");
    });

    FlutterSharingIntent.instance.getInitialSharing().then((List<SharedFile> value) {
      print("Shared: getInitialSharing ${value.map((f) => f.value).join(",")}");

      if (value.isNotEmpty && checkValidUrl(value.first.value ?? "")) {
        loadRecipe(ref, value.first.value!);
        Navigator.of(navigatorKey.currentContext!).push(MaterialPageRoute(builder: (context) => RecipePage()));
      }
    });
  }


}

bool checkValidUrl(String url) {
  try {
    Uri.parse(url);
    return true;
  } catch (e) {
    print('Invalid URL: $url');
    return false;
  }
}

const ColorScheme flexSchemeLight = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xffcd5758),
  onPrimary: Color(0xffffffff),
  primaryContainer: Color(0xffe49797),
  onPrimaryContainer: Color(0xff130d0d),
  secondary: Color(0xff69b9cd),
  onSecondary: Color(0xff000000),
  secondaryContainer: Color(0xffa6edff),
  onSecondaryContainer: Color(0xff0e1414),
  tertiary: Color(0xff57c8d3),
  onTertiary: Color(0xff000000),
  tertiaryContainer: Color(0xff90f2fc),
  onTertiaryContainer: Color(0xff0c1414),
  error: Color(0xff790000),
  onError: Color(0xffffffff),
  errorContainer: Color(0xfff1d8d8),
  onErrorContainer: Color(0xff141212),
  background: Color(0xfffdf9f9),
  onBackground: Color(0xff090909),
  surface: Color(0xfffdf9f9),
  onSurface: Color(0xff090909),
  surfaceVariant: Color(0xfffbf3f3),
  onSurfaceVariant: Color(0xff131313),
  outline: Color(0xff565656),
  shadow: Color(0xff000000),
  inverseSurface: Color(0xff171313),
  onInverseSurface: Color(0xfff5f5f5),
  inversePrimary: Color(0xfffff0f0),
  surfaceTint: Color(0xffcd5758),
);

const ColorScheme flexSchemeDark = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xffda8585),
  onPrimary: Color(0xfffff9f9),
  primaryContainer: Color(0xffc05253),
  onPrimaryContainer: Color(0xfffdecec),
  secondary: Color(0xff85c6d6),
  onSecondary: Color(0xff0e1314),
  secondaryContainer: Color(0xff21859e),
  onSecondaryContainer: Color(0xffe4f4f8),
  tertiary: Color(0xff68cdd7),
  onTertiary: Color(0xff0c1414),
  tertiaryContainer: Color(0xff037481),
  onTertiaryContainer: Color(0xffe0f1f4),
  error: Color(0xffcf6679),
  onError: Color(0xff140c0d),
  errorContainer: Color(0xffb1384e),
  onErrorContainer: Color(0xfffbe8ec),
  background: Color(0xff1c1717),
  onBackground: Color(0xffedecec),
  surface: Color(0xff1c1717),
  onSurface: Color(0xffedecec),
  surfaceVariant: Color(0xff281e1e),
  onSurfaceVariant: Color(0xffdddbdb),
  outline: Color(0xffa39d9d),
  shadow: Color(0xff000000),
  inverseSurface: Color(0xfffcf7f7),
  onInverseSurface: Color(0xff131313),
  inversePrimary: Color(0xff6d4848),
  surfaceTint: Color(0xffda8585),
);
