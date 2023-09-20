import 'dart:io';


import '../model/recurso.dart';

abstract class RecursoRepository {
  String newId();

  Stream<Iterable<Recurso>> getRecursos();

  Future<void> saveRecurso(Recurso recurso, File? image, File? logo);

  Future<void> deleteRecurso(Recurso recurso);
}