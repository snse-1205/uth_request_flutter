import 'package:flutter/material.dart';
import 'package:uth_request_flutter_application/components/utils/color.dart';

class UsuariosPage extends StatelessWidget {
  const UsuariosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Aquí va el CRUD de usuarios"),
      ),
      backgroundColor: AppColors.onBackgroundDefault,
    );
  }
}