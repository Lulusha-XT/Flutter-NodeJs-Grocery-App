import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groccery_app/pages/home_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groccery_app/pages/product_page.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      routes: <String, WidgetBuilder>{
        '/products': (BuildContext context) => const ProducstPage(),
      },
    );
  }
}
