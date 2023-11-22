import 'dart:convert';

import 'package:http/http.dart' as http;

class APIHelper {
  APIHelper();

  static String get baseURL => "https://8995-106-197-214-219.ngrok-free.app";

  static Future<Map<String, dynamic>> register(
      String username, String password) async {
    Map<String, dynamic> result = new Map();
    result['success'] = false;

    Uri url =
        Uri.parse('$baseURL/register/?user_name=$username&password=$password');
    var response = await http.post(url);

    print(
        'post $url Response: ${response.body} ${response.statusCode} ${response.headers}}');

    Map<String, dynamic> responseObject = json.decode(response.body);
    if (responseObject.containsKey("user_id")) {
      result['success'] = true;
      result["user_id"] = responseObject['user_id'];
      result["user_name"] = responseObject['user_name'];
    } else {
      result['detail'] = responseObject['detail'];
    }

    return result;
  }

  static Future<Map<String, dynamic>> login(
      String username, String password) async {
    Map<String, dynamic> result = new Map();
    result['success'] = false;

    print("sdfjk");
    Uri url =
        Uri.parse('$baseURL/login/?user_name=$username&password=$password');
    var response = await http.post(url);

    print(
        'get $url Response: ${response.body} ${response.statusCode} ${response.headers}}');

    Map<String, dynamic> responseObject = json.decode(response.body);
    if (responseObject.containsKey('user_id')) {
      result['success'] = true;
      result["user_id"] = responseObject['user_id'];
      result["user_name"] = responseObject['user_name'];
    } else {
      result['detail'] = responseObject['detail'];
    }

    return result;
  }

  static Future<Map<String, dynamic>> createSensor(
      int owner_id, int make_id) async {
    Map<String, dynamic> result = new Map();
    result['success'] = false;

    Uri url =
        Uri.parse('$baseURL/sensors/?owner_id=$owner_id&make_id=$make_id');
    var response = await http.post(url);

    print(
        'post $url Response: ${response.body} ${response.statusCode} ${response.headers}}');

    if (response.statusCode == 200) {
      result['success'] = true;
      result["sensor_id"] = json.decode(response.body);
    } else {
      Map<String, dynamic> responseObject = json.decode(response.body);
      result['detail'] = responseObject['detail'];
    }

    return result;
  }

  static Future<Map<String, dynamic>> getSensors(int owner_id) async {
    Map<String, dynamic> result = new Map();
    result['success'] = false;

    Uri url = Uri.parse('$baseURL/sensors/?owner_id=$owner_id');
    var response = await http.get(url);

    print(
        'get $url Response: ${response.body} ${response.statusCode} ${response.headers}}');

    if (response.statusCode != 200) {
      Map<String, dynamic> responseObject = json.decode(response.body);
      result['detail'] = responseObject['detail'];
    } else {
      result['success'] = true;
      result["sensors"] = json.decode(response.body);
    }

    return result;
  }

  static Future<Map<String, dynamic>> getMakes() async {
    Map<String, dynamic> result = new Map();
    result['success'] = false;

    Uri url = Uri.parse('$baseURL/makes');
    var response = await http.get(url);

    print(
        'get $url Response: ${response.body} ${response.statusCode} ${response.headers}}');

    if (response.statusCode != 200) {
      Map<String, dynamic> responseObject = json.decode(response.body);
      result['detail'] = responseObject['detail'];
    } else {
      result['success'] = true;
      result["makes"] = json.decode(response.body);
    }

    return result;
  }

  static Future<Map<String, dynamic>> getObservations(
      int user_id, int sensor_id,
      [int start_time = 0, int end_time = 0]) async {
    Map<String, dynamic> result = new Map();
    result['success'] = false;

    String req = "$baseURL/data?user_id=$user_id&sensor_id=$sensor_id";
    if (start_time != 0) {
      req = req + "&start_time=$start_time";
    }
    if (end_time != 0) {
      req = req + "&end_time=$end_time";
    }

    Uri url = Uri.parse(req);
    var response = await http.get(url);

    print(
        'get $url Response: ${response.body} ${response.statusCode} ${response.headers}}');

    if (response.statusCode != 200) {
      Map<String, dynamic> responseObject = json.decode(response.body);
      result['detail'] = responseObject['detail'];
    } else {
      result['success'] = true;
      result["data"] = json.decode(response.body);
    }
    return result;
  }
}
