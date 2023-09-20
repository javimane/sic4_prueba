import 'package:flutter/material.dart';

import '../ui/edit_recurso_screen.dart';
import '../ui/home_screen.dart';
import '../ui/inicio_screen.dart';
import '../ui/login_screen.dart';

import '../ui/splash_screen.dart';

class Routes {
  static const splash = '/';
  static const login = '/login';
  static const home = '/home';
  static const editUser = '/editUser';
  static const inicio = '/inicio';

  static Route routes(RouteSettings settings) {
    MaterialPageRoute buildRoute(Widget widget) {
      return MaterialPageRoute(builder: (_) => widget, settings: settings);
    }

    switch (settings.name) {
      case splash:
        return buildRoute(const SplashScreen());
      case login:
        return buildRoute(const LoginScreen());
      case inicio:
        return buildRoute(const InicioScreen());
      case home:
        return buildRoute( const HomeScreen());
      case editUser:
        return buildRoute(const EditRecursoScreen());
      default:
        throw Exception('Route does not exists');
    }
  }
}
