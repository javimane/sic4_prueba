import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sic4change_prueba/main.dart';
import 'package:sic4change_prueba/src/model/recurso.dart';
import 'package:sic4change_prueba/src/repository/recurso_repository.dart';
import 'package:sic4change_prueba/src/ui/home_screen.dart';



const _recurso1 = Recurso(id: '111', nombre: 'Yayo', lugar: 'España', tipo: 'empleo', validez: '10/05/2010');
const _recurso2 = Recurso(id: '200', nombre: 'Juan', lugar: 'Argentina', tipo: 'diversion', validez: '10/05/2010');

class _MockRecursoRepo extends Mock implements RecursoRepository {}

void main() {
  late _MockRecursoRepo mockRepo;

  setUp(() async {
    await getIt.reset();
    mockRepo = _MockRecursoRepo();
    getIt.registerSingleton<RecursoRepository>(mockRepo);
  });

  Widget getMaterialApp() {
    return const ProviderScope(
        child: MaterialApp(
      home: HomeScreen(),
    ));
  }

  testWidgets('Empty list when repository returns 0 users',
      (WidgetTester tester) async {
    when(() => mockRepo.getRecursos()).thenAnswer((_) {
      return Stream.fromIterable([]);
    });

    await tester.pumpWidget(getMaterialApp());
    await tester.pumpAndSettle();

    expect(find.byType(Card), findsNothing);
  });

  testWidgets('Two items in the  list when repository returns 2 users',
      (WidgetTester tester) async {
    when(() => mockRepo.getRecursos()).thenAnswer((_) {
      return Stream.fromIterable([
        [_recurso1, _recurso2]
      ]);
    });

    await tester.pumpWidget(getMaterialApp());
    await tester.pumpAndSettle();

    expect(find.byType(Card), findsNWidgets(2));
  });
}
