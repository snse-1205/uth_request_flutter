import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uth_request_flutter_application/components/utils/color.dart';

class ListarCampusTab extends StatelessWidget {
  const ListarCampusTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.onBackgroundDefault,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Campus')
            .orderBy('dateCreate', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Ocurrió un error al cargar los campus',
                style: const TextStyle(
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
            return const _EmptyState();
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            itemCount: docs.length,
            separatorBuilder: (_, __) =>
                const SizedBox(height: 8), // espacio entre cards
            itemBuilder: (context, index) {
              final doc = docs[index];

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
                    doc.id, // 👈 SOLO mostramos el ID del campus
                    style: const TextStyle(
                      color: AppColors.onPrimaryText,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  onTap: () {
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
            Icon(Icons.school_outlined,
                size: 48, color: AppColors.onTertiaryText),
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
