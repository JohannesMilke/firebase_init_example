import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final String title = 'Set up Firebase & Flutter';

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: title,
        theme: ThemeData(primarySwatch: Colors.deepOrange),
        home: MainPage(title: title),
      );
}

class MainPage extends StatefulWidget {
  final String title;

  const MainPage({
    @required this.title,
  });

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool isUploaded = false;

  @override
  void initState() {
    super.initState();

    upload();
  }

  Future upload() async {
    /// Initialize Firebase
    await Firebase.initializeApp();

    /// Upload document to firestore
    final refUser = FirebaseFirestore.instance.collection('user').doc();
    await refUser.set({'username': 'alex'});

    /// Upload file to firebase storage - web not supported yet
    if (!kIsWeb) {
      final response = await http.get(
          'https://www.talkwalker.com/images/2020/blog-headers/image-analysis.png');
      final imageBytes = response.bodyBytes;

      final refImage = FirebaseStorage().ref().child('images/example.png');
      final uploadTask = refImage.putData(imageBytes);
      await uploadTask.onComplete;
    }

    setState(() {
      isUploaded = true;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Text(
          isUploaded ? 'Uploaded!' : 'Uploading...',
          style: TextStyle(fontSize: 24),
        ),
      ));
}
