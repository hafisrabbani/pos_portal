import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HealthApiService {
  static const String _webHookKey = 'webhook';
  Uri? url;
  SharedPreferences? _prefs;
  final Completer<void> _initCompleter = Completer<void>();

  HealthApiService() {
    _init();
  }

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
    final String? urlString = _prefs?.getString(_webHookKey);
    if (urlString != null) {
      url = Uri.parse(urlString);
    }
    _initCompleter.complete();
  }

  Future<bool> checkConnection({String? injectedUrl}) async {
    try {
      await _initCompleter.future;  // Ensure _init completes
      Uri? connectionUrl;

      if (injectedUrl != null) {
        connectionUrl = Uri.parse(injectedUrl);
      } else if (url != null) {
        connectionUrl = url;
      } else {
        throw Exception('Webhook URL is not set');
      }

      final response = await http.get(
        Uri.parse('${connectionUrl}/health'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      print('url: ${connectionUrl}/health');
      print("response checkConnection: ${response.body}");

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
