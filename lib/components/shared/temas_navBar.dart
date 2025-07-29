import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uth_request_flutter_application/components/utils/color.dart';
class TemasPage extends StatelessWidget {
  const TemasPage({super.key});

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
            Tab(child: Text('TEMAS', style: TextStyle(color: AppColors.primaryLight,fontSize: 20)),),
            Tab(child: Text('PETICIONES', style: TextStyle(color: AppColors.primaryLight, fontSize: 20,),),),
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
            Center(child: Text('Pagina de Temas :)', style: TextStyle(fontSize: 20))),
            Center(child: Text('Pagina de peticiones :3', style: TextStyle(fontSize: 20))),
            
          ],
        ),
      ),
    );
  }
}