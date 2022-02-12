import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:core';

class RequestAssistant {
  static Future<dynamic> getRequest(String url) async {
    http.Response response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));

    try {
      if (response.statusCode == 200) {
        String jSonData = response.body;
        var decodeData = jsonDecode(jSonData);
        return decodeData;
      }
      else {
        return "failed";
      }
    }
    catch(exp) {
      return "failed";
    }

  }
}