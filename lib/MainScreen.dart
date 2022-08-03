import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:midterm_project/my_model.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

String _text = '';
String title = '';
var mytemp = '';
bool _isEditingText = false;
TextEditingController _editingController = TextEditingController();
class MainScreen  extends StatelessWidget {

  MainScreen({super.key, required this.mykey});
  final my_model mykey;


  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SpeechScreen(mykey:mykey),
    );
  }
}

class SpeechScreen extends StatefulWidget {
  const SpeechScreen({super.key, required this.mykey});
  final my_model mykey;


  @override
  _SpeechScreenState createState() => _SpeechScreenState(mykey:mykey);
}

class _SpeechScreenState extends State<SpeechScreen> {
  // _SpeechScreenState({required this.mykey});
  final my_model mykey;
  stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;



  _SpeechScreenState({required this.mykey}){
    _text = mykey.notes;
    title = mykey.title;

  }

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _editingController = TextEditingController(text: title);
  }

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: _editTitleTextField(),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  CollectionReference saving = FirebaseFirestore.instance.collection('NotesTable');
                  saving.doc(title).set({'Title':title, 'notes':_text+=mytemp}).then((value) => print('Data saved'));
                },
                child: Icon(
                  Icons.save,
                  size: 26.0,
                ),
              )
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: Theme.of(context).primaryColor,
        endRadius: 75.0,
        duration: const Duration(milliseconds: 2000),
        repeatPauseDuration: const Duration(milliseconds: 100),
        repeat: true,
        child: FloatingActionButton(
          onPressed: _listen,
          child: Icon(_isListening ? Icons.mic : Icons.mic_none),
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
          child: Text(
             '$_text $mytemp',
            style: const TextStyle(
              fontSize: 32.0,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            mytemp = " " + val.recognizedWords;
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }

  }
  Widget _editTitleTextField() {
    if (_isEditingText)
      return Center(
        child: TextField(
          onSubmitted: (newValue){
            setState(() {
              title = newValue;
              _isEditingText =false;
            });
          },
          autofocus: true,
          controller: _editingController,
        ),
      );
    return InkWell(
        onTap: () {
      setState(() {
        _isEditingText = true;
      });
    },
    child: Text(
    title,
    style: TextStyle(
    color: Colors.white,
    fontSize: 20.0,
    ),
    ));

  }
}
