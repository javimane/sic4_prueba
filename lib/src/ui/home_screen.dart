import 'package:connectivity_checker/connectivity_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sic4change_prueba/src/ui/widgets/recurso_card.dart';
import 'package:sic4change_prueba/src/ui/widgets/side_menu.dart';


import '../navigation/routes.dart';
import '../notifiers/home_notifier.dart';


final homeScreenProvider =
    ChangeNotifierProvider((ref) => HomeNotifier()..init());

class HomeScreen extends ConsumerWidget {
  const  HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
// Crear una clave para el scaffold
final ScrollController scrollController = ScrollController();
    final scaffoldKey = GlobalKey<ScaffoldState>();
    final size = MediaQuery.of(context).size;
    final homeScreen = ref.watch(homeScreenProvider);

    return ConnectivityWidgetWrapper(
      disableInteraction: true,
      alignment: Alignment.topCenter,
      message: 'No estas conectado a internet',
      child: Scaffold(
        drawer: SideMenu(scaffoldKey: scaffoldKey),
        key: scaffoldKey,
         appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Center(
            child: Padding(
              padding: EdgeInsets.only(right: 50), // Ajusta el valor según tu preferencia
                child: Text('Recursos'),
            ),
          ),

      ),

        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.pushNamed(context, Routes.editUser);
          },
        ),
        body: ListView.builder(
          controller: scrollController,
          physics: const BouncingScrollPhysics(),
          itemCount: homeScreen.recursos.length ,
          itemBuilder: (context, index) {
            
            final recurso = homeScreen.recursos.elementAt(index);
             if(FirebaseAuth.instance.currentUser?.uid != null) {
               return GestureDetector(
                  onTap: () => 
                  
                  Navigator.pushNamed(context, Routes.editUser,
                      arguments: recurso),
                  child: RecursoCard(recurso: recurso),
                );
             }
            
        
          }
        ),
      ),
    );
  }
}
