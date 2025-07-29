
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


class HomePage extends StatelessWidget {
  HomePage({super.key});

  final NavigationController navController = Get.put(NavigationController());

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
          title: Column(children: [
            Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(usuario),
              Icon(Icons.person)
            ],
            
          ),

          ],),
          
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.primaryLight,
            
           ),
          

        body: paginas[navController.selectedIndex.value],
        drawer: MenuDrawer(),
        
        
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: AppColors.primarySecondary,
          selectedItemColor: AppColors.selectedItem,
          unselectedItemColor: AppColors.nonSelectedItem,
          currentIndex: navController.selectedIndex.value,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.list), label: "peticiones"),
            BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Comunidad'),
            BottomNavigationBarItem(
              icon: Icon(Icons.campaign),
              label: 'Anuncios',
              
            ),
          ],
          
          onTap: navController.changePage,
          
        ),
        floatingActionButton: FloatingActionButton(onPressed: (){}, 
        
        backgroundColor: AppColors.primaryVariant,

         child: Icon(Icons.add_box, color: AppColors.onBackgroundDefault,),
         
          ),
          
      ),
      
    );
  }

  
}


