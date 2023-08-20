import 'package:abis_recipes/app/get_it.dart';
import 'package:abis_recipes/app/router.dart';
import 'package:abis_recipes/app/services.dart';
import 'package:abis_recipes/firebase_options.dart';
import 'package:amplitude_flutter/amplitude.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences sharedPreferences;

final Amplitude amplitude = Amplitude.getInstance();

Future<void> main() async {
  // Ensure initialized
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await amplitude.init("ff2f485bec7b3432c7a6ed352cc6420c");
  await configureDependencies();
  // await isar.writeTxn(() async => await isar.clear());
  sharedPreferences = await SharedPreferences.getInstance();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    return MaterialApp.router(
      title: 'Abi\'s Recipes',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
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
    );
  }

  @override
  void initState() {
    super.initState();

    ReceiveSharingIntent.getInitialTextAsUri().then((Uri? value) {
      print("Shared: getInitialTextAsUri ${value?.toString()}");

      if (value != null && checkValidUrl(value.toString())) {
        searchService.setUrl(value.toString());
        router.push(Uri(path: '/recipe-preview', queryParameters: {'url': value.toString()}).toString());
      }
    }).onError((error, stackTrace) {
      print("getInitialSharing error: $error");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
    });

    ReceiveSharingIntent.getTextStreamAsUri().listen((Uri value) {
      print("Shared: getTextStreamAsUri ${value.toString()}");

      debugPrint('value.path: ' + value.path);
      if (value.path.isNotEmpty && checkValidUrl(value.toString())) {
        searchService.setUrl(value.toString());
        router.push(Uri(path: '/recipe-preview', queryParameters: {'url': value.toString()}).toString());
      }
    }, onError: (err) {
      print("getTextStreamAsUri error: $err");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err.toString())));
    });

    /*ReceiveSharingIntent.getMediaStream().listen((List<SharedMediaFile> value) {
      print("Shared: getMediaStream ${value.map((f) => f.path).join(",")}");

      debugPrint('value.first.value: ' + value.first.path.toString());
      if (value.isNotEmpty && checkValidUrl(value.first.path ?? "")) {
        loadRecipe(ref, value.first.path!);
        Navigator.of(navigatorKey.currentContext!).push(MaterialPageRoute(builder: (context) => RecipePage()));
      }
    }, onError: (err) {
      print("getIntentDataStream error: $err");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err.toString())));
    });

    ReceiveSharingIntent.getInitialMedia().then((List<SharedMediaFile> value) {
      print("Shared: getInitialSharing ${value.map((f) => f.path).join(",")}");

      if (value.isNotEmpty && checkValidUrl(value.first.path ?? "")) {
        loadRecipe(ref, value.first.path);
        Navigator.of(navigatorKey.currentContext!).push(MaterialPageRoute(builder: (context) => RecipePage()));
      }
    }).onError((error, stackTrace) {
      print("getInitialSharing error: $error");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
    });*/
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
