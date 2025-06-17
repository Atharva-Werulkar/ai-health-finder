// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:aimsc/widgets/doctor_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import 'package:aimsc/utils/constants.dart';
import 'package:aimsc/widgets/messagecard.dart';

import 'package:aimsc/backend.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Initialize the GenerativeModel and ChatSession
  late final GenerativeModel _model;
  late final ChatSession _chat;

  // Initialize the TextEditingController
  final TextEditingController _controller = TextEditingController();

  // Initialize the variables
  String _category = '';
  List _doctors = [];

  // Initialize the loading variable and the list of messages
  bool _loading = false;
  final List<MessageWidget> _messages = [];

  @override
  void initState() {
    super.initState();

    // Initialize the GenerativeModel with the API key
    _model = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: geminiApiKey,
    );
    _chat = _model.startChat();

    log('Chat started successfully. $_model');

// Request location permission
    requestPermission().then((_) {
      log('Location permission granted');
    }).catchError((e) {
      log('Location permission denied: $e');
    });
  }

  Future<void> requestPermission() async {
    // Request location permission
    var permission = await Permission.locationWhenInUse.request();

    if (permission == PermissionStatus.granted) {
      // Permission granted
      return;
    } else {
      // Permission denied
      throw Exception('Location permission denied');
    }
  }

  //Main UI

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3E3E3),
      appBar: AppBar(
        backgroundColor: const Color(0xFF328B8C),
        title: const Text('AI-MSC',
            style: TextStyle(
              color: Colors.white,
            )),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          Flex(
            direction: Axis.vertical,
            children: [
              ListView(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                children: [
                  //message which say's hello user
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10),
                    child: Container(
                      alignment: Alignment.topLeft,
                      child: const Text(
                        'Hello, User! ',
                        style: TextStyle(
                          fontSize: 30,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  // add the text-field to enter Medical Transcription
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10),
                    child: Container(
                      alignment: Alignment.topLeft,
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: 'Enter your Description here',
                        ),
                        controller: _controller,
                        autocorrect: true,
                      ),
                    ),
                  ),

                  //the button to send the message to the chat
                  GestureDetector(
                    onTap: () async {
                      //use gemini to give tips
                      if (_controller.text.isEmpty) {
                        return;
                      } else {
                        await _sendChatMessage("${_controller.text} "
                            " What is the medical specialist of the doctor? give one word answer");
                      }
                    },
                    child: const MessageWidget(
                        userIcon: IconData(0xe37c, fontFamily: 'MaterialIcons'),
                        iconColor: Colors.amberAccent,
                        text: 'Suggest Medical Specialist',
                        isFromUser: true),
                  ),

                  //show the elements of the list
                  ..._messages,

                  //show the loading animation
                  if (_loading)
                    const Center(
                        child: SpinKitThreeBounce(
                      color: Color(0xFF328B8C),
                      size: 40,
                    )),

                  //remove the loading animation
                  if (!_loading)
                    const SizedBox(
                      height: 10,
                    ),
                ],
              ),
            ],
          ),

          //if the api returns the list of doctors then show the list of doctors

          //Doctor Location Nearby text
          if (_category.isNotEmpty && !_loading)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Container(
                alignment: Alignment.topLeft,
                child: const Text(
                  'Doctors Nearby',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

          if (_category.isNotEmpty && !_loading)
            FutureBuilder(
              future: Backend.fetchDoctors(_category, context),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const Center(
                      child: SpinKitThreeBounce(
                        color: Color(0xFF328B8C),
                        size: 40,
                      ),
                    );
                  case ConnectionState.done:
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else {
                      _doctors = snapshot.data as List;
                      return Expanded(
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: _doctors.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10),
                              child:
                                  DoctorCard.buildDoctorCard(_doctors[index]),
                            );
                          },
                        ),
                      );
                    }
                  default:
                    return Container(); // Return an empty container by default
                }
              },
            ),
        ],
      ),
    );
  }

  String getChatHistory() {
    return _chat.history.map((content) {
      return content.parts
          .whereType<TextPart>()
          .map<String>((e) => e.text)
          .join('');
    }).join('\n');
  }

  Future<void> _sendChatMessage(String message) async {
    setState(() {
      _loading = true;
    });

    try {
      var response = await _chat.sendMessage(
        Content.text(message),
      );

      log(response.text.toString());

      var text = response.text;

      if (text == null) {
        Backend.showError('No response from API.', context);
        return;
      } else {
        setState(() {
          _loading = false;
          // Clear the messages list and add a new MessageWidget with the response text and the description
          _messages.clear();
          _messages.add(MessageWidget(
            text: "${_controller.text} - $text",
            isFromUser: false,
            // Call the fetchDoctors function
          ));
          _category = text;
        });
      }
    } catch (e) {
      Backend.showError(e.toString(), context);
      setState(() {
        _loading = false;
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }
}
