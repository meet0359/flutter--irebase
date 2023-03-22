import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fire/utils/utils.dart';

import '../../widgets/round_button.dart';

class AddFireStoreDataScreen extends StatefulWidget {
  const AddFireStoreDataScreen({super.key});

  @override
  State<AddFireStoreDataScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddFireStoreDataScreen> {
  final postController = TextEditingController();
  bool loding = false;
  final fireStore = FirebaseFirestore.instance.collection('user');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Firestore data'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            TextFormField(
              controller: postController,
              maxLines: 4,
              decoration: const InputDecoration(
                  hintText: 'What is in your mind?',
                  border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 30,
            ),
            RoundButton(
              title: 'Add',
              loading: loding,
              onTap: () {
                setState(() {
                  loding = true;
                });
                String id = DateTime.now().millisecondsSinceEpoch.toString();
                fireStore.doc(id).set({
                  'title': postController.text.toString(),
                  'id': id
                }).then((value) {setState(() {
                  loding = true;
                });
                  Utils().toastMessage('post added');
                }).onError((error, stackTrace) {
                  setState(() {
                  loding = true;
                });
                  Utils().toastMessage(error.toString());
                  
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
