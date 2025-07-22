import 'package:flutter/material.dart';

mostrarAlerta ( BuildContext context, String titulo, String subtitulo){

  showDialog(
    context: context, 
    builder: ( _ )=> AlertDialog(
      title : Text(titulo, style : const TextStyle(color : Colors.red, fontSize: 30, fontWeight: FontWeight.w700)),
      content: Text(subtitulo, style : const TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
      actions: <Widget>[
        MaterialButton(
          height: 40,
          color: Colors.red,
          elevation: 5,
          textColor : Colors.white,
          onPressed: ()=> Navigator.pop(context),
          child : const Text('OK', style: TextStyle(fontSize: 15),),

        )
      ], 
    )
    );
}