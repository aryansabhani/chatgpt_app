import 'dart:developer';

import 'package:chatgpt_app/helper/chatgpthelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intl/intl.dart';

import '../modal/messageModal.dart';

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
    Navigator.pop(context);
    setState(() {
      scrollController
          .jumpTo(scrollController.positions.last.maxScrollExtent);
    });
  }

  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final s = MediaQuery.of(context).size;
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
                  controller: _userInput,
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
                    sendMessage();
                    _userInput.clear();
                    scrollController
                        .jumpTo(scrollController.positions.last.maxScrollExtent);
                  },
                  icon: Icon(Icons.send_outlined))
            ],
          ),
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
            ? Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: s.height * 0.20,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('asstes/image/gemini.png'),
                          fit: BoxFit.fitHeight),
                    ),
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      'Start Chatting...',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              )
            : ListView.builder(
                itemCount: messages.length,
                controller: scrollController,
                padding:
                    EdgeInsets.only(top: 50, bottom: 150, right: 15, left: 15),
                itemBuilder: (context, index) {
                  final message = messages[index];
                  return Column(
                    // crossAxisAlignment: CrossAxisAlignment.end,
                    // mainAxi
                    // sAlignment: MainAxisAlignment.,
                    children: [
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
                                  ? Colors.deepPurpleAccent
                                  : Colors.grey.shade400,
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
                              Text(
                                DateFormat('HH:mm').format(message.date),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: message.isUser
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              )
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
