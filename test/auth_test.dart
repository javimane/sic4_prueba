import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sic4change_prueba/main.dart';
import 'package:sic4change_prueba/src/app.dart';
import 'package:sic4change_prueba/src/model/recurso.dart';
import 'package:sic4change_prueba/src/repository/auth_repository.dart';
import 'package:sic4change_prueba/src/repository/recurso_repository.dart';
import 'package:sic4change_prueba/src/ui/home_screen.dart';
import 'package:sic4change_prueba/src/ui/login_screen.dart';
import 'package:sic4change_prueba/src/ui/splash_screen.dart';



class _MockAuthRepo extends Mock implements AuthRepository {}

class _MockRecursoRepo extends Mock implements RecursoRepository {}

Stream<String> get loggedUserStream => Stream.fromIterable(['someUserID']);

void main() {
  late _MockAuthRepo mockRepo;
  late _MockRecursoRepo mockUserRepo;

  setUp(() async {
    await getIt.reset();

    mockRepo = _MockAuthRepo();
    mockUserRepo = _MockRecursoRepo();

    when(() => mockUserRepo.getRecursos())
        .thenAnswer((_) => Stream.fromIterable([]));

    getIt.registerSingleton<AuthRepository>(mockRepo);
    getIt.registerSingleton<RecursoRepository>(mockUserRepo);
  });

  Widget getMaterialApp({Recurso? arguments}) {
    return const ProviderScope(child: MyApp());
  }

  testWidgets(
      'Intro screen will be shown after splash when the user is not logged in',
      (WidgetTester tester) async {
    final stream = Stream.fromIterable([null]);
    when(() => mockRepo.onAuthStateChanged).thenAnswer((_) => stream);

    await tester.pumpWidget(getMaterialApp());
    await tester.pump();
    expect(find.byType(SplashScreen), findsOneWidget);

    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets(
      'Home screen will be shown after splash when the user is logged in',
      (WidgetTester tester) async {
    when(() => mockRepo.onAuthStateChanged).thenAnswer((_) => loggedUserStream);

    await tester.pumpWidget(getMaterialApp());
    await tester.pump();
    expect(find.byType(SplashScreen), findsOneWidget);

    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets('Pressing logout will return to the IntroScreen',
      (WidgetTester tester) async {
    when(() => mockRepo.onAuthStateChanged).thenAnswer((_) => loggedUserStream);
    when(() => mockRepo.signOut()).thenAnswer((_) async {});

    await tester.pumpWidget(getMaterialApp());
    await tester.pumpAndSettle();

    expect(find.byType(HomeScreen), findsOneWidget);

    await tester.tap(find.byKey(const Key('Logout')));
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
  });
}
