import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

Future<String> fetchAffirmation() async {
  final response =
  await http.get(Uri.parse('https://www.affirmations.dev/'));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    if(kDebugMode){
      print('fetchAffirmation - success: $data');
    }
    return data['affirmation'];
  } else {
    if(kDebugMode){
      print('fetchAffirmation - failed... response: ${response.statusCode}, ${response.body}');
    }
    throw Exception('Failed to load affirmation');
  }
}