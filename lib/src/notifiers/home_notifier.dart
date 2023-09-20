import 'dart:async';

import 'package:flutter/material.dart';

import '../../main.dart';
import '../model/recurso.dart';
import '../repository/recurso_repository.dart';

class HomeNotifier extends ChangeNotifier {
  final RecursoRepository _userRepository = getIt();
  StreamSubscription? _recursosSubscription;

  var isLoading = true;
  Iterable<Recurso> recursos = [];

  Future<void> init() async {
    _recursosSubscription = _userRepository.getRecursos().listen(recursoListen);
  }

  void recursoListen(Iterable<Recurso> recursos) async {
    isLoading = false;
    this.recursos = recursos;
    notifyListeners();
  }

  @override
  void dispose() {
    _recursosSubscription?.cancel();
    return super.dispose();
  }
}
