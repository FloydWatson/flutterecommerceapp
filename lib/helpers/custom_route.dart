import 'package:flutter/material.dart';

// material page route creats on the fly navigation. generic class so pass a generic type t
class CustomRoute<T> extends MaterialPageRoute<T> {

  CustomRoute({
    WidgetBuilder builder,
    RouteSettings settings,
  }) : super(
          builder: builder,
          settings: settings,
        );

  // part of material page route. 
  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // dont animate home
    if (settings.name == '/') {
      return child;
    }
    // transition if not returning to home
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}

// transition class. used in main a preset transition
class CustomPageTransitionBuilder extends PageTransitionsBuilder {
 @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // dont animate home
    // if (route.settings.name == '/') {
    //   return child;
    // }
    // animate other routes
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}