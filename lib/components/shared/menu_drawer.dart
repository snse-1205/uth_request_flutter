import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uth_request_flutter_application/components/shared/navigation_controller.dart';
import 'package:uth_request_flutter_application/components/utils/string.dart';



class MenuDrawer extends StatelessWidget {
  
  MenuDrawer({super.key});

  final NavigationController navController = Get.find<NavigationController>();


  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.list),
            title: Text(peticiones),
            onTap: () {
              navController.changePage(0);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.people),
            title: Text(comunidad),
            onTap: () {
              navController.changePage(1);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.campaign),
            title: Text(anuncios),
            onTap: () {
              navController.changePage(2);
              Navigator.pop(context);
            },
          ),
          
        ],
      ),
    );
  }
}
