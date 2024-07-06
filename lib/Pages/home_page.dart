import 'package:chat_app_material3/Pages/chat_page.dart';
import 'package:chat_app_material3/Utils.dart';
import 'package:chat_app_material3/Widgets/chat_tile.dart';
import 'package:chat_app_material3/services/alert_service.dart';
import 'package:chat_app_material3/services/auth_service.dart';
import 'package:chat_app_material3/services/db_service.dart';
import 'package:chat_app_material3/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                bool result = await GetIt.instance.get<AuthService>().logout();
                if (result) {
                  GetIt.instance.get<AlertService>().showAlert(
                      content: "Successfully loged out!", icon: Icons.check);
                  GetIt.instance
                      .get<NavigationService>()
                      .pushReplacementNamed("/login");
                } else {}
              },
              icon: const Icon(
                Icons.logout,
                size: 30,
                color: Color.fromARGB(255, 252, 118, 108),
              ))
        ],
        title: const Text('Chats'),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: _chatsList(),
      ),
    );
  }

  Widget _chatsList() {
    return StreamBuilder(
      stream: GetIt.instance.get<DbService>().getUsers(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text("Unable to load data"),
          );
        }
        if (snapshot.hasData && snapshot.data != null) {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: ChatTile(
                  userModel: snapshot.data!.docs[index].data(),
                  ontap: () async {
                    final chatExists = await getService<DbService>()
                        .doesChatExists(
                            uid1: snapshot.data!.docs[index].data().uid!,
                            uid2: getService<AuthService>().user!.uid);
                    if (!chatExists) {
                      GetIt.instance.get<DbService>().createNewChat(
                          uid1: snapshot.data!.docs[index].data().uid!,
                          uid2: getService<AuthService>().user!.uid);
                    }
                    GetIt.instance
                        .get<NavigationService>()
                        .push(MaterialPageRoute(
                          builder: (context) => ChatPage(
                              chatWith: snapshot.data!.docs[index].data()),
                        ));
                  },
                ),
              );
            },
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
