import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

//  // at beginning of file
// ...
// final picker = ImagePicker();
// final pickedImage = await picker.getImage(...);
// final pickedImageFile = File(pickedImage.path); // requires import 'dart:io';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key, required this.imagePickFn, this.editMode = false, this.mealImage = ""});

  final void Function(File pickedImage) imagePickFn;
  final bool editMode;
  final String mealImage;

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  late File _pickedImage;
  bool _imagePicked = false;

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedImage == null) {
      return;
    }
    setState(() {
      _pickedImage = File(pickedImage.path);
      _imagePicked = true;
    });

    widget.imagePickFn(_pickedImage);
  }

  @override
  Widget build(BuildContext context) {
    if (!_imagePicked) {
      if (widget.editMode) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Image(
              image: NetworkImage(widget.mealImage),
              fit: BoxFit.cover,
              height: 220,
              width: double.infinity,
              alignment: Alignment.center,
            ),
            IconButton(
              onPressed: _pickImage,
              icon: const Icon(Icons.add_a_photo),
              iconSize: 90,
              color: Colors.white38,
            ),
          ],
        );
      }
      return IconButton(
        onPressed: _pickImage,
        icon: const Icon(Icons.add_a_photo),
        iconSize: 90,
      );
    }
    return Stack(
        alignment: Alignment.center,
        children: [
          Image(
            image: FileImage(_pickedImage),
            fit: BoxFit.cover,
            height: 220,
            width: double.infinity,
            alignment: Alignment.center,
          ),
          IconButton(
            onPressed: _pickImage,
            icon: const Icon(Icons.add_a_photo),
            iconSize: 90,
            color: Colors.white38,
          ),
        ],
      );
  }
}
