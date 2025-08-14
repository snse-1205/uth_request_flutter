import 'package:flutter/material.dart';
import 'package:uth_request_flutter_application/components/componentsAdmin/catalogos/views/crearClase.dart';
import 'package:uth_request_flutter_application/components/componentsAdmin/catalogos/views/vincularClaseCarreras.dart';
import 'package:uth_request_flutter_application/components/utils/color.dart';
import 'package:uth_request_flutter_application/components/utils/string.dart';

class CrudClases extends StatelessWidget {
  const CrudClases({super.key});

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context);
    final themed = base.copyWith(
      scaffoldBackgroundColor: AppColors.onBackgroundDefault,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
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
            title: const Text("Clases"),
            bottom: const PreferredSize(
              preferredSize: Size.fromHeight(48),
              child: ColoredBox(
                color: AppColors.primary,
                child: TabBar(
                  tabs: [Tab(text: 'Crear'), Tab(text: 'Vincular')],
                  dividerColor: Colors.transparent,
                ),
              ),
            ),
          ),
          body: const TabBarView(
            children: [CrearClaseTab(), VincularClaseCarrerasTab()],
          ),
        ),
      ),
    );
  }
}
