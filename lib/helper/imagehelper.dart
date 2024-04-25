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
        'Bearer vk-OX2hbLYKIBjxYDLPUj4LjJto2PN2s33I4Nb2LH0F7N2SFD0J	'
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
        return uint8List;
      } else {
        print('Failed to imagin data: ${response.statusCode}');

        return null;
      }
    } catch (e) {
      print('Exception while imagining data: $e');
      return null;
    }
  }
}