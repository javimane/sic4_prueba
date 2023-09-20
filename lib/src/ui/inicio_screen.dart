import 'dart:io';

import 'package:connectivity_checker/connectivity_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_3d_choice_chip/flutter_3d_choice_chip.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sic4change_prueba/src/ui/widgets/side_menu.dart';


import 'items/menu_items.dart';

class InicioScreen extends ConsumerWidget {
  const InicioScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Obtener el estado de la conexión a Internet
    

    // Crear una clave para el scaffold
    final scaffoldKey = GlobalKey<ScaffoldState>();

    // Obtener el tamaño de la pantalla
    final size = MediaQuery.of(context).size;
    
    // Construir el scaffold principal
    return Scaffold(
      // Agregar un drawer (menú lateral) al scaffold
      drawer: SideMenu(scaffoldKey: scaffoldKey),
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Center(
            child: Padding(
              padding: EdgeInsets.only(right: 50), // Ajusta el valor según tu preferencia
                child: Text('Bienvenido'),
            ),
          ),

      ),
      // Contenedor con una imagen de fondo
      body: ConnectivityWidgetWrapper(
        disableInteraction: true,
        alignment: Alignment.topCenter,
        message: 'No estas conectado a internet',
        
          child: Container(
            width: size.width,
            height: size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/fondo-blanco.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
            // Builder para mostrar el AlertDialog según el estado de conexión

            // Mostrar el contenido normal de _HomeView
            child: const _HomeView(),
          ),
        )
      );
   
  }
 
}



// Clase _HomeView que muestra la lista de elementos en la pantalla principal
class _HomeView extends StatefulWidget {
  const _HomeView();
  @override
  _HomeViewState createState() => _HomeViewState();
}

// Estado de _HomeView
class _HomeViewState extends State<_HomeView> {
  final ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Construir una lista desplazable con elementos de la lista appMenuItems
    return ListView.builder(
      controller: scrollController,
      itemCount: appMenuItems.length,
      itemBuilder: (context, index) {
        final menuItem = appMenuItems[index];

        // Construir un ListTile personalizado para cada elemento de la lista
        return _CustomListTile(menuItem: menuItem);
      },
    );
  }
}

// Widget que representa un ListTile personalizado
class _CustomListTile extends StatelessWidget {
  const _CustomListTile({
    required this.menuItem,
  });

  final MenuItem menuItem;

  @override
  Widget build(BuildContext context) {
   // final colors = Theme.of(context).colorScheme;
 final size = MediaQuery.of(context).size;
 return Container(
      margin: const EdgeInsets.all(15),
      child: ChoiceChip3D(
         
        height: (size.height) * 0.2,
        width:  kIsWeb ? ( size.width >600 ? (size.width)*0.30 : (size.width) * 0.60) : (size.width) * 0.70 ,
        style: ChoiceChip3DStyle(
          topColor: const Color.fromARGB(255, 206, 201, 201),
          backColor: const Color.fromARGB(255, 34, 29, 29),
          borderRadius: BorderRadius.circular(32)
        ),
        selected: false,
        child: Column(
          children: [
            const SizedBox(height: 40,),
            menuItem.icon,
            const SizedBox(height: 5),
            Text(menuItem.title, style: const TextStyle(fontSize: 25, color: Colors.black)),
          ],
        ),
        onSelected: () {
            // Navegar a la página siguiente
          if (FirebaseAuth.instance.currentUser?.uid != null) {
            Navigator.pushNamed(context, menuItem.link);
          } else {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Iniciar sesión'),
                content: const Text('Debes iniciar sesión para acceder a esta página.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Aceptar'),
                  ),
                ],
              ),
            );
          }
        },
        onUnSelected: (){},
      ),
    );

 
        }
  
    
}