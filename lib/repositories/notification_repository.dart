import 'dart:convert';

import 'package:http/http.dart' as http;

class NotificationRepository {
  String url = 'https://fcm.googleapis.com/fcm/send';

  Future<void> sendNotification(String fcmToken, String notificationMessage, String name) async {
    Map<String, dynamic> body = {
      'notification': {
        'title': name,
        'body': notificationMessage,
      },
      'to': fcmToken,
    };

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer AAAALMk7eZQ:APA91bEjzsvNWw_Ew9cWL6JIEAyTCGHbP6c-ZUnk2rlBCiJZv--T9R7_OXTpgiL2KGJu4umUzIDygqS2Bq3827AfAS0OaBdK8DlpR1XPFmbkQvXPBDu9j1V6ZJAbVOt1arrVOgJ94Lp9', // Replace with your FCM server key
    };

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      print('Successsssss Status code: ${response.statusCode}');
      print('Notification sent successfully.');
    } else {
      print('Failed to send notification. Status code: ${response.statusCode}');
      throw Exception('Failed to send notification');
    }
  }
}
