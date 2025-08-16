import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:uth_request_flutter_application/components/componentsAdmin/panelControl/views/panelControl.dart';
import 'package:uth_request_flutter_application/components/notificaciones/views/notificacionesVista.dart';
import 'package:uth_request_flutter_application/components/peticiones/views/createRequest.dart';
import 'package:uth_request_flutter_application/components/shared/menu_drawer.dart';
import 'package:uth_request_flutter_application/components/shared/navigation_controller.dart';
import 'package:uth_request_flutter_application/components/peticiones/views/mis_peticiones_view.dart';
import 'package:uth_request_flutter_application/components/shared/temas_navBar.dart';
import 'package:uth_request_flutter_application/components/utils/color.dart';
import 'package:uth_request_flutter_application/components/utils/notificaciones.dart';
import 'package:uth_request_flutter_application/components/utils/string.dart';
import 'package:uth_request_flutter_application/temas/views/crearTema.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final NavigationController navController = Get.put(NavigationController());

  bool showExtraButtons = false;

  String nombre = '';
  String apellido = '';
  String cuenta = '';
  String rol = '';

  late List<Widget> paginas;

  @override
  void initState() {
    super.initState();
    _obtenerDatosStorage();
    var uid = GetStorage().read('uid');
    if (uid != null) {
      Notificaciones().guardarToken(uid);
    } else {
      print("UID no encontrado en el storage");
    }
  }

  @override
  Widget build(BuildContext context) {
    paginas = [MisPeticionesView(), TemasPage(), Notificacionesvista()];

    if (rol.toLowerCase() == "administrador") {
      paginas.add(PanelControl());
    }

    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 200,
                    child: Flexible(
                      child: Text(
                        '$nombre $apellido',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),

                  SizedBox(width: 10),
                  Icon(Icons.person, size: 30),
                ],
              ),
            ],
          ),
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onSurface,
        ),

        body: paginas[navController.selectedIndex.value],
        drawer: MenuDrawer(),

        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.primary,
          selectedItemColor: AppColors.selectedItem,
          unselectedItemColor: AppColors.nonSelectedItem,
          selectedFontSize: 16,
          unselectedFontSize: 14,
          currentIndex: navController.selectedIndex.value,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt_outlined),
              activeIcon: Icon(Icons.list_alt),
              label: peticiones,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outlined),
              activeIcon: Icon(Icons.people_alt),
              label: comunidad,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.campaign_outlined),
              activeIcon: Icon(Icons.campaign),
              label: anuncios,
            ),
            if (rol.toLowerCase() == "administrador")
              BottomNavigationBarItem(
                icon: Icon(Icons.admin_panel_settings_outlined),
                activeIcon: Icon(Icons.admin_panel_settings),
                label: "Gestiones",
              ),
          ],

          onTap: navController.changePage,
        ),
        floatingActionButton: navController.selectedIndex.value == 2 || navController.selectedIndex.value == 3
            ? null
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (navController.selectedIndex.value == 1 &&
                      showExtraButtons) ...[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            'CREAR TEMA',
                            style: TextStyle(
                              color: AppColors.onPrimaryText,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        FloatingActionButton(
                          heroTag: 'CREAR TEMA',
                          onPressed: () {
                            Get.to(
                              CrearTemaPage(
                                comentario: false,
                              ),
                              transition: Transition.rightToLeftWithFade,
                            );
                          },
                          backgroundColor: AppColors.primaryVariant,
                          mini: true,
                          shape: CircleBorder(),
                          child: Icon(Icons.edit, color: AppColors.onSurface),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            'CREAR PETICIÓN',
                            style: TextStyle(
                              color: AppColors.onPrimaryText,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        FloatingActionButton(
                          heroTag: 'CREAR PETICION',
                          onPressed: () {
                            Get.to(
                              CreateRequest(),
                              transition: Transition.rightToLeftWithFade,
                            );
                          },
                          backgroundColor: AppColors.primaryVariant,
                          mini: true,
                          shape: CircleBorder(),
                          child: Icon(
                            Icons.list_alt,
                            color: AppColors.onSurface,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                  ],
                  FloatingActionButton(
                    heroTag: 'MAS',
                    onPressed: () {
                      if (navController.selectedIndex.value == 0) {
                        Get.to(
                          CreateRequest(),
                          transition: Transition.rightToLeftWithFade,
                        );
                      } else {
                        setState(() {
                          showExtraButtons = !showExtraButtons;
                        });
                      }
                    },
                    backgroundColor: AppColors.primarySecondary,
                    shape: CircleBorder(),
                    child: navController.selectedIndex.value == 0
                        ? Icon(
                            Icons.list_alt_outlined,
                            color: AppColors.onSurface,
                          )
                        : Icon(
                            showExtraButtons ? Icons.close : Icons.add,
                            color: AppColors.onSurface,
                          ),
                  ),
                ],
              ),
      ),
    );
  }

  void _obtenerDatosStorage() {
    final storage = GetStorage();

    setState(() {
      nombre = storage.read('nombre') ?? '';
      apellido = storage.read('apellido') ?? '';
      cuenta = storage.read('cuenta') ?? '';
      rol = storage.read('rol') ?? '';
    });

    print('Nombre: $nombre');
    print('Apellido: $apellido');
  }
}
