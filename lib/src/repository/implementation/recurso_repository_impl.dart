import 'dart:io';


import '../../../main.dart';
import '../../data_source/firebase_data_source.dart';
import '../../model/recurso.dart';
import '../recurso_repository.dart';

class RecursoRepositoryImp extends RecursoRepository {
  final FirebaseDataSource _fDataSource = getIt();

  @override
  String newId() {
    return _fDataSource.newId();
  }

  @override
  Stream<Iterable<Recurso>> getRecursos() {
    return _fDataSource.getRecursos();
  }

  @override
  Future<void> saveRecurso(Recurso recurso, File? image, File? logo) {
    return _fDataSource.saveRecurso(recurso, image, logo);
  }

  @override
  Future<void> deleteRecurso(Recurso recurso) {
    return _fDataSource.deleteRecurso(recurso);
  }
}
