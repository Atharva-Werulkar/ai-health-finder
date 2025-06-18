// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:aimsc/widgets/doctor_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:google_fonts/google_fonts.dart';

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
  GenerativeModel? _model;
  ChatSession? _chat;

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

    // Check if API keys are loaded
    if (!areApiKeysLoaded) {
      log('Warning: API keys not properly loaded from .env file');
    } // Initialize the GenerativeModel with the API key
    if (geminiApiKey.isNotEmpty) {
      _model = GenerativeModel(
        model: 'gemini-2.0-flash',
        apiKey: geminiApiKey,
      );
      _chat = _model?.startChat();
      log('Chat started successfully with Gemini model');
    } else {
      log('Error: Gemini API key not available');
    }

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
      backgroundColor: const Color(0xFFFAFAFA),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Minimal App Bar
          SliverAppBar.large(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: false,
            pinned: true,
            expandedHeight: 120,
            flexibleSpace: FlexibleSpaceBar(
              title: Row(
                children: [
                  Container(
                    width: 8,
                    height: 32,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'AI Health',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0F172A),
                      fontSize: 28,
                    ),
                  ),
                ],
              ),
              titlePadding: const EdgeInsets.only(left: 24, bottom: 16),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFFAFAFA), Color(0xFFF1F5F9)],
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),

                  // Greeting Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6366F1).withOpacity(0.08),
                          blurRadius: 32,
                          offset: const Offset(0, 8),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF6366F1),
                                    Color(0xFF8B5CF6)
                                  ],
                                ),
                              ),
                              child: const Icon(
                                Icons.health_and_safety_rounded,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Hello there! 👋',
                                    style: GoogleFonts.inter(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF0F172A),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Describe your symptoms and I\'ll help you find the right specialist',
                                    style: GoogleFonts.inter(
                                      fontSize: 15,
                                      color: const Color(0xFF64748B),
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 28), // Enhanced Text Input
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(0xFFE2E8F0),
                              width: 1,
                            ),
                          ),
                          child: TextField(
                            controller: _controller,
                            maxLines: 4,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              color: const Color(0xFF0F172A),
                              height: 1.5,
                            ),
                            decoration: InputDecoration(
                              hintText:
                                  'Tell me about your symptoms...\n\nExample: "I have a persistent headache and feel dizzy when I stand up"',
                              hintStyle: GoogleFonts.inter(
                                color: const Color(0xFF94A3B8),
                                fontSize: 15,
                                height: 1.6,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(24),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Enhanced Action Button
                        Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: _loading
                                ? const LinearGradient(
                                    colors: [
                                      Color(0xFFCBD5E1),
                                      Color(0xFF94A3B8)
                                    ],
                                  )
                                : const LinearGradient(
                                    colors: [
                                      Color(0xFF6366F1),
                                      Color(0xFF8B5CF6)
                                    ],
                                  ),
                            boxShadow: _loading
                                ? []
                                : [
                                    BoxShadow(
                                      color: const Color(0xFF6366F1)
                                          .withOpacity(0.3),
                                      blurRadius: 20,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: _loading
                                  ? null
                                  : () async {
                                      if (_controller.text.trim().isEmpty) {
                                        _showErrorSnackBar(
                                            'Please describe your symptoms first');
                                        return;
                                      }
                                      await _sendChatMessage(
                                          "${_controller.text} "
                                          " What is the medical specialist of the doctor? give one word answer");
                                    },
                              child: Center(
                                child: _loading
                                    ? const SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.psychology_rounded,
                                            color: Colors.white,
                                            size: 22,
                                          ),
                                          const SizedBox(width: 12),
                                          Text(
                                            'Analyze Symptoms',
                                            style: GoogleFonts.inter(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // AI Response Section
                  if (_messages.isNotEmpty) ...[
                    const Text(
                      'AI Analysis',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ..._messages,
                  ],

                  // Loading Animation
                  if (_loading && _messages.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Column(
                        children: [
                          SpinKitThreeBounce(
                            color: Color(0xFF00B4D8),
                            size: 30,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'AI is analyzing your symptoms...',
                            style: TextStyle(
                              color: Color(0xFF6B7280),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Doctors Section
          if (_category.isNotEmpty && !_loading)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.location_on,
                            color: Color(0xFF10B981),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Nearby Doctors',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

          // Doctors List
          if (_category.isNotEmpty && !_loading)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              sliver: FutureBuilder(
                future: Backend.fetchDoctors(_category, context),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return SliverToBoxAdapter(
                        child: Container(
                          padding: const EdgeInsets.all(40),
                          child: const Center(
                            child: SpinKitThreeBounce(
                              color: Color(0xFF00B4D8),
                              size: 30,
                            ),
                          ),
                        ),
                      );
                    case ConnectionState.done:
                      if (snapshot.hasError) {
                        return SliverToBoxAdapter(
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEF2F2),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(0xFFFECACA),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  color: Color(0xFFEF4444),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Error: ${snapshot.error}',
                                    style: const TextStyle(
                                      color: Color(0xFFEF4444),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        _doctors = snapshot.data as List;
                        return SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child:
                                    DoctorCard.buildDoctorCard(_doctors[index]),
                              );
                            },
                            childCount: _doctors.length,
                          ),
                        );
                      }
                    default:
                      return const SliverToBoxAdapter(child: SizedBox.shrink());
                  }
                },
              ),
            ),

          // Bottom Spacing
          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),
    );
  }

  String getChatHistory() {
    if (_chat == null) return '';
    return _chat!.history.map((content) {
      return content.parts
          .whereType<TextPart>()
          .map<String>((e) => e.text)
          .join('');
    }).join('\n');
  }

  Future<void> _sendChatMessage(String message) async {
    if (_chat == null) {
      _showErrorSnackBar(
          'AI service is not available. Please check your API configuration.');
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      var response = await _chat!.sendMessage(
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

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFEF4444),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
