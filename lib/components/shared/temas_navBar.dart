import 'package:flutter/material.dart';
import 'package:uth_request_flutter_application/components/peticiones/views/peticiones_community_view.dart';
import 'package:uth_request_flutter_application/components/utils/color.dart';
import 'package:uth_request_flutter_application/components/utils/string.dart';

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
            Center(
              child: Text('Pagina de Temas :)', style: TextStyle(fontSize: 20)),
            ),
            PeticionesCommunityView(),
          ],
        ),
      ),
    );
  }
}
