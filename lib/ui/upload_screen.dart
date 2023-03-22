import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fire/utils/utils.dart';
import 'package:flutter_fire/widgets/round_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({super.key});

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  bool loading=false;
  File? _image;
  final picker = ImagePicker();

  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  DatabaseReference databaseRef=FirebaseDatabase.instance.ref('Post');

  Future getImageGallary() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        debugPrint('no image picked');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Image'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: InkWell(
          onTap: () {
            getImageGallary();
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  height: 200,
                  width: 200,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  child: _image != null
                      ? Image.file(_image!.absolute)
                      : const Center(child: Icon(Icons.image)),
                ),
              ),
              const SizedBox(
                height: 39,
              ),
              RoundButton(
                  title: 'Upload', loading: loading,onTap: () async {
                    setState(() {
                      loading=true;
                    });
                    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref('/images/${DateTime.now().millisecondsSinceEpoch}');
                    firebase_storage.UploadTask uploadTask = ref.putFile(_image!.absolute);

                     Future.value(uploadTask).then((value) async{
                      var newurl= await ref.getDownloadURL();

                      databaseRef.child('1').set({
                        'id':'1212',
                        'title':newurl.toString()

                      }).then((value)  {
                        setState(() {
                          loading=false;
                        });
                        Utils().toastMessage('Uploaded');
                      }).onError((error, stackTrace) {
                        setState(() {
                          loading=false;
                        });
                      });
                      Utils().toastMessage('Uploaded');
                    }).onError((error, stackTrace) {
                      Utils().toastMessage(error.toString());
                    });

                  })
            ],
          ),
        ),
      ),
    );
  }
}
