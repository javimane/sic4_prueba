import 'dart:io';

import 'package:connectivity_checker/connectivity_checker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:image_picker/image_picker.dart';

import '../model/recurso.dart';

import '../notifiers/edit_my_user_notifier.dart';
import 'widgets/custom_image.dart';

final editRecursoProvider =
    ChangeNotifierProvider.family<EditRecursoNotifier, Recurso?>((ref, recurso) {
  return EditRecursoNotifier(recurso);
});

class EditRecursoScreen extends ConsumerWidget {
  const EditRecursoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final recursoToEdit = ModalRoute.of(context)?.settings.arguments as Recurso?;

    final homeScreen = ref.watch(editRecursoProvider(recursoToEdit));
    ref.listen<EditRecursoNotifier>(editRecursoProvider(recursoToEdit),
        (previous, next) {
      if (next.isDone) {
        Navigator.of(context).pop();
      }
    });

    return ConnectivityWidgetWrapper(
      disableInteraction: true,
      alignment: Alignment.topCenter,
      message: 'No estas conectado a internet',
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('Edit or Create recurso'),
          actions: [
            Builder(builder: (context) {
              return Visibility(
                visible: recursoToEdit != null,
                child: IconButton(
                  key: const Key('Delete'),
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                   showAdaptiveDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => AlertDialog.adaptive(
                      insetAnimationCurve: Curves.bounceIn,
                      title: const Text("Delete", textAlign: TextAlign.center,),
                      content: const Text("Do you accept?", textAlign: TextAlign.center,),
                      actions: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context, 'Aceptar');
                                homeScreen.deleteRecurso();
                              },
                              style: TextButton.styleFrom(
                                textStyle: const TextStyle(fontSize: 16),
                                minimumSize: const Size(88, 36),
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  side: const BorderSide(color: Colors.green),
                                ),
                              ),
                              child: const Text('Aceptar'),
                            ),
                           const SizedBox(width: 10,),
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              style: TextButton.styleFrom(
                                textStyle: const TextStyle(fontSize: 16),
                                minimumSize: const Size(88, 36),
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  side: const BorderSide(color: Colors.red),
                                ),
                              ),
                              child: const Text('Cancel'),
                            ),
                          ],
                        ),
                      ],
                      shape:
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
                          elevation: 30.0,
                    ),
                  );    
                    
                  },
                ),
              );
            }),
          ],
        ),
        body: Container(
          alignment: kIsWeb ? Alignment.topCenter : null,
        // width:  kIsWeb ? ( size.width >600 ? (size.width)*0.50 : (size.width) * 0.60) : (size.width) * 0.90 ,
          child: Stack(
            
            children: [
              _RecursoSection(
                recurso: recursoToEdit,
                pickedImage: homeScreen.pickedImage,
                pickedLogo: homeScreen.pickedLogo,
                isSaving: homeScreen.isLoading,
              ),
              if (homeScreen.isLoading)
                Container(
                  color: Colors.black12,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecursoSection extends ConsumerStatefulWidget {
  final Recurso? recurso;
  final File? pickedImage;
  final File? pickedLogo;
  final bool isSaving;

  const _RecursoSection({this.recurso, this.pickedImage,this.pickedLogo, this.isSaving = false});

  @override
  _RecursoSectionState createState() => _RecursoSectionState();
}

class _RecursoSectionState extends ConsumerState<_RecursoSection> {
  final _nameController = TextEditingController();
  final _tipoController = TextEditingController();
  final _lugarController = TextEditingController();
  final _validezController = TextEditingController();
  final picker = ImagePicker();

  @override
  void initState() {
    _nameController.text = widget.recurso?.nombre ?? '';
    _tipoController.text = widget.recurso?.tipo ?? '';
    _lugarController.text = widget.recurso?.lugar ?? '';
    _validezController.text = widget.recurso?.validez ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
                child: Container(
                 width:  kIsWeb ? ( size.width >600 ? (size.width)*0.50 : size.width) : size.width ,
                alignment: Alignment.centerRight,
              padding: const EdgeInsets.all(16),
              child: Column(
                
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  
                   Stack(
                    
                  alignment: Alignment.center,
                  children:[ 
                    SizedBox(
                        width: size.width,   //kIsWeb ? ( size.width >600 ? (size.width)*0.70 : (size.width) * 0.60) : (size.width) * 0.70 ,
                        height: 300,
                        
                        ),

                    Positioned(
                      top: 0,
                      child: GestureDetector(
                        onTap: () async {
                          final editRecurso = ref.read(editRecursoProvider(widget.recurso));
                          final pickedImage = await picker.pickImage(source: ImageSource.gallery);
                          if (pickedImage != null) {
                            editRecurso.setImage(File(pickedImage.path));
                          }
                        },
                        child: Center(
                          child: SizedBox(
                            width: size.width,
                            height: 200,
                            child: CustomImage(
                              imageFile: widget.pickedImage,
                              imageUrl: widget.recurso?.image,
                              boxFit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  
                       Positioned(
                        bottom: 8,
                        child: GestureDetector(
                          onTap: () async {
                            final editRecurso = ref.read(editRecursoProvider(widget.recurso));
                            final pickedLogo = await picker.pickImage(source: ImageSource.gallery);
                            if (pickedLogo != null) {
                              editRecurso.setLogo(File(pickedLogo.path));
                            }
                          },
                          child: Center(
                             
                              child: Container(
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black,
                                        blurRadius: 2.0,
                                        spreadRadius: 2.0,
                                      )
                                    ],
                                  ),
                                child: ClipOval(
                                  child: SizedBox(
                                    width: 150,
                                    height: 150,
                                    
                                    child: CustomImage(
                                      boxFit: BoxFit.cover,
                                      imageFile: widget.pickedLogo,
                                      imageUrl: widget.recurso?.logo,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                       ],
                      ),
                
            const SizedBox(height: 8),
            TextFormField(
              key: const Key('Nombre'),
              controller: _nameController,
              validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo Requerido';
                  }
                  return null;
                },
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 8),
            TextFormField(
              key: const Key('Tipo'),
              controller: _tipoController,
              validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo Requerido';
                  }
                  return null;
                },
              decoration: const InputDecoration(labelText: 'Tipo'),
            ),
            const SizedBox(height: 8),
             TextFormField(
              key: const Key('Lugar'),
              controller: _lugarController,
              validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo Requerido';
                  }
                  return null;
                },
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(labelText: 'Lugar'),
            ),
            const SizedBox(height: 8),
            TextFormField(
              key: const Key('Validez'),
              controller: _validezController,
              validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo Requerido';
                  }
                  return null;
                },
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(labelText: 'Validez'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: widget.isSaving
                  ? null
                  : () {
                      ref.read(editRecursoProvider(widget.recurso)).saveRecurso(
                            _nameController.text,
                            _tipoController.text,
                            _lugarController.text,
                            _validezController.text
                          );
                    },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
