class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8000'; // Use your actual backend URL
  static String? _token;

  static void setToken(String token) {
    _token = token;
  }

  static String? getToken() {
    return _token;
  }
}

