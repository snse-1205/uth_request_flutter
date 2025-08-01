import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uth_request_flutter_application/components/auth/login/controllers/inicio_sesion_controller.dart';
import 'package:uth_request_flutter_application/components/shared/navigation_controller.dart';
import 'package:uth_request_flutter_application/components/utils/color.dart';
import 'package:uth_request_flutter_application/components/utils/string.dart';

class MenuDrawer extends StatelessWidget {
  MenuDrawer({super.key});

  final NavigationController navController = Get.find<NavigationController>();

  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.find<AuthController>();
    return Drawer(
      backgroundColor: AppColors.onBackgroundDefault,
      child: ListView(
        children: [
          SizedBox(
            height: 150,
            child: Container(
            padding: EdgeInsetsGeometry.all(10),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset('assets/logo_UTH_verde.png', height: 80),
                  SizedBox(height: 8),
                  Text(
                    textComunidadUth,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          Divider(color: AppColors.onLineDivider, thickness: 2),
          ListTile(
            leading: Icon(Icons.list),
            title: Text(peticiones),
            selectedColor: AppColors.primaryVariant,
            selected: navController.selectedIndex.value == 0,
            onTap: () {
              navController.changePage(0);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.people),
            title: Text(comunidad),
            selectedColor: AppColors.primaryVariant,
            selected: navController.selectedIndex.value == 1,
            onTap: () {
              navController.changePage(1);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.campaign),
            title: Text(anuncios),
            selectedColor: AppColors.primaryVariant,
            selected: navController.selectedIndex.value == 2,
            onTap: () {
              navController.changePage(2);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.logout_outlined),
            title: Text("Cerrar Sesion"),
            onTap: () {
              authController.cerrarSesion();
            },
          ),
        ],
      ),
    );
  }
}
