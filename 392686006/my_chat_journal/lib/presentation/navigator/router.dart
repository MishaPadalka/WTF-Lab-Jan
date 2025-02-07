import 'package:flutter/material.dart';
import '../pages/event/screens/event_screen.dart';
import '../pages/home/screens/home_screen.dart';

/// Constants for pages, all pages should be listed here without exceptions
class Routs{
  static const root = '/';
  static const home = '/home';
  static const event = '/event';
}

/// Routes to which you do not need to transfer data, they will be based on DI
final routes = <String, WidgetBuilder>{
  // Routs.root: (_) => RootNavigation(),
  Routs.home: (_) => const HomeScreen(),
};
///Routes to which data must be transferred.
// Each MaterialPageRoute must contain a [settings] parameter that defines
// its purpose.

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case Routs.event:
      return MaterialPageRoute(
        builder: (_) => EventScreen(title: settings.arguments as String),
        settings: settings,
      );
    default:
      throw Exception("Route with name ${settings.name} doesn't exists");
  }
}