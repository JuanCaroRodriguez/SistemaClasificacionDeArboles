import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart'; // Añadido para obtener directorios
import 'package:printing/printing.dart'; // Añadido para la impresión y compartición de PDF

class ResultPage extends StatelessWidget {
  final File image;
  final double probability;
  final int indice;

  const ResultPage({
    Key? key,
    required this.image,
    required this.probability,
    required this.indice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Image Analysis',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'SofiaSans',
            fontSize: 30,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 225.0,
                height: 225.0,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.file(
                    image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 3),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Probability: ${(probability * 100).toStringAsFixed(2)}%',
                style: const TextStyle(fontSize: 20),
              ),
            ),
            FutureBuilder<String>(
              future: obtenerInformacion(context, indice),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(fontSize: 20),
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      snapshot.data ?? 'No information found',
                      style: const TextStyle(fontSize: 20),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: () {
                _exportToPDF(context, indice);
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 18),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(235, 28, 88, 4),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Export to PDF',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SofiaSans',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> obtenerInformacion(BuildContext context, int indice) async {
    try {
      switch (indice) {
        case 0:
          return "Nombre cientifico: Abres precatoruis L.\nNombre comun: Jequerity\nPosee frutos: Si\nPosee flores: Si\nDato curioso: El Abres precatoruis es conocido por sus semillas altamente toxicas, que contienen la proteina abrina.";
        case 1:
          return "Nombre cientifico: Adonidia merrillii\nNombre comun: Palma Coquera\nPosee frutos: Si\nPosee flores: Si\nDato curioso: La Palma Coquera es una palma ornamental muy popular debido a su elegante apariencia y su capacidad para crecer en macetas.";
        case 2:
          return "Nombre cientifico: Azadirachta indica\nNombre comun: Neen\nPosee frutos: Si\nPosee flores: Si\nDato curioso: El Neen, tambien conocido como Arbol de Nim, es valorado por sus propiedades medicinales y su capacidad para repeler insectos.";
        case 3:
          return "Nombre cientifico: Averrhoa carambola\nNombre comun: Árbol de torombolo\nPosee frutos: Si\nPosee flores: Si\nDato curioso: El Árbol de torombolo produce la fruta conocida como carambola, la cual tiene una forma distintiva de estrella cuando se corta en rodajas.";
        case 4:
          return "Nombre cientifico: Coccoloba uvifera\nNombre comun: Uva de playa\nPosee frutos: Si\nPosee flores: Si\nDato curioso: La Uva de playa es una especie de arbusto o pequeño árbol que es comúnmente plantado en áreas costeras debido a su resistencia a la salinidad y su valor ornamental.";
        case 5:
          return "Nombre cientifico: Conocarpus erectus\nNombre comun: Mangle boton\nPosee frutos: Si\nPosee flores: Si\nDato curioso: El Mangle boton es una especie de mangle que se encuentra en zonas costeras y es conocido por su capacidad para tolerar la salinidad del agua marina.";
        case 6:
          return "Nombre cientifico: Crescentia cujete\nNombre comun: Totumo/jícaro\nPosee frutos: Si\nPosee flores: Si\nDato curioso: El Totumo, también conocido como jícaro, produce frutos de cáscara dura que a menudo se utilizan como recipientes o instrumentos musicales en algunas culturas.";
        case 7:
          return "Nombre cientifico: Gemelina arbolea\nNombre comun: Melina\nPosee frutos: Si\nPosee flores: Si\nDato curioso: La Melina es un árbol de rápido crecimiento que se utiliza comúnmente en plantaciones forestales para la producción de madera.";
        case 8:
          return "Nombre cientifico: Junglans Regia\nNombre comun: Nogal\nPosee frutos: Si\nPosee flores: Si\nDato curioso: El Nogal es conocido por sus deliciosas nueces, que son una fuente rica en ácidos grasos omega-3 y otros nutrientes.";
        case 9:
          return "Nombre cientifico: Manilkara zapota\nNombre comun: Níspero\nPosee frutos: Si\nPosee flores: Si\nDato curioso: El Níspero, también conocido como Sapodilla, produce una fruta dulce y jugosa que se consume fresca o se utiliza en la preparación de postres.";
        case 10:
          return "Nombre cientifico: Mangifera indica\nNombre comun: Arbol de mango\nPosee frutos: Si\nPosee flores: Si\nDato curioso: El Árbol de mango es conocido por producir los deliciosos mangos, una fruta tropical muy apreciada por su sabor dulce y suculento.";
        case 11:
          return "Nombre cientifico: Melicoccus bijugatus jacq\nNombre comun: Mamoncillo\nPosee frutos: Si\nPosee flores: Si\nDato curioso: El Mamoncillo es una fruta pequeña y redonda, similar al lichi, con una cáscara dura y una pulpa dulce y jugosa.";
        case 12:
          return "Nombre cientifico: Moringa oleifera\nNombre comun: Moringa\nPosee frutos: Si\nPosee flores: Si\nDato curioso: La Moringa es conocida como 'el árbol milagroso' debido a sus numerosos beneficios para la salud. Todas sus partes, incluidas las hojas, semillas, frutos y raíces, son comestibles y tienen propiedades medicinales.";
        case 13:
          return "Nombre cientifico: Moquilea tomentosa Benth\nNombre comun: Oiti\nPosee frutos: Si\nPosee flores: Si\nDato curioso: El Oiti es un árbol nativo de América del Sur que produce frutos comestibles y madera de buena calidad.";
        case 14:
          return "Nombre cientifico: Morisonia Odoratissims\nNombre comun: Olivo\nPosee frutos: Si\nPosee flores: Si\nDato curioso: El Olivo es un árbol venerado por su importancia histórica, cultural y religiosa en muchas partes del mundo. Sus frutos, las aceitunas, son la fuente del aceite de oliva, un componente esencial de la dieta mediterránea.";
        case 15:
          return "Nombre cientifico: Musa paradisiaca\nNombre comun: Platano\nPosee frutos: Si\nPosee flores: Si\nDato curioso: El Plátano es una planta herbácea gigante que produce los plátanos, una fruta tropical versátil que se consume fresca, cocida o frita en diversas preparaciones culinarias.";
        case 16:
          return "Nombre cientifico: Tamarindus indica\nNombre comun: Tamarindo\nPosee frutos: Si\nPosee flores: Si\nDato curioso: El Tamarindo es un árbol tropical que produce una vaina comestible con una pulpa agridulce, utilizada en muchas cocinas del mundo para hacer salsas, bebidas y dulces.";
        default:
          return "No information available for this index.";
      }
    } catch (e) {
      debugPrint('Error retrieving information: $e');
      return 'Error retrieving information';
    }
  }

  Future<void> _exportToPDF(BuildContext context, int indice) async {
    try {
      await checkAndRequestPermission(context);

      final pdf = pw.Document();
      final information = await obtenerInformacion(context, indice);

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Text(information),
            );
          },
        ),
      );

      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/result_$indice.pdf');
      await file.writeAsBytes(await pdf.save());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('PDF exported to ${file.path}'),
        ),
      );

      await Printing.sharePdf(bytes: await pdf.save(), filename: 'result_$indice.pdf');
    } catch (e) {
      debugPrint('Error exporting to PDF: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error exporting to PDF'),
        ),
      );
    }
  }

  Future<void> checkAndRequestPermission(BuildContext context) async {
    PermissionStatus status = await Permission.storage.status;

    if (!status.isGranted) {
      status = await Permission.storage.request();

      if (!status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Storage permission is required to export PDF'),
          ),
        );
        return;
      }
    }
  }
}
