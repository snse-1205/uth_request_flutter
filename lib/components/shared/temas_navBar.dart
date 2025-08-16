import 'package:flutter/material.dart';
import 'package:uth_request_flutter_application/components/peticiones/views/peticiones_community_view.dart';
import 'package:uth_request_flutter_application/components/utils/color.dart';
import 'package:uth_request_flutter_application/components/utils/string.dart';
import 'package:uth_request_flutter_application/temas/views/comunidad_vista.dart';

class TemasPage extends StatelessWidget {
  const TemasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          backgroundColor: AppColors.nonSelectedNavbar,
          foregroundColor: AppColors.selectedNavbar,
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text(
                  textTemas,
                  style: TextStyle(color: AppColors.onSurface, fontSize: 16),
                ),
              ),
              Tab(
                child: Text(
                  textPeticiones,
                  style: TextStyle(color: AppColors.onSurface, fontSize: 16),
                ),
              ),
            ],
            indicator: BoxDecoration(color: AppColors.selectedNavbar),
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: AppColors.primaryLight,
          ),
        ),
        body: const TabBarView(
          children: [
            ListaTemasPage(),
            PeticionesCommunityView(),
          ],
        ),
      ),
    );
  }
}
