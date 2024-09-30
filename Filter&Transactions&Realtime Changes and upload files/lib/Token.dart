import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyToken extends StatefulWidget {
  const MyToken({super.key});

  @override
  State<MyToken> createState() => _MyTokenState();
}

class _MyTokenState extends State<MyToken> {
  String? token;

  @override
  void initState() {
    super.initState();
    _requestPermission();
    _getToken();
  }

  // Requesting notification permissions
  void _requestPermission() async {
    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  // Getting the token
  void _getToken() async {
    token = await FirebaseMessaging.instance.getToken();
    print("token=");
    print("$token");
    setState(() {}); // Update the UI after getting the token

    // Call the function to send request with the token
    if (token != null) {
      await sendRequestWithToken(token!);
    }
  }

  Future<void> sendRequestWithToken(String accessToken) async {
    final url =
        'https://fcm.googleapis.com/v1/projects/secondprojectoffirebase/messages:send';
    // Construct the request body
    final body = {
      "message": {
        "token": accessToken, // This is the device token you obtained
        "notification": {
          "title": "Test Notification",
          "body": "This is a test notification from Flutter"
        },
      },
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization':
            'Bearer $accessToken', // Ensure this is a valid access token
        'Content-Type': 'application/json',
      },
      body: json.encode(body), // Encode the body as JSON
    );

    if (response.statusCode == 200) {
      // Successfully received response
      var data = json.decode(response.body);
      print('Response data: $data');
    } else {
      // Handle error
      print('Request failed with status: ${response.statusCode}');
      print('Response body: ${response.body}');
    }

    // Print the access token
    print("Access Token: $accessToken");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Messaging")),
      body: Center(
        child: token != null ? Text("Token: $token") : Text("Getting token..."),
      ),
    );
  }
}
