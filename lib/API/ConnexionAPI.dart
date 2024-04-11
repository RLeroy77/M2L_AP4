import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ConnexionAPI {
  static const String baseUrl = "http://10.74.1.151:8000";

  static Future<void> connexion(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/api/inscriptionConnexion/connexion"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'user_name': username,
          'mot_de_passe': password,
        }),
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        String token = responseData['token'];
        // Stockage du token dans un cookie
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
      } else {
        throw Exception("Erreur d'authentification: ${response.statusCode}");
      }
    } catch (error) {
      throw Exception("Erreur lors de la connexion: $error");
    }
  }

  static Future<String> getUserRole(String userId) async {
    try {
      final response =
          await http.get(Uri.parse("$baseUrl/api/users/getUserRole/$userId"));
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData.isNotEmpty && responseData[0].containsKey('admin')) {
          String role = responseData[0]['admin'].toString();
          return role;
        } else {
          throw Exception(
              "Réponse JSON invalide : aucune clé 'admin' trouvée.");
        }
      } else {
        throw Exception(
            "Erreur de récupération du rôle: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Erreur lors de la récupération du rôle: $e");
    }
  }
}
