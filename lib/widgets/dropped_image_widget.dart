import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:proyecto_fct_facturas/models/dropped_file.dart';
import 'package:flutter/material.dart';

class DroppedFileWidget extends StatelessWidget {
  final DroppedFile? file;
  const DroppedFileWidget({
    super.key,
    required this.file,
  });

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (file != null) buildFileDetails(file!),
        ],
      );

  Widget buildFileDetails(DroppedFile file) {

    return Container(
            margin: const EdgeInsets.only(left: 24),
            child: Row(
              children: [
                const FaIcon(FontAwesomeIcons.solidFilePdf,
                    color: Colors.black87, size: 60),
                const SizedBox(width: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      file.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                                      ],
                )
              ],
            ),
          );
  }
}
