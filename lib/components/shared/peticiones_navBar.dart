import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uth_request_flutter_application/components/utils/color.dart';
class PeticionesPage extends StatelessWidget {
  const PeticionesPage({super.key});

  @override
  Widget build(BuildContext context) {
 
    return DefaultTabController(
      length: 2, 
      child: Scaffold(
        
        
        appBar: AppBar(
         toolbarHeight: 0,
         backgroundColor: AppColors.nonSelectedItem,
         foregroundColor: AppColors.primaryLight,
          bottom: TabBar(
          
            tabs: const [
            Tab(child: Text('Mis peticiones', style: TextStyle(color: AppColors.primaryLight,fontSize: 20)),),
            Tab(child: Text('De acuerdo', style: TextStyle(color: AppColors.primaryLight, fontSize: 20,),),),
          ],
           indicator: BoxDecoration(
              color: AppColors.primaryVariant,
             
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: AppColors.primaryLight

         
          ),

          
        
        ),
        body: const TabBarView(
          children: [
            Center(child: Text('Peticiones Pendientes', style: TextStyle(fontSize: 20))),
            Center(child: Text('Peticiones Aprobadas', style: TextStyle(fontSize: 20))),
            
          ],
        ),
      ),
    );
  }
}