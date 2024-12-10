import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdfcreator/privacy.dart';
import 'package:share_plus/share_plus.dart';
import 'screen2.dart';
import 'aboutus.dart';
import 'databaseHelper/database_helper.dart';
import 'model/image_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ImagePicker _picker = ImagePicker();
  List<ImageModel> imageModels = [];
  File? imageFile;

  @override
  void initState() {
    super.initState();
    _fetchImages();
  }

  Future<void> _insertImage(File imageFile) async {
    Uint8List? imageBytes = await FlutterImageCompress.compressWithFile(
      imageFile.path,
      quality: 75,
    );
    String base64Image = base64Encode(imageBytes!);
    // await _database?.insert('images', {'imageData': base64Image});
    await SQLHelper.createItem(base64Image);

    _fetchImages();
  }

  void _fetchImages() async {
    final data = await SQLHelper.getImages();
    setState(() {
      imageModels = data;
    });
  }

  Future<void> _captureImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 100,
    );
    if (pickedFile != null) {
      _cropImage(File(pickedFile.path));
      // File imageFile = File(pickedFile.path);
      // await _insertImage(imageFile);
    }
  }

  Future<void> _deviceImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
    );
    if (pickedFile != null) {
      _cropImage(File(pickedFile.path));
      // await _insertImage(imageFile);
    }
  }

  _cropImage(File imgFile) async {
    final croppedFile = await ImageCropper().cropImage(
        sourcePath: imgFile.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: "Image Cropper",
              toolbarColor: Colors.blueGrey,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: "Image Cropper",
          )
        ]);
    if (croppedFile != null) {
      imageCache.clear();
      setState(() {
        imageFile = File(croppedFile.path);
      });
      // reload();
    }
    await _insertImage(imageFile!);
  }

  Widget _buildImageWidget(String imageString) {
    Uint8List decodedImage = base64Decode(imageString);
    return Image.memory(
      decodedImage,
      width: 100,
      height: 100,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        leading: const Icon(Icons.account_circle_rounded),
        leadingWidth: 60,
        title: const Text('ScanShare',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        actions: [
          Theme(
            data: Theme.of(context)
                .copyWith(iconTheme: const IconThemeData(color: Colors.white)),
            child: PopupMenuButton(itemBuilder: (context) {
              return [
                const PopupMenuItem<int>(
                  value: 0,
                  child: Text(
                    "Privacy Policy",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                const PopupMenuItem<int>(
                  value: 1,
                  child:
                      Text("About Us", style: TextStyle(color: Colors.black)),
                ),
                const PopupMenuItem<int>(
                  value: 2,
                  child: Text("Share", style: TextStyle(color: Colors.black)),
                ),
              ];
            }, onSelected: (value) {
              if (value == 0) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Privacy()));
              } else if (value == 1) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Aboutus()));
              } else if (value == 2) {
                Share.share(
                    'I am really enjoying this app! You should give it a try too.');
              }
            }),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: imageModels.length,
        itemBuilder: (context, index) {
          ImageModel imageModel = imageModels[index];

          return Card(
            elevation: 5,
            margin: const EdgeInsets.all(8),
            shadowColor: Colors.grey,
            color: Colors.white,
            child: ListTile(
              leading: CircleAvatar(
                  backgroundColor: Colors.blueGrey,
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  )), // Display the ID
              title: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                child: Container(
                  height: 80.0,
                  color: Colors.grey,
                  child: _buildImageWidget(imageModel.imageData),
                ),
              ),

              // _buildImageWidget(imageModel.imageData), // Display the image
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.delete,
                      size: 30,
                      color: Colors.blueGrey,
                    ),
                    onPressed: () {
                      print("iddddddd");
                      print(imageModel.id);

                      SQLHelper.deleteItem(imageModel.id);
                      _fetchImages();
                      // _deleteImage(
                      //     imageModel.id); // Pass the ID to the delete method
                    },
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: IconButton(
                      iconSize: 45,
                      icon: Image.asset(
                        'assets/images/222.jpg',
                        fit: BoxFit.cover,
                        height: 300,
                        width: 300,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Screen2(imageModel.imageData)));
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              onPressed: _deviceImage,
              backgroundColor: Colors.blue[900],
              child: const Icon(Icons.image),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              onPressed: _captureImage,
              backgroundColor: Colors.blue[900],
              child: const Icon(Icons.camera),
            ),
          ),
        ],
      ),
    );
  }
}
