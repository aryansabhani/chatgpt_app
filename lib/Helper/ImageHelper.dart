import 'dart:developer';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

class ImageGenHelper {
  ImageGenHelper._();

  static final ImageGenHelper imageGenHelper = ImageGenHelper._();

  String apiUrl = 'https://api.vyro.ai/v1/imagine/api/generations';

  Future<dynamic> GeneratImage({String prompt = ''}) async {
    try {
      Map<String, dynamic> headers = {
        'Authorization':
        'Bearer vk-k9qtHQEhVHEAKMD5iWEg6X6DEDpe3qEP4qgpoDbf9sxTW'
      };

      Map<String, dynamic> payload = {
        'prompt': prompt,
        'style_id': '31',
      };

      FormData formData = FormData.fromMap(payload);

      Dio dio = Dio();
      dio.options =
          BaseOptions(headers: headers, responseType: ResponseType.bytes);

      final response = await dio.post(apiUrl, data: formData);
      if (response.statusCode == 200) {
        Uint8List uint8List = Uint8List.fromList(response.data);
        log('${uint8List.length}');
        return uint8List;
      } else {
        log('Failed to imagin data: ${response.statusCode}');

        return null;
      }
    } catch (e) {
      log('Exception while imagining data: $e');
      return null;
    }
  }
}