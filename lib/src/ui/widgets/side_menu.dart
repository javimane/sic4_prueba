


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sic4change_prueba/src/navigation/routes.dart';


import '../../app.dart';
import 'custom_filled_button.dart';


// import 'package:go_router/go_router.dart';


class SideMenu extends ConsumerStatefulWidget {

  final GlobalKey<ScaffoldState> scaffoldKey;
  
  User get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('Not authenticated exception');
    return user;
  }
 

   const SideMenu({
    super.key, 
    required this.scaffoldKey
  });

  @override
  SideMenuState createState() => SideMenuState();
}

class SideMenuState extends ConsumerState<SideMenu> {

  int navDrawerIndex = 0;

  @override
  Widget build(BuildContext context) {

    final hasNotch = MediaQuery.of(context).viewPadding.top > 35;
    final textStyles = Theme.of(context).textTheme;
   // final goRouterNotifier = ref.read(goRouterNotifierProvider);
   // final authStatus = goRouterNotifier.authStatus;

    return NavigationDrawer(
      elevation: 1,
      selectedIndex: navDrawerIndex,
      onDestinationSelected: (value) {

        setState(() {
          navDrawerIndex = value;
        });

        // final menuItem = appMenuItems[value];
        // context.push( menuItem.link );
        widget.scaffoldKey.currentState?.closeDrawer();

      },
      children: [

        Padding(
          padding: EdgeInsets.fromLTRB(20, hasNotch ? 0 : 20, 16, 0),
          child: Text('Saludos', style: textStyles.titleMedium ),
        ),

        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 16, 10),
          child: Text('Usuario', style: textStyles.titleSmall ),
        ),

        const NavigationDrawerDestination(
            icon: Icon( Icons.home_outlined ), 
            label: Text( 'Organizaciones' ),
        ),


        const Padding(
          padding: EdgeInsets.fromLTRB(28, 16, 28, 10),
          child: Divider(),
        ),

        const Padding(
          padding: EdgeInsets.fromLTRB(28, 10, 16, 10),
          child: Text('Otras opciones'),
        ),
          Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: CustomFilledButton(
            onPressed: () {   
             Navigator.pushNamed(context, Routes.inicio);   
            },
            text: 'Inicio'
          ),
        ),
         const SizedBox(height: 5,),
       if(FirebaseAuth.instance.currentUser?.uid != null)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: CustomFilledButton(
            onPressed: () {
               
             ref.read(authProvider);
             final authNotifier = ref.read(authProvider.notifier);
              authNotifier.signOut();
              
            },
            text: 'Cerrar sesión'
          ),
        ),  
      if(FirebaseAuth.instance.currentUser?.uid == null)
         Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: CustomFilledButton(
            onPressed: () {
               
             Navigator.pushNamed(context, Routes.login);
            },
            text: 'Iniciar Sesión'
          ),
        ), 
         
      ]
    );
  }
}