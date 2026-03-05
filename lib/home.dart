import 'dart:io';
import 'dart:typed_data';
import 'package:tree_identify/result.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'dart:math';

class HomePage extends StatefulWidget {
  const HomePage({super.key}); 

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late File _image;
  dynamic _probability = 0;
  String? _result;
  int? _indice;
  List<String>? _labels;
  late tfl.Interpreter _interpreter;
  final picker = ImagePicker();
  @override
  void initState() {
    super.initState();
    loadModel().then((_) {
      loadLabels().then((loadedLabels) {
        setState(() {
          _labels = loadedLabels;
        });
      });
    });
  }

  @override
  void dispose() {
    _interpreter.close();
    super.dispose();
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      backgroundColor: Color.fromARGB(255, 72, 212, 83), // Color verde
      title: Text( 'TREE IDENTIFY',
      style: TextStyle( color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'SofiaSans', fontSize: 25,),
      ),
      
      centerTitle: false,
      elevation: 0, // Esto elimina la sombra debajo del AppBar
      toolbarHeight: 70, // Ajusta la altura según sea necesario
    ),
    body: Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                                     mainAxisAlignment: MainAxisAlignment.center, // Centra los elementos verticalmente
        children: <Widget>[
          const SizedBox(height: 30), // Ajusta según sea necesario
          Center(
            child: SizedBox(
              width: 350,
              child: Column(
                children: <Widget>[
                  Image.asset(
                    'assets/TREE.png',
                    width: 500,
                    height: 500,
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      pickImageFromCamera();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 18,
                      ),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(235, 28, 88, 4),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'Capture a Photo',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'SofiaSans',
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      pickImageFromGallery();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 18,
                      ),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(235, 28, 88, 4),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'Select a photo',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'SofiaSans',
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}


  Future<void> loadModel() async {
    try {
      _interpreter = await tfl.Interpreter.fromAsset('assets/model.tflite');
    } catch (e) {
      debugPrint('Error loading model: $e');
    }
  }

  Future<void> pickImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      _setImage(File(pickedFile.path));
    }
  }

  Future<void> pickImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _setImage(File(pickedFile.path));
    }
  }

  void _setImage(File image) {
    setState(() {
      _image = image;
    });
    runInference();
  }

  Future<Uint8List> preprocessImage(File imageFile) async {
    // Decode the image to an Image object
    img.Image? originalImage = img.decodeImage(await imageFile.readAsBytes());

    // Resize the image to the correct size
    img.Image resizedImage =
        img.copyResize(originalImage!, width: 224, height: 224);

    // Convert to a byte buffer in the format suitable for TensorFlow Lite (RGB)
    // The model expects a 4D tensor [1, 224, 224, 3]
    // Flatten the resized image to match this shape
    Uint8List bytes = resizedImage.getBytes();
    return bytes;
  }

  Future<void> runInference() async {
    if (_labels == null) {
      return;
    }

    try {
      Uint8List inputBytes = await preprocessImage(_image);
      var input = inputBytes.buffer.asUint8List().reshape([1, 224, 224, 3]);
      var outputBuffer = List<int>.filled(1 * 25, 0).reshape([1, 25]);

      _interpreter.run(input, outputBuffer);

      // Assuming output is now List<List<int>> after inference
      List<int> output = outputBuffer[0];

      // Print raw output for debugging
      debugPrint('Raw output: $output');

      // Calculate probability
      int maxScore = output.reduce(max);
      _probability = (maxScore / 255.0); // Convert to percentage

      // Get the classification result
      int highestProbIndex = output.indexOf(maxScore);
      String classificationResult = _labels![highestProbIndex];
      debugPrint('Valor del indidei :$highestProbIndex');
      _indice=highestProbIndex;
      debugPrint('Se leyo toda la informacion');

      setState(() {
        _result = classificationResult;
        // _probability is updated with the calculated probability
      });

      navigateToResult();
    } catch (e) {
      debugPrint('Error during inference:$e');
    }
  }

  Future<List<String>> loadLabels() async {
    final labelsData =
        await DefaultAssetBundle.of(context).loadString('assets/labels.txt');
    return labelsData.split('\n');
  }

  

  String classifyImage(List<int> output) {
    int highestProbIndex = output.indexOf(output.reduce(max));
    return _labels![highestProbIndex];
  }

  void navigateToResult() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultPage(
          image: _image,
          probability: _probability,
          indice: _indice!,
        ),
      ),
    );
  }
}
