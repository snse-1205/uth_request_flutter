import 'package:flutter/material.dart';
import 'package:uth_request_flutter_application/components/componentsAdmin/catalogos/views/crearCampus.dart';
import 'package:uth_request_flutter_application/components/componentsAdmin/catalogos/views/listarCampus.dart';
import 'package:uth_request_flutter_application/components/utils/color.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:uth_request_flutter_application/components/utils/string.dart';

class CrudCampus extends StatelessWidget {
  const CrudCampus({super.key});

  @override
  Widget build(BuildContext context) {
    // Tema local para estilizar AppBar/TabBar sin tocar el tema global
    final ThemeData base = Theme.of(context);
    
    final ThemeData themed = base.copyWith(
      scaffoldBackgroundColor: AppColors.onBackgroundDefault,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      tabBarTheme: const TabBarThemeData(
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.nonSelectedNavbar,
        labelStyle: TextStyle(fontWeight: FontWeight.w700),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        indicator: BoxDecoration(
          color: AppColors.primarySecondary,
          borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
        ),
      ),
    );

    return Theme(
      data: themed,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: AppColors.onBackgroundDefault,
          appBar: AppBar(
            title: Text(CrudCampus_TabCrear),
            bottom: const PreferredSize(
              preferredSize: Size.fromHeight(48),
              child: ColoredBox(
                color: AppColors.primary, // barra detrás de las tabs
                child: TabBar(
                  tabs: [
                    Tab(text: 'Crear'),
                    Tab(text: 'Listar'),
                  ],
                  dividerColor: Colors.transparent,
                ),
              ),
            ),
          ),
          body: TabBarView(children: [AgregarCampusTab(), ListarCampusTab()]),
        ),
      ),
    );
  }
}