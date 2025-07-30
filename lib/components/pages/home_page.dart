import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:uth_request_flutter_application/components/notificaciones/views/notificacionesVista.dart';
import 'package:uth_request_flutter_application/components/shared/menu_drawer.dart';
import 'package:uth_request_flutter_application/components/shared/navigation_controller.dart';
import 'package:uth_request_flutter_application/components/shared/peticiones_navBar.dart';
import 'package:uth_request_flutter_application/components/shared/temas_navBar.dart';
import 'package:uth_request_flutter_application/components/utils/color.dart';
import 'package:uth_request_flutter_application/components/utils/string.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final NavigationController navController = Get.put(NavigationController());

  bool showExtraButtons = false;

  final List<Widget> paginas = [
    PeticionesPage(),
    TemasPage(),
    Notificacionesvista(),
  ];

  @override
  Widget build(BuildContext context) {
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
                        usuario,
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
          ],

          onTap: navController.changePage,
        ),
        floatingActionButton: navController.selectedIndex.value == 2
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
                          onPressed: () {},
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
                          onPressed: () {},
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
                      setState(() {
                        showExtraButtons = !showExtraButtons;
                      });
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
}
