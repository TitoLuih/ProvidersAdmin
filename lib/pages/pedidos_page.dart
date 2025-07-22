import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_fct_facturas/models/articulos.dart';
import 'package:proyecto_fct_facturas/pages/pagina_principal.dart';
import 'package:proyecto_fct_facturas/providers/documents_providers.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PedidosPage extends StatefulWidget {
  const PedidosPage({
    super.key,
  });

  @override
  State<PedidosPage> createState() => _PedidosPageState();
}

class _PedidosPageState extends State<PedidosPage> {
  List<Articulos> articulos = [
     Articulos(id: 'A1X9T0', nombre: 'Caja Clavos', cantidad: 12, precioSinIva: 850.25, precioConIva: 1028.80),
    Articulos(id: 'B7U2Q1', nombre: 'Destornillador', cantidad: 7, precioSinIva: 129.99, precioConIva: 157.29),
    Articulos(id: 'C3E5R8', nombre: 'Martillo Grande', cantidad: 15, precioSinIva: 345.50, precioConIva: 417.06),
    Articulos(id: 'D0P7N6', nombre: 'Juego Llaves', cantidad: 4, precioSinIva: 1230.00, precioConIva: 1488.30),
    Articulos(id: 'E2K8Z3', nombre: 'Tornillos 5mm', cantidad: 50, precioSinIva: 75.40, precioConIva: 91.23),
    Articulos(id: 'F9M6L4', nombre: 'Caja Herramientas', cantidad: 2, precioSinIva: 2100.00, precioConIva: 2541.00),
    Articulos(id: 'G4J3H1', nombre: 'Llave Inglesa', cantidad: 9, precioSinIva: 432.85, precioConIva: 523.75),
    Articulos(id: 'H5D2W7', nombre: 'Flexómetro', cantidad: 18, precioSinIva: 98.75, precioConIva: 119.49),
    Articulos(id: 'I7V0S5', nombre: 'Serrucho', cantidad: 3, precioSinIva: 310.20, precioConIva: 375.34),
    Articulos(id: 'J1L6Y2', nombre: 'Nivel Láser', cantidad: 6, precioSinIva: 1432.60, precioConIva: 1732.45),
    Articulos(id: 'K2T9F9', nombre: 'Taladro Percutor', cantidad: 1, precioSinIva: 3499.99, precioConIva: 4234.99),
    Articulos(id: 'L3B5X3', nombre: 'Brocas Variadas', cantidad: 20, precioSinIva: 210.30, precioConIva: 254.46),
    Articulos(id: 'M6Q1G7', nombre: 'Espátula', cantidad: 14, precioSinIva: 55.00, precioConIva: 66.55),
    Articulos(id: 'N8U7A5', nombre: 'Silicona Blanca', cantidad: 11, precioSinIva: 83.33, precioConIva: 100.83),
    Articulos(id: 'O0Z3M8', nombre: 'Masilla Interior', cantidad: 8, precioSinIva: 122.10, precioConIva: 147.74),
    Articulos(id: 'P4N6R0', nombre: 'Guantes Obra', cantidad: 25, precioSinIva: 18.50, precioConIva: 22.39),
    Articulos(id: 'Q5K1C2', nombre: 'Cúter Profesional', cantidad: 5, precioSinIva: 99.99, precioConIva: 120.99),
    Articulos(id: 'R9X2D4', nombre: 'Lijadora Orbital', cantidad: 1, precioSinIva: 1750.75, precioConIva: 2118.41),
    Articulos(id: 'S2E3H6', nombre: 'Pintura Blanca 10L', cantidad: 3, precioSinIva: 650.00, precioConIva: 786.50),
    Articulos(id: 'T7M4B9', nombre: 'Rodillo Pintura', cantidad: 10, precioSinIva: 42.75, precioConIva: 51.72),
  ];

  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final documentsProvider =
        Provider.of<DocumentsProvider>(context, listen: false);
    return Scaffold(
      body: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.grey.shade300,
          child: Row(children: [
            SizedBox(
              width: 450,
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 150,
                    child: Row(
                      children: [
                        Container(
                          color: const Color(0xff0a1699),
                          width: 70,
                          height: 150,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color(0xff0a1699)),
                            ),
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const PaginaPrincipal()));
                            },
                            child:
                                const Icon(Icons.arrow_back, color: Colors.white),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(20),
                            color: const Color(0xff0a1699),
                            child: Text(
                              documentsProvider.nombreFichero,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      child: Scaffold(
                        body: ListView.builder(
                            scrollDirection: Axis.vertical,
                            padding: const EdgeInsets.all(10),
                            itemCount: articulos.length,
                            itemBuilder: (context, i) =>
                                articulosTile(articulos[i])),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Center(
                  child: Container(
                height: 800,
                width: 600,
                child: SfPdfViewer.network(
                  'dummy.api.link/${documentsProvider.fichero}',
                  key: _pdfViewerKey,
                ),
              )),
            ),
          ])),
    
    );
  }

  ListTile articulosTile(Articulos articulos) {
    return ListTile(
      enabled: true,
      hoverColor: Colors.grey.shade100,
      contentPadding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
      leading:
          const FaIcon(FontAwesomeIcons.cartShopping, color: Colors.black87),
      title: Text(
        articulos.nombre,
        style: const TextStyle(
            color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(articulos.id, style: const TextStyle(fontSize: 12)),
      trailing: Text('${articulos.precioConIva} €',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
      onTap: () {},
    );
  }
}
