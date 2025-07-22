import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_fct_facturas/pages/confirmacion_codigo.dart';
import 'package:proyecto_fct_facturas/pages/pagina_principal.dart';
import 'package:proyecto_fct_facturas/pages/solicitar_codigo.dart';
import 'package:proyecto_fct_facturas/pages/status.dart';
import 'package:proyecto_fct_facturas/providers/documents_providers.dart';
import 'package:proyecto_fct_facturas/providers/file_dropped.dart';
import 'package:proyecto_fct_facturas/providers/supplier_info.dart';
import 'package:proyecto_fct_facturas/services/auth_service.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => DocumentsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => SupplierInfo(),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthService(),
        ),ChangeNotifierProvider(
          create: (_) => FileDropped(),
        )
      ],
      child: MaterialApp(
        initialRoute: 'solicitarCodigo',
        routes: {
          'paginaPrincipal' : ( _ ) => PaginaPrincipal(),
          'solicitarCodigo': (_) => SolicitarCodigo(),
          'confirmarCodigo' : (_) => ConfirmarCodigo(),
          'status': (_) => const StatusPage(),
        },
      ),
    );
  }
}
