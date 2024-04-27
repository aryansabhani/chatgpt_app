import 'package:chatgpt_app/Helper/ImageHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ImageController extends ChangeNotifier {
  List<Uint8List> images = [];

  Uint8List image = Uint8List(0);
  bool isLoading = false;

  void ImaginApi(String prompt) async {
    isLoading = true;
    notifyListeners();
    image =
        await await ImageGenHelper.imageGenHelper.GeneratImage(prompt: prompt) ??
            [];

    if (image.isNotEmpty) {
      images.add(image);
    }

    isLoading = false;
    notifyListeners();
  }
}