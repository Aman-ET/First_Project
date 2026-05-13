import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageListScreen extends StatefulWidget {
  @override
  _ImageListScreenState createState() => _ImageListScreenState();
}

class _ImageListScreenState extends State<ImageListScreen> {
  final ImagePicker _picker = ImagePicker();
  List<File> _images = [];

  // Function to pick an image from the gallery or camera
  Future<void> _pickImage(ImageSource source) async {

    List<XFile> pickedFiles = [];

    if (source == .camera){
     var pickedFile = await _picker.pickImage(source: source);
     pickedFiles.add(pickedFile!);
     print("Test ${pickedFile.path}");
    } else {
      pickedFiles = await _picker.pickMultiImage();
    }

    if (pickedFiles.isNotEmpty) {
      setState(() {
        _images.addAll(
            pickedFiles.map((xFile) => File(xFile.path)).toList()
        );
      });
    }
  }

  // A helper function to show a modal with both options
  void _showPickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Gallery'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image List Demo'),
      ),
      body: ListView.builder(
        itemCount: _images.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.file(
              _images[index],
              fit: BoxFit.cover, // Use BoxFit for better image handling
              height: 200,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showPickerOptions(context),
        tooltip: 'Add Image',
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }
}
