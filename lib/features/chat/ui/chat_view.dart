import 'package:abis_recipes/app/constants.dart';
import 'package:abis_recipes/features/chat/models/baker_message.dart';
import 'package:abis_recipes/features/shared/ui/pastry_icon.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'chat_view_model.dart';

class ChatView extends StatelessWidget {
  const ChatView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChatViewModelBuilder(
      builder: (context, model) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Chat'),
            actions: [
              PastryIcon(pastry: Pastry.eclair, asset: 'assets/chef.png'),
              SizedBox(
                width: 16,
              )
            ],
          ),
          body: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: StreamBuilder<List<BakerMessage>>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser?.uid)
                          .collection('messages')
                          .orderBy('createdAt', descending: true)
                          .snapshots()
                          .map((event) => event.docs.map((e) => BakerMessage.fromJson(e.data())).toList()),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData && snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (!snapshot.hasData || snapshot.data == null) {
                          return Center(child: Text('No messages yet'));
                        }

                        if (snapshot.data!.isEmpty) {
                          return Center(
                              child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              PastryIcon(pastry: Pastry.eclair, asset: 'assets/chef.png', sideLength: 200),
                              Text('No messages yet'),
                            ],
                          ));
                        }

                        return ListView.builder(
                          reverse: true,
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          padding: const EdgeInsets.all(8),
                          itemBuilder: (context, index) {
                            BakerMessage message = snapshot.data![index];
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 48,
                                    ),
                                    Expanded(
                                      child: Card(
                                        child: ListTile(
                                          title: Text(message.prompt ?? ''),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (message.response != null)
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Card(
                                          child: ListTile(
                                            title: Text(
                                              message.response ?? '',
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          ),
                                          color: Theme.of(context).colorScheme.secondary,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 48,
                                      ),
                                    ],
                                  )
                                else
                                  Center(child: LinearProgressIndicator()),
                                if(index == 0)
                                  SizedBox(height: 100,)
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: model.messageController,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            isDense: true,
                            hintText: 'Ask me anything',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          model.sendMessage();
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                        icon: Icon(Icons.send),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
