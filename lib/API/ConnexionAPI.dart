import 'dart:convert';
import 'package:http/http.dart' as http;

class ConnexionAPI {
  static Future<String> connexion(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse("http://10.74.1.151:8000/apiAP4/adminProduitsAP4/connexion"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'user_name': username,
          'mot_de_passe': password,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        String token = responseData['token'];
        return token;
      } else {
        throw Exception("Erreur d'authentification: ${response.statusCode}");
      }
    } catch (err) {
      throw Exception("Erreur lors de la connexion: $err");
    }
  }

  static Future<String> getUserRole(String UserId) async {
    try {
      final reponse = await http.get(
          Uri.parse("http://10.74.1.151:8000/api/users/getUserRole/$UserId"));
      if (reponse.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(reponse.body);
        String role = responseData['role'];
        return role;
      } else {
        throw Exception(
            "Erreur de recuperation du role: ${reponse.statusCode}");
      }
    } catch (e) {
      throw Exception("Erreur lors de la recuperation du role: $e");
    }
  }
}
