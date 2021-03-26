import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase ML Vision [Optimized]',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Firebase ML Vision [Optimized]'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _imageUrl;
  Image _image;
  Size _imageSize;

  final FaceDetector _faceDetector = FirebaseVision.instance.faceDetector();
  dynamic _scanResults;

  @override
  void initState() {
    super.initState();
    // TODO: Add image URL
    _imageUrl =
        "https://images.unsplash.com/photo-1501386761578-eac5c94b800a?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80";
    _image = Image.network(
      _imageUrl,
    );
  }

  Future<void> _scanImage() async {
    setState(() {
      _scanResults = null;
    });

    // Prepare local file from image URL
    final File imageFile = await _fileFromImageUrl(_imageUrl);

    // Decode image and get image size (image size will be used when painting)
    var decodedImage = await decodeImageFromList(imageFile.readAsBytesSync());
    setState(() {
      _imageSize =
          Size(decodedImage.width.toDouble(), decodedImage.height.toDouble());
    });

    // Prepare vision image and process with face detector
    final FirebaseVisionImage visionImage =
        FirebaseVisionImage.fromFile(imageFile);
    List<Face> faces = await _faceDetector.processImage(visionImage);
    // _faceDetector.close();

    setState(() {
      _scanResults =
          faces; // Update scan results. Use setState to make sure that build() will be called
    });
  }

  CustomPaint _buildResults(dynamic results) {
    CustomPainter painter = FaceDetectorPainter(
      _imageSize,
      results,
    );
    return CustomPaint(
      foregroundPainter: painter,
      child: _image,
    );
  }

  List<String> urlist = [
    "https://images.unsplash.com/photo-1501386761578-eac5c94b800a?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80",
    "https://images.unsplash.com/photo-1484712401471-05c7215830eb?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1950&q=80",
    "https://images.unsplash.com/photo-1528977695568-bd5e5069eb61?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&auto=format&fit=crop&w=1050&q=80",
    "https://images.unsplash.com/photo-1591219233007-4ac041f8c2be?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80",
    "https://images.unsplash.com/photo-1510947565940-a38e2443c426?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80",
    "https://images.unsplash.com/flagged/photo-1568733279036-aaa3f1e235f4?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1052&q=80",
    "https://images.unsplash.com/photo-1611822877676-31f7ea952098?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80"
  ];

// generate a random index based on the list length
// and use it to retrie ve the element

  Widget _buildImage() {
    return Container(
      child: Center(
          child: _scanResults == null
              ? // if scan result is null, display image and process button
              Column(
                  children: <Widget>[
                    _image,
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32.0),
                      child: Column(
                        children: [
                          ElevatedButton(
                            onPressed: _scanImage,
                            child: Text(
                              "Scan faces",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Color.fromRGBO(179, 232, 210, 1))),
                          ),
                          // _Inputfield(),,
                          ElevatedButton(
                              onPressed: () {
                                setState(() => {
                                      _imageUrl =
                                          (urlist.toList()..shuffle()).first,
                                      _image = Image.network(
                                        _imageUrl,
                                      )
                                    });
                                print(_imageUrl);
                              },
                              child: Text(
                                "Ramdom Image",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Color.fromRGBO(179, 232, 210, 1)),
                              )),

                          ElevatedButton(
                            onPressed: () {
                              setState(() => {
                                    _imageUrl =
                                        "https://images.unsplash.com/photo-1501386761578-eac5c94b800a?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80",
                                    _image = Image.network(
                                      _imageUrl,
                                    )
                                  });
                              print(_imageUrl);
                            },
                            child: Text("Set Default Image"),
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.grey)),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              : Column(
                  children: <Widget>[
                    // if scan result is initialized, display result and text
                    _buildResults(_scanResults),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Text(
                              'Faces found ${_scanResults.length}',
                              style: TextStyle(
                                fontSize: 32,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(
                                () => {_scanResults = null},
                              );
                            },
                            child: Text(
                              "Reset",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Color.fromRGBO(179, 232, 210, 1))),
                          ),
                        ],
                      ),
                    )
                  ],
                )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(56, 56, 56, 1),
      appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: Color.fromRGBO(143, 189, 170, 1)),
      body: SingleChildScrollView(
        child: Center(
            child: Stack(
          children: <Widget>[CircularProgressIndicator(), _buildImage()],
        )

            // _image == null
            //     ? // if there is no image loaded (null), display progress indicator
            //     CircularProgressIndicator()
            //     : _buildImage(), // if image is loaded, display image and process button
            ),
      ),
    );
  }
}

class FaceDetectorPainter extends CustomPainter {
  FaceDetectorPainter(this.absoluteImageSize, this.faces);

  final Size absoluteImageSize;
  final List<Face> faces;

  @override
  void paint(Canvas canvas, Size size) {
    final double scaleX = size.width / absoluteImageSize.width;
    final double scaleY = size.height / absoluteImageSize.height;

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0
      ..color = Colors.green;

    for (final Face face in faces) {
      // draw rectangles for all detected faces
      canvas.drawRect(
        Rect.fromLTRB(
          face.boundingBox.left * scaleX,
          face.boundingBox.top * scaleY,
          face.boundingBox.right * scaleX,
          face.boundingBox.bottom * scaleY,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(FaceDetectorPainter oldDelegate) {
    return oldDelegate.absoluteImageSize != absoluteImageSize ||
        oldDelegate.faces != faces;
  }
}

Future<File> _fileFromImageUrl(String imageUrl) async {
  // convert from image url to local file
  final response = await http.get(Uri.parse(imageUrl));
  print("_fileFromImageUrl: http.get done");

  final directory = await getApplicationDocumentsDirectory();
  print("_fileFromImageUrl: directory initialized");

  final file = File(join(directory.path, 'temp.jpg'));
  print("_fileFromImageUrl: file initialized");

  file.writeAsBytesSync(response.bodyBytes);
  print("_fileFromImageUrl: file.writeAsBytesSync done");

  return file;
}
