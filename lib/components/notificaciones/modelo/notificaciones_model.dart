import 'package:flutter/material.dart';

class NotificacionesModel {
  String _titulo = "";
  String _mensaje = "";
  String _clase = "";
  String _estado = "";
  String _fecha = "";
  IconData _icono;


  NotificacionesModel(this._titulo,this._mensaje,this._clase,this._estado,this._fecha, this._icono);

  String get titulo => _titulo;
  void setTitulo(a){_titulo = a;}

  String get mensaje => _mensaje;
  void setMensaje(a){_mensaje = a;}

  String get clase => _clase;
  void setClase(a){_clase = a;}


  String get estado => _estado;
  void setEstado(a){_estado = a;}
  
   String get fecha => _fecha;
  void setFecha(a){_fecha = a;}

  
   IconData get icono => _icono;
  void setIcono(a){_icono = a;}

}
 
  