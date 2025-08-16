import 'package:flutter/material.dart';
import 'package:uth_request_flutter_application/components/componentsAdmin/catalogos/controllers/usuariosController.dart';
import 'package:uth_request_flutter_application/components/componentsAdmin/catalogos/models/usuariosModel.dart';
import 'package:uth_request_flutter_application/components/utils/color.dart';

class ListarUsuariosTab extends StatelessWidget {
  ListarUsuariosTab({super.key});

  final UsuariosController _controller = UsuariosController();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.onBackgroundDefault,
      child: StreamBuilder<List<Usuario>>(
        stream: _controller.streamAll(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Ocurrió un error al cargar los usuarios',
                style: TextStyle(
                  color: AppColors.electricError,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            );
          }

          final items = snapshot.data!;
          if (items.isEmpty) {
            return const _EmptyStateUsuarios();
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final u = items[index];

              return Card(
                color: AppColors.onSurface,
                elevation: 4,
                shadowColor: AppColors.primaryLight.withOpacity(0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primaryLight,
                    child: Icon(
                      u.rol == "Administrador" ? Icons.admin_panel_settings : Icons.person,
                      color: AppColors.primary,
                    ),
                  ),
                  title: Text(
                    "${u.nombre} ${u.apellido}",
                    style: const TextStyle(
                      color: AppColors.onPrimaryText,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  subtitle: Text(
                    "${u.correo}\nRol: ${u.rol}",
                    style: const TextStyle(color: AppColors.onSecondaryText),
                  ),
                  isThreeLine: true,
                  trailing: const Icon(Icons.chevron_right, color: AppColors.onSecondaryText),
                  onTap: () {
                    // futuro: navegar a detalle/editar usuario
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

class _EmptyStateUsuarios extends StatelessWidget {
  const _EmptyStateUsuarios();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.people_outline, size: 48, color: AppColors.onTertiaryText),
            SizedBox(height: 10),
            Text(
              'No hay usuarios registrados',
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
