class ApiConstants {
  static const String supabaseUrl = "https://si-pintar.up.railway.app/api/v1";
  static const String supabaseProjectId = "pzqxqzqxqzqxqzqxqzqx";
  static const String supabaseAnonKey = "";
  static const String restApiBaseUrl =
      "https://si-pintar.up.railway.app/api/v1";

  static const anonKey = "1=";

  static Map<String, String> defaultHeaders = {
    "Content-Type": "application/json",
    "Authorization": "Bearer $anonKey",
    "apikey": supabaseAnonKey,
  };
}
