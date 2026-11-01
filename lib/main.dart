import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'views/home_page.dart';

void main() {
  runApp(const ProviderScope(child: AutoMsgApp()));
}

class AutoMsgApp extends StatelessWidget {
  const AutoMsgApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AutoMsg',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1F6F78)),
      ),
      home: const HomePage(),
    );
  }
}
