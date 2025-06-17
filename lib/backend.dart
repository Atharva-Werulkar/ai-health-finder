// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'package:aimsc/utils/constants.dart';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class Backend {
  static Future<List> getNearbyDoctors(
      String specialist, Position position) async {
    // Use the Google Places API to search for doctors of that specialty near the user's location
    String url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${position.latitude},${position.longitude}&radius=5000&type=doctor&keyword=$specialist&key=$mapApiKey';

    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      // Parse the data to get the list of doctors
      List doctors = data['results'];
      log(doctors.toString());

      return doctors;
    } else {
      throw Exception('Failed to load doctors');
    }
  }

  static Future<List> fetchDoctors(String text, BuildContext context) async {
    Position? position;
    try {
      // Check if location permission is granted
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        // Request location permission
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse &&
            permission != LocationPermission.always) {
          showError('Location permission denied', context);
        }
      }

      // Get user location
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      log('Location: $position');
    } catch (e) {
      showError('Failed to get location: $e', context);
    }
    // Get the list of doctors
    var doctors = await Backend.getNearbyDoctors(text, position!);
    return doctors;
  }

  static void showError(String message, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Something went wrong',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          content: SingleChildScrollView(
            child: SelectableText(
              message,
              style: const TextStyle(color: Colors.black),
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.black),
              ),
            )
          ],
        );
      },
    );
  }
}
