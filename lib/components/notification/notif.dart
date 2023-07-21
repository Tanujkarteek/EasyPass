import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NotifHitter {
  final String url = 'https://notificate.vercel.app/notifwarden';

  Future<void> hitUrl() async {
    try {
      debugPrint("hello");
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        // Request was successful
        debugPrint('URL hit successfully');
      } else {
        // Request failed
        debugPrint('Failed to hit the URL');
      }
    } catch (e) {
      // An error occurred during the request
      debugPrint('Error: $e');
    }
  }
}
