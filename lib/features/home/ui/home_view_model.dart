import 'dart:typed_data';

import 'package:code_on_the_rocks/code_on_the_rocks.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomeViewModelBuilder extends ViewModelBuilder<HomeViewModel> {
  const HomeViewModelBuilder({
    super.key,
    required super.builder,
  });

  @override
  State<StatefulWidget> createState() => HomeViewModel();
}

class HomeViewModel extends ViewModel<HomeViewModel> {

  ValueNotifier<bool> parsingImage = ValueNotifier(false);

  void setParsingImage(bool val){
    parsingImage.value = val;
  }

  TextEditingController urlController = TextEditingController();

  Future<String?> capturePhoto(ImageSource source) async {
    setParsingImage(true);
    String name = DateTime.now().microsecondsSinceEpoch.toString();
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: source);

    if(photo != null) {
      await savePhoto(photo, name);
      setParsingImage(false);
      return name;
    } else {
      setParsingImage(false);
      return null;
    }
  }

  Future<String?> savePhoto(XFile? image, String name) async {
    if (image != null) {
      Uint8List data = await image.readAsBytes();

      final storageRef = FirebaseStorage.instance.ref();
      final imagesRef = storageRef.child('users/${FirebaseAuth.instance.currentUser?.uid}/images/$name');

      try {
        await imagesRef.putData(data);
        String downloadUrl = await imagesRef.getDownloadURL();

        return downloadUrl;
      } on FirebaseException catch (e) {
        debugPrint('Error: $e');
      }

      return null;
    }

    return null;
  }

   static HomeViewModel of_(BuildContext context) => getModel<HomeViewModel>(context);
}