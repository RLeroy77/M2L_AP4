import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProduitsAPI {
  static const String baseUrl = "http://10.0.2.2:8000";

  static Future<List<dynamic>> getAllProduits() async {
    try {
      var res =
          await http.get(Uri.parse("$baseUrl/api/produits/getAllProduits"));
      if (res.statusCode == 200) {
        final List<dynamic> produitsList = jsonDecode(res.body);
        return produitsList;
      } else {
        throw Exception("Erreur serveur: ${res.statusCode}");
      }
    } catch (err) {
      throw Exception("Erreur lors de la récupération des produits: $err");
    }
  }

  static Future<void> addProduit(
      String nom, double prix, int quantite, String description) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        throw Exception(
            "Le token n'est pas disponible dans les préférences partagées.");
      }

      final response = await http.post(
        Uri.parse("$baseUrl/api/adminProduits/addProduitFlutter"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'authorization': token,
        },
        body: jsonEncode(<String, dynamic>{
          'nom': nom,
          'prix': prix,
          'quantite': quantite,
          'description': description,
        }),
      );
      if (response.statusCode != 200) {
        throw Exception("Erreur serveur: ${response.statusCode}");
      }
    } catch (err) {
      throw Exception("Erreur lors de l'ajout du produit: $err");
    }
  }

  static Future<void> supprimerProduit(String id) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        throw Exception(
            "Le token n'est pas disponible dans les préférences partagées.");
      }

      final response = await http.delete(
        Uri.parse("$baseUrl/api/adminProduits/deleteProduit/$id"),
        headers: {
          'authorization': token,
        },
      );
      if (response.statusCode != 200 && response.statusCode != 404) {
        throw Exception("Erreur serveur: ${response.statusCode}");
      }
    } catch (err) {
      throw Exception("Erreur lors de la suppression du produit: $err");
    }
  }

  static Future<void> modifierProduit(String id, String? nom, double? prix,
      int? quantite, String? description) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      if (token == null) {
        throw Exception(
            "Le token n'est pas disponible dans les préférences partagées.");
      }
      Map<String, dynamic> requestBody = {}; // Créer un corps de requête vide
      // Ajouter les valeurs modifiées au corps de requête si elles sont fournies
      if (nom != null) requestBody['nom'] = nom;
      if (prix != null) requestBody['prix'] = prix;
      if (quantite != null) requestBody['quantite'] = quantite;
      if (description != null) requestBody['description'] = description;

      final response = await http.put(
        Uri.parse("$baseUrl/api/adminProduits/editProduit/$id"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'authorization': token,
        },
        body: jsonEncode(requestBody), // Utiliser le corps de requête construit
      );

      if (response.statusCode != 200) {
        throw Exception(
            "Erreur lors de la modification du produit: ${response.statusCode}");
      }
    } catch (err) {
      throw Exception("Erreur lors de la modification du produit: $err");
    }
  }
}
