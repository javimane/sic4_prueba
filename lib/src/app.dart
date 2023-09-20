import 'package:connectivity_checker/connectivity_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'navigation/routes.dart';
import 'notifiers/auth_notifier.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier()..init();
});

final _navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next == AuthState.signedOut) {
        _navigatorKey.currentState
            ?.pushNamedAndRemoveUntil(Routes.inicio, (r) => false);
      } else if (next == AuthState.signedIn) {
        _navigatorKey.currentState
            ?.pushNamedAndRemoveUntil(Routes.inicio, (r) => false);
      }
    });
    

    return ConnectivityAppWrapper(
      app: MaterialApp(
         navigatorKey: _navigatorKey,
        title: 'Authentication Flow',
        onGenerateRoute: Routes.routes,
        
        debugShowCheckedModeBanner: false,
      ),
    );
     
      
  }
}
