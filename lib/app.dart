import 'package:flutter/material.dart';

import 'presentation/navigation/export_navigation.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: NavigationView());
  }
}
