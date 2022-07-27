import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

class ImageInput extends StatefulWidget {
  ImageInput(this.savedImageFile, {Key? key}) : super(key: key);

  final Function savedImageFile;

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _storedImage;

  Future<File> saveImagePermanently(String imagePath) async {
    final appDirectory = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(imagePath);
    final savedImage = File('${appDirectory.path}/$fileName');

    return File(imagePath).copy(savedImage.path);
  }

  Future _takePicture() async {
    try {
      final imageFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
        maxWidth: 600,
      );
      if (imageFile == null) {
        return;
      }
      setState(() {
        _storedImage = File(imageFile.path);
      });
      final imageTemporary = await saveImagePermanently(imageFile.path);
      //call method to send save file to add place screen variable
      print('path : $imageTemporary');
      widget.savedImageFile(imageTemporary);
    } on PlatformException catch (e) {
      print('failed to pick image $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 150,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          alignment: Alignment.center,
          child: _storedImage != null
              ? Image.file(
                  _storedImage!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
              : Text(
                  'No image taken!',
                  textAlign: TextAlign.center,
                ),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: TextButton.icon(
            onPressed: () {
              _takePicture();
            },
            icon: Icon(Icons.camera),
            label: Text('Take Picture'),
            style: ButtonStyle(
              foregroundColor:
                  MaterialStateProperty.all(Theme.of(context).primaryColor),
            ),
          ),
        ),
      ],
    );
  }
}
