import 'package:flutter/material.dart';
import 'package:ap4/API/ProduitsAPI.dart';
import 'package:ap4/Connexion.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class Produits extends StatefulWidget {
  const Produits({Key? key}) : super(key: key);

  static const String baseUrl = "http://10.74.1.151:8000";

  @override
  State<Produits> createState() => _ProduitsState();
}

class _ProduitsState extends State<Produits> {
  late Future<List<dynamic>> _futureProduitsListe;

  @override
  void initState() {
    super.initState();
    _futureProduitsListe = ProduitsAPI.getAllProduits();
  }

  void _ajouterProduit(BuildContext context) async {
    // Créer des contrôleurs de texte pour chaque champ du formulaire
    TextEditingController nomController = TextEditingController();
    TextEditingController prixController = TextEditingController();
    TextEditingController quantiteController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Ajouter un produit"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nomController,
                  decoration:
                      const InputDecoration(labelText: 'Nom du produit'),
                ),
                TextField(
                  controller: prixController,
                  decoration: const InputDecoration(labelText: 'Prix'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: quantiteController,
                  decoration: const InputDecoration(labelText: 'Quantité'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Annuler"),
            ),
            TextButton(
              onPressed: () async {
                try {
                  String nom = nomController.text;
                  double prix = double.parse(prixController.text);
                  int quantite = int.parse(quantiteController.text);
                  String description = descriptionController.text;

                  // Appeler l'API pour ajouter le produit
                  await ProduitsAPI.addProduit(
                      nom, prix, quantite, description);

                  // Mise à jour de la liste des produits
                  _futureProduitsListe = ProduitsAPI.getAllProduits();

                  // Rafraîchir l'interface utilisateur après avoir mis à jour les données
                  setState(() {});

                  // Fermer la boîte de dialogue
                  Navigator.of(context).pop();
                } catch (error) {
                  throw Exception("Erreur lors de l'ajout du produit: $error");
                  // Afficher un message d'erreur si nécessaire
                }
              },
              child: const Text("Ajouter"),
            ),
          ],
        );
      },
    );
  }

  void _supprimerProduit(String id) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Supprimer le produit"),
          content:
              const Text("Êtes-vous sûr de vouloir supprimer ce produit ?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Annuler"),
            ),
            TextButton(
              onPressed: () async {
                try {
                  // Supprimer le produit
                  await ProduitsAPI.supprimerProduit(id);

                  // Mise à jour de la liste des produits
                  _futureProduitsListe = ProduitsAPI.getAllProduits();

                  // Rafraîchir l'interface utilisateur après avoir mis à jour les données
                  setState(() {});

                  // Fermer la boîte de dialogue
                  Navigator.of(context).pop();
                } catch (error) {
                  Navigator.of(context).pop();
                }
              },
              child: const Text("Supprimer"),
            ),
          ],
        );
      },
    );
  }

  void _modifierProduit(
      BuildContext context, Map<String, dynamic> produit) async {
    // Créer des contrôleurs de texte pour chaque champ du formulaire
    TextEditingController nomController = TextEditingController();
    TextEditingController prixController = TextEditingController();
    TextEditingController quantiteController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    // Afficher une boîte de dialogue de modification en pré-remplissant les champs
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Modifier le produit"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nomController,
                  decoration:
                      const InputDecoration(labelText: 'Nom du produit'),
                ),
                TextField(
                  controller: prixController,
                  decoration: const InputDecoration(labelText: 'Prix'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: quantiteController,
                  decoration: const InputDecoration(labelText: 'Quantité'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Annuler"),
            ),
            TextButton(
              onPressed: () async {
                try {
                  // Récupérer les valeurs modifiées
                  String? nouveauNom =
                      nomController.text.isNotEmpty ? nomController.text : null;
                  double? nouveauPrix = prixController.text.isNotEmpty
                      ? double.parse(prixController.text)
                      : null;
                  int? nouvelleQuantite = quantiteController.text.isNotEmpty
                      ? int.parse(quantiteController.text)
                      : null;
                  String? nouvelleDescription =
                      descriptionController.text.isNotEmpty
                          ? descriptionController.text
                          : null;

                  // Appeler la méthode de modification de produit avec les nouvelles valeurs
                  await ProduitsAPI.modifierProduit(produit['id'], nouveauNom,
                      nouveauPrix, nouvelleQuantite, nouvelleDescription);

                  // Mise à jour de la liste des produits
                  _futureProduitsListe = ProduitsAPI.getAllProduits();

                  // Rafraîchir l'interface utilisateur après avoir mis à jour les données
                  setState(() {});

                  // Fermer la boîte de dialogue
                  Navigator.of(context).pop();
                } catch (error) {
                  throw Exception(
                      "Erreur lors de la modification du produit: $error");
                }
              },
              child: const Text("Modifier"),
            ),
          ],
        );
      },
    );
  }

  void _deconnexion() async {
    // Supprimer le token des préférences partagées
    SharedPreferences token = await SharedPreferences.getInstance();
    await token.remove('token');

    // Naviguer vers l'écran de connexion
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Connexion()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des produits'),
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: const Color(0xFFF6C614),
        leading: IconButton(
          icon: const Icon(Icons.exit_to_app),
          onPressed: _deconnexion,
        ),
      ),
      body: _buildProduitsList(),
      backgroundColor: const Color(0xFFDBDED0),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _ajouterProduit(context);
        },
        backgroundColor: const Color(0xFFC92B39),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildProduitsList() {
    return FutureBuilder<List<dynamic>>(
      future: _futureProduitsListe,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Erreur lors du chargement des produits"),
            );
          } else {
            List<dynamic> produitsList = snapshot.data ?? [];
            if (produitsList.isEmpty) {
              return const Center(
                child: Text("Pas de produits"),
              );
            } else {
              return ListView.builder(
                itemCount: produitsList.length,
                itemBuilder: (BuildContext context, int index) {
                  final produit = produitsList[index];
                  return Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Image.network(
                          '${Produits.baseUrl}/images/${produit['id']}.png',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            // En cas d'erreur de chargement, afficher l'image par défaut
                            return Image.network(
                              '${Produits.baseUrl}/images/default_image.png',
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),
                      ListTile(
                        title: Text(produit['nom']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Prix: ${produit['prix']}'),
                            Text('Quantité: ${produit['quantite']}'),
                            Text('Description: ${produit['description']}'),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              _modifierProduit(context, produit);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              _supprimerProduit(produit['id']);
                            },
                          ),
                        ],
                      ),
                    ],
                  );
                },
              );
            }
          }
        }
      },
    );
  }
}
