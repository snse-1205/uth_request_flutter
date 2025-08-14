import 'package:flutter/material.dart';
import 'package:uth_request_flutter_application/components/componentsAdmin/catalogos/controllers/campusController.dart';
import 'package:uth_request_flutter_application/components/componentsAdmin/catalogos/models/campusModel.dart';
import 'package:uth_request_flutter_application/components/utils/color.dart';

class ListarCampusTab extends StatelessWidget {
  ListarCampusTab({super.key});

  final CampusController _controller = CampusController();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.onBackgroundDefault,
      child: StreamBuilder<List<CampusModel>>(
        stream: _controller.streamAll(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const _ErrorState();
          }
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            );
          }

          final campus = snapshot.data!;
          if (campus.isEmpty) return const _EmptyState();

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            itemCount: campus.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, i) {
              final c = campus[i];
              return Card(
                color: AppColors.onSurface,
                elevation: 4,
                shadowColor: AppColors.primaryLight.withOpacity(0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: AppColors.primaryLight,
                    child: Icon(Icons.location_city, color: AppColors.primary),
                  ),
                  title: Text(
                    c.id,
                    style: const TextStyle(
                      color: AppColors.onPrimaryText,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  onTap: () {
                    // acciones futuras: detalle/editar/eliminar
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.school_outlined, size: 48, color: AppColors.onTertiaryText),
            SizedBox(height: 10),
            Text(
              'No hay campus registrados',
              style: TextStyle(
                color: AppColors.onSecondaryText,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24.0),
        child: Text(
          'Ocurrió un error al cargar los campus',
          style: TextStyle(
            color: AppColors.electricError,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
