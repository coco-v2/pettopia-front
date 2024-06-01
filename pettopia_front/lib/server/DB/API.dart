import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class APIServer {


  APIServer();
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
 String _serverDbUrl="";
    Future<void> _getServerUrl() async {
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    print("Error loading .env file: $e"); // 오류 메시지 출력
  }
  _serverDbUrl = dotenv.env['DB_SERVER_URI'] ?? 'YOUR_KAKAO_APP_KEY';
  print(_serverDbUrl);
}


  Future<List<Map<String, dynamic>>> getHospitalService(String address) async {
    String? assessToken = await _secureStorage.read(key: 'accessToken');
    print("accessToken");
    print(assessToken);
    print(address);
    await _getServerUrl();
    final serverUrl = _serverDbUrl+ "api/v1/map/hospital/$address";
    print(serverUrl);
    final uri = Uri.parse(serverUrl); // 서버 URL 파싱
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',

      'Authorization': 'Bearer $assessToken', // JWT 토큰,
    };

    final response = await http.get(uri, headers: headers); // GET 요청 보내기

    if (response.statusCode == 200) {
      // UTF-8로 응답을 디코딩하고 JSON 파싱
      print(jsonDecode(utf8.decode(response.bodyBytes)));
      final List<dynamic> jsonData =
          jsonDecode(utf8.decode(response.bodyBytes));
      print("jsonData: ");
      print(jsonData);
      print("총 개수는");
      print(jsonData.length);
      final List<Map<String, dynamic>> data =
          jsonData.cast<Map<String, dynamic>>();
      ;

      return data; // 결과 반환
    } else {
      throw Exception(
          "Failed to fetch chart list. Status code: ${response.body}"); // 예외 발생
    }
  }

   Future<List<Map<String, dynamic>>> getBeautyService(String address) async {
    String? assessToken = await _secureStorage.read(key: 'accessToken');
    String ?refreshToken = await _secureStorage.read(key:'refreshToken');
    print("accessToken");
    print(assessToken);
    print("refreshToken");
    print(refreshToken);
    print(address);
    await _getServerUrl();
    final serverUrl = _serverDbUrl+ "api/v1/map/beauty/$address";
    print(serverUrl);
    final uri = Uri.parse(serverUrl); // 서버 URL 파싱
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',

      'Authorization': 'Bearer $assessToken', // JWT 토큰,
    };

    final response = await http.get(uri, headers: headers); // GET 요청 보내기

    if (response.statusCode == 200) {
      // UTF-8로 응답을 디코딩하고 JSON 파싱
      print(jsonDecode(utf8.decode(response.bodyBytes)));
      final List<dynamic> jsonData =
          jsonDecode(utf8.decode(response.bodyBytes));
      print("jsonData: ");
      print(jsonData);
      print("총 개수는");
      print(jsonData.length);
      final List<Map<String, dynamic>> data =
          jsonData.cast<Map<String, dynamic>>();
      ;

      return data; // 결과 반환
    } else {
      throw Exception(
          "Failed to fetch chart list. Status code: ${response.body}"); // 예외 발생
    }
  }
Future <Map<String, dynamic>> getWeather(String lat, String lon) async {
    String? assessToken = await _secureStorage.read(key: 'accessToken');
    print("accessToken");
    print(assessToken);
    await _getServerUrl();
    final serverUrl = _serverDbUrl+ "api/v1/map/weather?lat=$lat&lon=$lon";
    print(serverUrl);
    final uri = Uri.parse(serverUrl); // 서버 URL 파싱
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',

      'Authorization': 'Bearer $assessToken', // JWT 토큰,
    };

    final response = await http.get(uri, headers: headers); // GET 요청 보내기

    if (response.statusCode == 200) {
      // UTF-8로 응답을 디코딩하고 JSON 파싱
      print(jsonDecode(utf8.decode(response.bodyBytes)));
      final Map<String,dynamic>jsonData =
          jsonDecode(utf8.decode(response.bodyBytes));
      print("jsonData: ");
      print(jsonData);
   ;
  

      return jsonData; // 결과 반환
    } else {
      throw Exception(
          "Failed to fetch chart list. Status code: ${response.body}"); // 예외 발생
    }
}
}