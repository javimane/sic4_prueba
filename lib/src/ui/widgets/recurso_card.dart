import 'package:flutter/material.dart';


import '../../model/recurso.dart';

class RecursoCard extends StatelessWidget {

  final Recurso recurso;

  const RecursoCard({
    super.key, 
    required this.recurso
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30),
        _ImageViewer( recursoImage: recurso),
        Text( recurso.nombre, textAlign: TextAlign.center, 
        style:const TextStyle( fontWeight: FontWeight.bold , fontSize: 20) , 
        ),
       
        const SizedBox(height: 25)
      ],
    );
  }
}

class _ImageViewer extends StatelessWidget {

  final Recurso recursoImage;

  const _ImageViewer({ required this.recursoImage });

  @override
  Widget build(BuildContext context) {
    
    if ( recursoImage.image!.isEmpty ) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset('assets/no-image.jpg', 
          fit: BoxFit.cover,
          height: 250,
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: FadeInImage(
        fit: BoxFit.cover,
        height: 150,
        fadeOutDuration: const Duration(milliseconds: 100),
        fadeInDuration: const Duration(milliseconds: 200),
        image: NetworkImage(recursoImage.logo!),
        placeholder: const AssetImage('assets/cargando.gif'),
      ),
    );

  }
}