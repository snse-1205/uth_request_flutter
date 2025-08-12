import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:uth_request_flutter_application/components/componentsAdmin/catalogos/views/crearCampus.dart';
import 'package:uth_request_flutter_application/components/utils/string.dart';

class CrudCampus extends StatelessWidget {
  const CrudCampus({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: DefaultTabController(
        length: 2, 
        child: Scaffold(
          appBar: AppBar(title: Text(CrudCampus_TabCrear),
          bottom: TabBar(tabs: [
            Tab(text: CrudCampus_TabCrear,),
            Tab(text: CrudCampus_TabListar,),
          ]),
          ),
          body: TabBarView(children: [
            AgregarCampusTab(),
            //tab 2
          ]),
        ) 
      )
      );
  }
}