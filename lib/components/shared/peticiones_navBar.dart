import 'package:flutter/material.dart';
import 'package:uth_request_flutter_application/components/peticiones/views/mis_peticiones_view.dart';
import 'package:uth_request_flutter_application/components/peticiones/views/otras_peticiones_view.dart';
import 'package:uth_request_flutter_application/components/utils/color.dart';
import 'package:uth_request_flutter_application/components/utils/string.dart';

class PeticionesPage extends StatelessWidget {
  const PeticionesPage({super.key});

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
                  textMisPeticiones,
                  style: TextStyle(color: AppColors.onSurface, fontSize: 16),
                ),
              ),
              Tab(
                child: Text(
                  textDeAcuerdo,
                  style: TextStyle(color: AppColors.onSurface, fontSize: 16),
                ),
              ),
            ],
            indicator: BoxDecoration(color: AppColors.selectedNavbar),
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: AppColors.onSurface,
          ),
        ),
        body: const TabBarView(
          children: [
            Center(
              child: MisPeticionesView(),
            ),
            Center(
              child: OtrasPeticionesView(),
            ),
          ],
        ),
      ),
    );
  }
}
