import 'package:flutter/material.dart';

class CreateUserPage extends StatelessWidget {
  const CreateUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Crear Nuevo Usuario"),
      ),
      body: Center(
        child: Text("Creacion de usuario"),
      ),
    );
  }
}