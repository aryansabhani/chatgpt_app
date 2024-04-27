// import 'dart:html';
import 'dart:io';
import 'dart:typed_data';

import 'package:chatgpt_app/helper/ImageHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../Controller/ImageController.dart';
import '../../Controller/ThemeController.dart';

class ImagePage extends StatefulWidget {
  ImagePage({super.key});

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  TextEditingController textcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final s = MediaQuery.of(context).size;
    return Scaffold(
      bottomSheet: Container(
        height: s.height * 0.1,
        alignment: Alignment.center,
        padding: EdgeInsets.all(12),
        // color: Provider.of<ThemeController>(context).isDarkMode ? Color(0xFF121212) : Colors.white,
        child: TextFormField(
          // style: TextStyle(color: Colors.white),
          controller: textcontroller,

          decoration: InputDecoration(
              suffixIcon: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: IconButton(
                    padding: EdgeInsets.all(12),
                    // iconSize: 30,
                    style: ButtonStyle(
                        backgroundColor:
                            Provider.of<ThemeController>(context).isDarkMode
                                ? MaterialStateProperty.all(Colors.black26)
                                : MaterialStateProperty.all(Color(0xffEB8A71)),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
                        shape: MaterialStateProperty.all(CircleBorder())),
                    onPressed: () {
                      SystemChannels.textInput.invokeMethod('TextInput.hide');
                      if (textcontroller.text.isNotEmpty) {
                        Provider.of<ImageController>(context, listen: false)
                            .ImaginApi(textcontroller.text);
                        textcontroller.clear();
                        // scrollController
                        //     .jumpTo(scrollController.positions.last.maxScrollExtent);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Please Enter Something'),
                        ));
                      }
                    },
                    icon: Provider.of<ImageController>(context).isLoading
                        ? CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Icon(Icons.telegram)),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              label: Text('Enter Your Prompt')),
        ),
      ),
      body: Consumer<ImageController>(builder: (context, pro, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (pro.image.isNotEmpty)
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
                                    pro.image,
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
                    child: Text(
                      'Type Something To Generate Image',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  )),
          ],
        );
      }),
    );
  }
}
