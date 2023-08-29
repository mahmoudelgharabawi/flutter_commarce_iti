import 'package:flutter/material.dart';
import 'package:flutter_commarce/providers/cart_provider.dart';
import 'package:flutter_commarce/providers/favourite.provider.dart';
import 'package:flutter_commarce/providers/product.provider.dart';
import 'package:flutter_commarce/services/prefs.service.dart';
import 'package:flutter_commarce/views/pages/home_page.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PrefService.init();
  // for clear prefrence
  // PrefService.preferences?.clear();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => ProductProvider()),
    ChangeNotifierProvider(create: (_) => FavouriteProvider()),
    ChangeNotifierProvider(create: (_) => CartProvider()),
  ], child: MyApp()));
}

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Ecommarce',
      theme: ThemeData(
        fontFamily: 'Inter',
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xffF16A26)),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
