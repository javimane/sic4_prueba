import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import '../../main.dart';
import '../model/recurso.dart';
import '../repository/recurso_repository.dart';

class EditRecursoNotifier extends ChangeNotifier {
  // Get the injected RecursoRepository
  final RecursoRepository _recursoRepository = getIt();

  // Variables that will hold the state of this ChangeNotifier
  File? pickedImage;
  bool isLoading = false;
  File? pickedLogo;
  // In the presentation layer we will check the value of isDone.
  // When is true we will navigate to the previous page
  bool isDone = false;

  // When we are editing _toEdit won't be null
  Recurso? _toEdit;

  EditRecursoNotifier(this._toEdit);

  // This function will be called from the presentation layer
  // when an image is selected
  void setImage(File? imageFile ) async {
    pickedImage = imageFile;
   
    notifyListeners();
  }
 void setLogo( File? logoFile) async {
    
    pickedLogo = logoFile;
    notifyListeners();
  }
  // This function will be called from the presentation layer
  // when the recurso has to be saved
  Future<void> saveRecurso(
    String nombre,
    String lugar,
    String tipo,
    String validez,
    
  ) async {
    isLoading = true;
    notifyListeners();

    // If we are editing, we use the existing id. Otherwise, create a new one.
    final uid = _toEdit?.id ?? _recursoRepository.newId();
    _toEdit = Recurso(
        id: uid,
        nombre: nombre,
        lugar: lugar,
        tipo: tipo,
        validez: validez,
        image: _toEdit?.image,
        logo: _toEdit?.logo
        );

    await _recursoRepository.saveRecurso(_toEdit!, pickedImage ,pickedLogo);
    isDone = true;
    notifyListeners();
  }

  // This function will be called from the presentation layer
  // when we want to delete the recurso
  Future<void> deleteRecurso() async {
    isLoading = true;
    notifyListeners();

    if (_toEdit != null) {
      await _recursoRepository.deleteRecurso(_toEdit!);
    }
    isDone = true;
    notifyListeners();
  }
}
