import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uth_request_flutter_application/components/utils/color.dart';
import 'package:uth_request_flutter_application/temas/controllers/temas_controller.dart';
import 'package:uth_request_flutter_application/temas/views/card_tema.dart';
import 'package:uth_request_flutter_application/temas/views/crearTema.dart';

class ListaTemasPage extends StatelessWidget {
  const ListaTemasPage({super.key});

  @override
  Widget build(BuildContext context) {
    final PostController postController = Get.put(PostController());

    return Scaffold(
      backgroundColor: AppColors.onBackgroundDefault,
      body: Column(
        children: [
          // Barra para escribir
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: InkWell(
              onTap: () {
                Get.to(
                  () => CrearTemaPage(comentario: false),
                  transition: Transition.downToUp,
                );
              },
              borderRadius: BorderRadius.circular(25.0),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 8.0,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.selectedNavbar),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.edit,
                      size: 18,
                      color: AppColors.onBorderTextField,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '¿Quieres crear un tema?',
                      style: TextStyle(
                        color: AppColors.onBorderTextField,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Divider(color: AppColors.onLineDivider),

          // Lista de temas en tiempo real
          Expanded(
            child: ListView(
              children: [
                CardTema(
                  nombre: 'JOEL JARED BENITEZ RIOS',
                  mensaje:
                      'Hola! Soy nuevo en la comunidad estudiantil. ¿Qué hay de nuevo??',
                  tiempo: '3d',
                  likes: 23,
                  comentarios: 4,
                  principal: false,
                  comentario: false,
                  fechaCreacion: '00/00/0000 00:00',
                  verificado: true,
                  carrera: 'Estudiante de Ingenieria en Computacion',
                ),
                CardTema(
                  nombre: 'STACY NICOLE SAUCEDA ESPINOZA',
                  mensaje:
                      'Que aplicación más hermosa bella divina guapa... Vamos a ver si funciona al final :)...',
                  tiempo: '6d',
                  likes: 23,
                  comentarios: 2,
                  principal: true,
                  comentario: false,
                  fechaCreacion: '00/00/0000 00:00',
                  verificado: false,
                  carrera: 'Estudiante de Ingenieria Industrial',
                ),
                CardTema(
                  nombre: 'STACY NICOLE SAUCEDA ESPINOZA',
                  mensaje:
                      'Holis',
                  tiempo: '6d',
                  likes: 23,
                  comentarios: 2,
                  principal: true,
                  comentario: false,
                  fechaCreacion: '00/00/0000 00:00',
                  verificado: false,
                  carrera: 'Estudiante de Ingenieria Industrial',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
