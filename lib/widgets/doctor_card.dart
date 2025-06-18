import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

class DoctorCard {
  static Widget buildDoctorCard(Map<String, dynamic> doctorData) {
    Uri url;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 6),
            spreadRadius: 0,
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Header with name and status
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Doctor icon
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                  ),
                ),
                child: const Icon(
                  Icons.local_hospital_rounded,
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
                      doctorData['name'] ?? 'Unknown Doctor',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(doctorData['business_status'])
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        _getStatusText(doctorData['business_status']),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: _getStatusColor(doctorData['business_status']),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Rating and reviews
          if (doctorData['rating'] != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Row(
                    children: List.generate(5, (index) {
                      final rating = doctorData['rating']?.toDouble() ?? 0.0;
                      return Icon(
                        index < rating.floor()
                            ? Icons.star
                            : (index < rating
                                ? Icons.star_half
                                : Icons.star_border),
                        color: const Color(0xFFFBBF24),
                        size: 16,
                      );
                    }),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${doctorData['rating']?.toString() ?? 'N/A'} • ${doctorData['user_ratings_total']?.toString() ?? '0'} reviews',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 16),

          // Address
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.location_on_outlined,
                color: Color(0xFF6B7280),
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  doctorData['vicinity'] ?? 'Address not available',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),

          // Opening hours
          if (doctorData['opening_hours'] != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  color: doctorData['opening_hours']['open_now'] == true
                      ? const Color(0xFF10B981)
                      : const Color(0xFFEF4444),
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  doctorData['opening_hours']['open_now'] == true
                      ? 'Open Now'
                      : 'Closed',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: doctorData['opening_hours']['open_now'] == true
                        ? const Color(0xFF10B981)
                        : const Color(0xFFEF4444),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 24),

          // Enhanced Action button
          Container(
            width: double.infinity,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: const LinearGradient(
                colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6366F1).withOpacity(0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () async {
                  var address = doctorData['vicinity'];
                  log('address: $address');
                  url = Uri.parse(
                      "https://www.google.com/maps/search/?api=1&query=$address");
                  openMap(url);
                },
                child: const Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.directions_rounded,
                          size: 20, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Get Directions',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
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
    );
  }

  static Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'operational':
        return const Color(0xFF10B981);
      case 'closed_temporarily':
        return const Color(0xFFF59E0B);
      case 'closed_permanently':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF6B7280);
    }
  }

  static String _getStatusText(String? status) {
    switch (status?.toLowerCase()) {
      case 'operational':
        return 'Open';
      case 'closed_temporarily':
        return 'Temporarily Closed';
      case 'closed_permanently':
        return 'Permanently Closed';
      default:
        return status ?? 'Unknown';
    }
  }

  static Future<void> openMap(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
