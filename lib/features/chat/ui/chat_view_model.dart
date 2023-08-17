import 'package:abis_recipes/features/chat/models/baker_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code_on_the_rocks/code_on_the_rocks.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatViewModelBuilder extends ViewModelBuilder<ChatViewModel> {
  const ChatViewModelBuilder({
    super.key,
    required super.builder,
  });

  @override
  State<StatefulWidget> createState() => ChatViewModel();
}

class ChatViewModel extends ViewModel<ChatViewModel> {
  TextEditingController messageController = TextEditingController();

  void sendMessage() {
    if (messageController.text.isNotEmpty) {
      FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).collection('messages').add(BakerMessage(
            prompt: messageController.text,
            createdAt: DateTime.now(),
            response: null,
          ).toJson());
      messageController.clear();
    }
  }

  static ChatViewModel of_(BuildContext context) => getModel<ChatViewModel>(context);
}
