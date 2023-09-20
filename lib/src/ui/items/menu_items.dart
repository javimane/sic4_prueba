import 'package:flutter/material.dart';

import '../../navigation/routes.dart';


// Clase que representa un elemento del menú
class MenuItem {
  final String title; // Título del elemento del menú
  final String link; // Ruta a la que se redirige al tocar el elemento
  final ImageIconWidget icon; // Ícono del elemento del menú

  // Constructor de la clase MenuItem
  const MenuItem({
    required this.title,
    required this.link,
    required this.icon,
  });
}

// Lista de elementos del menú de la aplicación
const appMenuItems = <MenuItem>[
  // Elemento "Characters" con su título, ruta y un ícono personalizado
  MenuItem(
    title: 'Recursos',
    link:  Routes.home,
    icon: ImageIconWidget(
      imagePath: 'assets/wired-lineal-21-avatar.gif',
      size: 80.0,
    ),
  ),

  // Elemento "Episodes" con su título, ruta y un ícono personalizado
  MenuItem(
    title: '',
    link: '',
    icon: ImageIconWidget(
      imagePath: 'assets/novedad.gif',
      size: 90.0,
    ),
  ),
];

// Widget que representa un ícono personalizado
class ImageIconWidget extends StatelessWidget {
  final String imagePath; // Ruta de la imagen del ícono
  final double size; // Tamaño del ícono

  // Constructor del widget ImageIconWidget
  const ImageIconWidget({
    super.key,
    required this.imagePath,
    this.size = 25.0,
  });

  @override
  Widget build(BuildContext context) {
    // Construir un SizedBox que contiene la imagen del ícono
    return SizedBox(
      width: size,
      height: size,
      child: Image.asset(
        imagePath,
      ),
    );
  }
}
