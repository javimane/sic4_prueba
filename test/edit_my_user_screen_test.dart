import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sic4change_prueba/main.dart';
import 'package:sic4change_prueba/src/model/recurso.dart';
import 'package:sic4change_prueba/src/repository/recurso_repository.dart';
import 'package:sic4change_prueba/src/ui/edit_recurso_screen.dart';



const _recurso1 = Recurso(id: '111', nombre: 'Yayo', lugar: 'España', tipo: 'empleo', validez: '10/05/2010');

class _MockRecurso extends Mock implements Recurso {}

class _MockRecursoRepo extends Mock implements RecursoRepository {}

void main() {
  late _MockRecursoRepo mockRepo;

  setUp(() async {
    await getIt.reset();
    registerFallbackValue(_MockRecurso());
    mockRepo = _MockRecursoRepo();
    getIt.registerSingleton<RecursoRepository>(mockRepo);
  });

  Widget getMaterialApp({Recurso? arguments}) {
    return ProviderScope(child: MaterialApp(
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          settings: RouteSettings(arguments: arguments),
          builder: (context) {
            return const EditRecursoScreen();
          },
        );
      },
    ));
  }

  testWidgets('Saving user will call repository successfully',
      (WidgetTester tester) async {
    when(() => mockRepo.saveRecurso(any(), null, null)).thenAnswer((_) async {});
    when(() => mockRepo.newId()).thenReturn('5555');

    await tester.pumpWidget(getMaterialApp());
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('Name')), 'Yayo');
    await tester.enterText(find.byKey(const Key('Last Name')), 'Are');
    await tester.enterText(find.byKey(const Key('Age')), '25');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Save'));
    await tester.pump(const Duration(seconds: 3));

    const newUser = Recurso(id: '120', nombre: 'yoel', lugar: 'argentina', tipo: 'empleo', validez: '10/05/2010');
    verify(() => mockRepo.saveRecurso(newUser, null , null)).called(1);
  });

  testWidgets('Updating user will call repository successfully',
      (WidgetTester tester) async {
    when(() => mockRepo.saveRecurso(any(), null , null)).thenAnswer((_) async {});

    await tester.pumpWidget(getMaterialApp(arguments: _recurso1));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('Name')), 'Hola');
    await tester.enterText(find.byKey(const Key('Last Name')), 'Mundo');
    await tester.enterText(find.byKey(const Key('Age')), '10');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Save'));
    await tester.pump(const Duration(seconds: 3));

    final updatedUser =
        _recurso1.copyWith(nombre: 'Hola', tipo: 'Mundo', lugar: 'chile');
    verify(() => mockRepo.saveRecurso(updatedUser, null , null)).called(1);
  });

  testWidgets('When is a new user delete button is not visible',
      (WidgetTester tester) async {
    await tester.pumpWidget(getMaterialApp());
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('Delete')), findsNothing);
  });

  testWidgets('When is an editing user delete button is visible',
      (WidgetTester tester) async {
    await tester.pumpWidget(getMaterialApp(arguments: _recurso1));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('Delete')), findsOneWidget);
  });

  testWidgets('Deleting an editing user will call repository successfully',
      (WidgetTester tester) async {
    when(() => mockRepo.deleteRecurso(any())).thenAnswer((_) async {});

    await tester.pumpWidget(getMaterialApp(arguments: _recurso1));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('Delete')));
    await tester.pump();

    verify(() => mockRepo.deleteRecurso(_recurso1)).called(1);
  });
}
