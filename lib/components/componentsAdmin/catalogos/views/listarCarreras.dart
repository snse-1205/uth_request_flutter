import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uth_request_flutter_application/components/utils/color.dart';

class ListarCarrerasTab extends StatelessWidget {
  const ListarCarrerasTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.onBackgroundDefault,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Carreras')
            .orderBy('dateCreate', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Ocurrió un error al cargar las carreras',
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

          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return const _EmptyStateCarreras();
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            itemCount: docs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>? ?? {};
              final nombre = (data['nombre'] as String?)?.trim() ?? '';
              final id = doc.id;

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
                    child: Icon(Icons.menu_book, color: AppColors.primary),
                  ),
                  title: Text(
                    nombre.isNotEmpty ? nombre : id,
                    style: const TextStyle(
                      color: AppColors.onPrimaryText,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  subtitle: Text(
                    'ID: $id',
                    style: const TextStyle(color: AppColors.onSecondaryText),
                  ),
                  trailing: const Icon(Icons.chevron_right,
                      color: AppColors.onSecondaryText),
                  onTap: () {
                    // futuro: navegar a detalle/editar carrera
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

class _EmptyStateCarreras extends StatelessWidget {
  const _EmptyStateCarreras();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.menu_book_outlined,
                size: 48, color: AppColors.onTertiaryText),
            SizedBox(height: 10),
            Text(
              'No hay carreras registradas',
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
