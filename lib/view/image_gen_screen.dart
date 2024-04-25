// import 'dart:html';
import 'dart:io';
import 'dart:typed_data';

import 'package:chatgpt_app/helper/imagehelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class ImagePage extends StatefulWidget {
  ImagePage({super.key});

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  TextEditingController textcontroller = TextEditingController();

  List<Uint8List> images = [];

  Uint8List img = Uint8List(0);

  void ImaginApi(String prompt) async {
    img = await await ImageGenHelper.imageGenHelper
            .GeneratImage(prompt: prompt) ??
        [];

    if (img.isNotEmpty) {
      images.add(img);
    }
    Navigator.pop(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                flex: 15,
                child: TextFormField(
                  // style: TextStyle(color: Colors.white),
                  controller: textcontroller,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      label: Text('Enter Your Message')),
                ),
              ),
              Spacer(),
              IconButton(
                  padding: EdgeInsets.all(12),
                  // iconSize: 30,
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.deepPurpleAccent),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      shape: MaterialStateProperty.all(CircleBorder())),
                  onPressed: () {
                    SystemChannels.textInput.invokeMethod('TextInput.hide');
                    showDialog(
                      context: context,
                      builder: (context) {
                        return PopScope(
                            canPop: false,
                            child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.2)),
                                height: double.maxFinite,
                                width: double.maxFinite,
                                alignment: Alignment.center,
                                child: Container(
                                    height: 30,
                                    width: 30,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ))),
                            onPopInvoked: (val) async {});
                      },
                    );
                    if (textcontroller.text.isNotEmpty) {
                      ImaginApi(textcontroller.text);
                      textcontroller.clear();
                      // scrollController
                      //     .jumpTo(scrollController.positions.last.maxScrollExtent);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Please Enter Something'),
                      ));
                    }
                  },
                  icon: Icon(Icons.send_outlined))
            ],
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (img.isNotEmpty)
            Expanded(
                flex: 8,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 30,
                    left: 16,
                    right: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          flex: 3,
                          child: Center(
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(24),
                                child: Image.memory(
                                  img,
                                  fit: BoxFit.cover,
                                )),
                          )),
                    ],
                  ),
                ))
          else
            Expanded(
              flex: 8,
              child: Center(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Start Generating Images \nwith your imngine....',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
