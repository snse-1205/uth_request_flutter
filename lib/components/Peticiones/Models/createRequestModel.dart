import 'package:cloud_firestore/cloud_firestore.dart';

/// Item mostrado en el dropdown (clase disponible para solicitar)
class ClaseItem {
  final String id;                 // id del doc en ClasesPorCarrera (== id de la clase)
  final String nombre;             // campo 'nombre'
  final DocumentReference? requisitoRef; // campo 'requisito' (/Clases/{id} o null)

  ClaseItem({
    required this.id,
    required this.nombre,
    required this.requisitoRef,
  });
}

/// Payload para crear la petición
class PeticionCreate {
  final String tipo;           // 'APERTURA DE CLASE'
  final String claseId;        // id de la clase seleccionada (ClasesPorCarrera/{id})
  final String modalidad;      // 'Presencial' | 'Presencial-ZOOM'
  final String dia;            // 'Semana lunes-jueves' | 'Fin de semana'
  final String horaInicio;     // 'HH:mm'
  final String horaFin;        // 'HH:mm'
  final String estudianteId;   // id del doc en Estudiantes/{id}
  final String estado;         // 'espera aprobación'
  final Timestamp dateCreate;  // server time o ahora

  PeticionCreate({
    required this.tipo,
    required this.claseId,
    required this.modalidad,
    required this.dia,
    required this.horaInicio,
    required this.horaFin,
    required this.estudianteId,
    required this.estado,
    required this.dateCreate,
  });

  Map<String, dynamic> toMap() {
    return {
      'tipo': tipo,
      'claseId': claseId,
      'modalidad': modalidad,
      'dia': dia,
      'horaInicio': horaInicio,
      'horaFin': horaFin,
      'estudianteId': estudianteId,
      'estado': estado,
      'dateCreate': dateCreate,
    };
  }
}
