class ApiConstants {
  // static const String supabaseUrl = "https://si-pintar.up.railway.app/api/v1";
  // static const String supabaseProjectId = "pzqxqzqxqzqxqzqxqzqx";
  static const String restApiBaseUrl =
      "https://jldoagdubuqilrosdnhd.supabase.co/rest/v1";
  static const String rpcApiBaseUrl =
      "https://jldoagdubuqilrosdnhd.supabase.co/rest/v1/rpc";

  static const anonKey =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpsZG9hZ2R1YnVxaWxyb3NkbmhkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzA4NzczMzEsImV4cCI6MjA0NjQ1MzMzMX0.CpZ42ET0w0vyp-rvjxwJByxA_3EiI-G2s4y5AIfqywU";

  static Map<String, String> defaultHeaders = {
    "Content-Type": "application/json",
    "Authorization": "Bearer $anonKey",
    "apikey": anonKey,
  };
}
