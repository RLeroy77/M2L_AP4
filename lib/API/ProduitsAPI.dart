import 'dart:convert';
import 'package:http/http.dart' as http;

class ProduitsAPI {
  static Future<List<dynamic>> getAllProduits() async {
    try {
      var res = await http.get(Uri.parse(
          "http://10.74.1.151:8000/apiAP4/adminProduitsAP4/getAllProduits"));
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
      final response = await http.post(
        Uri.parse("http://10.74.1.151:8000/apiAP4/adminProduitsAP4/addProduit"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'nom': nom,
          'prix': prix,
          'quantite': quantite,
          'description': description,
        }),
      );
      if (response.statusCode == 200) {
        print("Produit ajouté avec succès");
      } else {
        throw Exception("Erreur serveur: ${response.statusCode}");
      }
    } catch (err) {
      throw Exception("Erreur lors de l'ajout du produit: $err");
    }
  }

  static Future<void> supprimerProduit(String id) async {
    try {
      final response = await http.delete(
        Uri.parse(
            "http://10.74.1.151:8000/apiAP4/adminProduitsAP4/deleteProduit/$id"),
      );
      if (response.statusCode == 200) {
        print("Produit supprimé avec succès");
      } else if (response.statusCode == 404) {
        throw Exception("Produit non trouvé");
      } else {
        throw Exception("Erreur serveur: ${response.statusCode}");
      }
    } catch (err) {
      throw Exception("Erreur lors de la suppression du produit: $err");
    }
  }

  static Future<void> modifierProduit(String id, String nom, double prix,
      int quantite, String description) async {
    try {
      var res = await http.put(
          Uri.parse(
              'http://10.74.1.151:8000/apiAP4/adminProduitsAP4/editProduit/$id'),
          body: {
            'nom': nom,
            'prix': prix.toString(),
            'quantite': quantite.toString(),
            'description': description,
          });
      if (res.statusCode != 200) {
        throw Exception(
            "Erreur lors de la modification du produit: ${res.statusCode}");
      }
    } catch (err) {
      throw Exception("Erreur lors de la modification du produit: $err");
    }
  }
}
