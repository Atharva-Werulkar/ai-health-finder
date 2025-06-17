import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

class DoctorCard {
  static Widget buildDoctorCard(Map<String, dynamic> doctorData) {
    Uri url;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 20,
      ),
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Name: ${doctorData['name']}',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          Text('Status: ${doctorData['business_status']}'),
          Text('Rating: ${doctorData['rating']}'),
          Text('Total User Ratings: ${doctorData['user_ratings_total']}'),
          Text('Address: ${doctorData['vicinity']}'),
          if (doctorData['opening_hours'] != null)
            Text(
                'Open Now: ${doctorData['opening_hours']['open_now'] ? 'Yes' : 'No'}'),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: Colors.teal,
            ),
            onPressed: () async {
              // url = Uri.parse(
              //     "https://www.google.com/maps/search/?api=1&query=$lat,$lng");
              //
              // openMap(url);

              var address = doctorData['vicinity'];
              log('address: $address');
              url = Uri.parse(
                  "https://www.google.com/maps/search/?api=1&query=$address");
              openMap(url);
            },
            child: const Text(
              'Get Directions',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  static Future<void> openMap(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
