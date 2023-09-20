import 'package:equatable/equatable.dart';


// Extending Equatable will help us to compare two instances of
// Recurso class and we will not have to override == and hashCode.
class Recurso extends Equatable {
  final String id;
  final String nombre;
  final String tipo;
  final String lugar;
  final String validez;
  final String? logo;

  final String? image;

  const Recurso({
    required this.id,
    required this.nombre,
    required this.lugar,
    required this.validez,
    required this.tipo,
    this.image,
    this.logo,
  });

  // When comparing two instances of Recurso class we want to check
  // that all the properties are the same, then we can say that
  // the two instances are equals
  @override
  List<Object?> get props => [id, nombre ,tipo, validez, lugar, logo, image];

  // Helper function to convert this Recurso to a Map
  Map<String, Object?> toFirebaseMap() {
    return <String, Object?>{
      'id': id,
      'nombre': nombre,
      'lugar': lugar,
      'tipo': tipo,
      'validez': validez,
      'imagen': image,
      'logo': logo,
    };
  }

  // Helper function to convert a Map to an instance of Recurso
  Recurso.fromFirebaseMap(Map<String, Object?> data)
      : id = data['id'] as String,
        nombre = data['nombre'] as String,
        lugar = data['lugar'] as String,
        tipo = data['tipo'] as String,
        validez = data['validez'] as String,
        logo = data['logo'] as String?,
        image = data['imagen'] as String?;


  // Helper function that updates some properties of this instance,
  // and returns a new updated instance of Recurso
  Recurso copyWith({
    String? id,
    String? nombre,
    String? tipo,
    String? lugar,
    String? validez,
    String? imagen,
    String? logo,
    String? image,
  }) {
    return Recurso(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      tipo: tipo ?? this.tipo,
      lugar: lugar ?? this.lugar,
      validez: validez ?? this.validez,
      logo: logo ?? this.logo,
      image: image ?? this.image,
    );
  }
}
