import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../Controller/ThemeController.dart';
import '../../modal/MessageModal.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _userInput = TextEditingController();
  static const apiKey = "AIzaSyC0iEmjo8qRZHk2Wroz6fPimZ5uHyRmnlI";
  final model = GenerativeModel(
    model: 'gemini-pro',
    apiKey: apiKey,
  );

  static List<Message> messages = [];

  bool isLoading = false;

  Future<void> sendMessage() async {
    final message = _userInput.text;

    messages.add(Message(isUser: true, message: message, date: DateTime.now()));

    setState(() {});

    try {
      final content = [Content.text(message)];
      final response = await model.generateContent(content);
      messages.add(Message(
          isUser: false, message: response.text ?? "", date: DateTime.now()));
    } on GenerativeAIException catch (e) {
      // Handle the error here.
      print(e.message);
      messages.add(Message(
          isUser: false,
          message: 'Sorry we can not give you an answer' ?? "",
          date: DateTime.now()));
    }
    setState(() {});
    // Navigator.pop(context);
    setState(() {
      scrollController.jumpTo(scrollController.positions.last.maxScrollExtent);
    });

    isLoading = false;
  }

  ScrollController scrollController = ScrollController();

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
          controller: _userInput,

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
                      isLoading = true;
                      sendMessage();
                      _userInput.clear();
                    },
                    icon: isLoading
                        ? CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Icon(Icons.telegram)),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              label: Text('Enter Your Question')),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
            // image: DecorationImage(
            //     colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.8), BlendMode.dstATop),
            //     image: NetworkImage('https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEigDbiBM6I5Fx1Jbz-hj_mqL_KtAPlv9UsQwpthZIfFLjL-hvCmst09I-RbQsbVt5Z0QzYI_Xj1l8vkS8JrP6eUlgK89GJzbb_P-BwLhVP13PalBm8ga1hbW5pVx8bswNWCjqZj2XxTFvwQ__u4ytDKvfFi5I2W9MDtH3wFXxww19EVYkN8IzIDJLh_aw/s1920/space-soldier-ai-wallpaper-4k.webp'),
            //     fit: BoxFit.cover
            // )
            ),
        child: messages.length == 0
            ? Center(
                child: Text(
                  'Ask anything, get yout answer',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              )
            : ListView.builder(
                itemCount: messages.length,
                controller: scrollController,
                padding:
                    EdgeInsets.only(top: 50, bottom: 150, right: 15, left: 15),
                itemBuilder: (context, index) {
                  final message = messages[index];
                  return Column(
                    // mainAxi
                    // sAlignment: MainAxisAlignment.,
                    children: [                    // crossAxisAlignment: CrossAxisAlignment.end,

                      Align(
                        alignment: message.isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          // width: double.infinity,
                          // margin: EdgeInsets.only(right: 10, left: 10),
                          padding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 8),

                          // margin: EdgeInsets.symmetric(vertical: 15).copyWith(
                          //     left: message.isUser
                          //         ? message.message.length > 10
                          //             ? 150
                          //             : s.width * 0.6
                          //         : 10,
                          //     right: message.isUser ? 10 : 150),
                          decoration: BoxDecoration(
                              color: message.isUser
                                  ? Color(0xffEB8A71)
                                  : Provider.of<ThemeController>(context).isDarkMode ? Colors.white70 :Colors.black12 ,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: message.isUser
                                      ? Radius.circular(10)
                                      : Radius.zero,
                                  topRight: Radius.circular(10),
                                  bottomRight: message.isUser
                                      ? Radius.zero
                                      : Radius.circular(10))),
                          child: Column(
                            crossAxisAlignment: message.isUser
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              Text(
                                message.message,
                                style: TextStyle(
                                    fontSize: 16,
                                    color: message.isUser
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  );
                  // return Messages(isUser: message.isUser, message: message.message, date: DateFormat('HH:mm').format(message.date));
                }),
      ),
    );
  }
}
