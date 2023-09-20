import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../model/recurso.dart';

class FirebaseDataSource {
  // Helper function to get the currently authenticated user
  User get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('Not authenticated exception');
    return user;
  }

  FirebaseFirestore get firestore => FirebaseFirestore.instance;
  FirebaseStorage get storage => FirebaseStorage.instance;

  // Generates and returns a new firestore id
  String newId() {
    return firestore.collection('tmp').doc().id;
  }

  // Read all documents from Recurso collection from the authenticated user
  Stream<Iterable<Recurso>> getRecursos() {
    return firestore
        .collection('user/${currentUser.uid}/recurso')
        .snapshots()
        .map((it) => it.docs.map((e) => Recurso.fromFirebaseMap(e.data())));
  }

  // Creates or updates a document in Recurso collection. If image is not null
  // it will create or update the image in Firebase Storage
  Future<void> saveRecurso(Recurso recurso, File? image, File? logo) async {
    final ref = firestore.doc('user/${currentUser.uid}/recurso/${recurso.id}');
    if (image != null && logo !=null) {
      // Delete current image if exists
      if (recurso.image != null && recurso.logo !=null) {
        await storage.refFromURL(recurso.image! + recurso.logo!).delete();
        
      }
      final fileLogo = logo.uri.pathSegments.last;
      final fileName = image.uri.pathSegments.last;
      final imagePath = '${currentUser.uid}/recursosImages/$fileName';
      final logoPath = '${currentUser.uid}/recursosImages/$fileLogo';

      final storageRef = storage.ref(imagePath);
      final storageRefLogo = storage.ref(logoPath);

      await storageRef.putFile(image);
      await storageRefLogo.putFile(logo);

      final url = await storageRef.getDownloadURL();
      final urlLogo = await storageRefLogo.getDownloadURL();

      recurso = recurso.copyWith(image: url);
      recurso = recurso.copyWith(logo: urlLogo);
    }
    await ref.set(recurso.toFirebaseMap(), SetOptions(merge: true));
  }

  // Deletes the Recurso document. Also will delete the
  // image from Firebase Storage
  Future<void> deleteRecurso(Recurso recurso) async {
    final ref = firestore.doc('user/${currentUser.uid}/recurso/${recurso.id}');

    // Delete current image if exists
    if (recurso.image != null && recurso.logo !=null) {
      await storage.refFromURL(recurso.image!).delete();
      await storage.refFromURL(recurso.logo!).delete();
    }
    await ref.delete();
  }
}
