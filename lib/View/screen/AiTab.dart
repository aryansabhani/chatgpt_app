import 'package:chatgpt_app/view/screen/ChatScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Controller/ThemeController.dart';
import 'ImageScreen.dart';

class AiTab extends StatefulWidget {
  const AiTab({super.key});

  @override
  State<AiTab> createState() => _AiTabState();
}

/// [AnimationController]s can be created with `vsync: this` because of
/// [TickerProviderStateMixin].
class _AiTabState extends State<AiTab> with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(onPressed: () {
        //
        // }, icon: Icon(Icons.refresh, color: Colors.white)),
        // backgroundColor: Provider.of<ThemeController>(context).isDarkMode ? Colors.black : Color(0xffEB8A71),
        title: Text(
          'AI',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(onPressed: () {
            Provider.of<ThemeController>(context, listen: false).changeTheme();
          }, icon: Icon(Provider.of<ThemeController>(context).isDarkMode ? Icons.dark_mode : Icons.sunny, color: Colors.white)),
        ],
        centerTitle: true,
        // leading: Icon(Icons.),
        bottom: TabBar(
          indicatorColor: Colors.white,
          indicatorWeight: 3.0,
          indicatorSize: TabBarIndicatorSize.tab,
          controller: _tabController,
          tabs: const <Widget>[
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.chat_outlined, color: Colors.white),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Chat',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              // text: 'Chat Bot',
              // icon: Icon(Icons.voice_chat_outlined,color: Colors.white,),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.image, color: Colors.white),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Image',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              // text: 'Chat Bot',
              // icon: Icon(Icons.voice_chat_outlined,color: Colors.white,),
            ),

          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[ChatScreen(), ImagePage()],
      ),
    );
  }
}
