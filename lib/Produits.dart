import 'package:flutter/material.dart';
import 'package:ap4/API/ProduitsAPI.dart';
import 'package:ap4/Connexion.dart';

class Produits extends StatefulWidget {
  const Produits({Key? key}) : super(key: key);

  @override
  State<Produits> createState() => _ProduitsState();
}

class _ProduitsState extends State<Produits> {
  List<dynamic> produitsList = [];

  @override
  void initState() {
    super.initState();
    _fetchProduits();
  }

  Future<void> _fetchProduits() async {
    try {
      List<dynamic> produits = await ProduitsAPI.getAllProduits();
      setState(() {
        produitsList = produits;
      });
    } catch (err) {
      print('Erreur lors de la récupération des produits: $err');
      // Gérer l'erreur selon votre logique d'application
    }
  }

  void _ajouterProduit(BuildContext context) {
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

                  // Rafraîchir la liste des produits après l'ajout
                  _fetchProduits();

                  // Fermer la boîte de dialogue
                  Navigator.of(context).pop();
                } catch (error) {
                  print("Erreur lors de l'ajout du produit: $error");
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

  void _supprimerProduit(String id) {
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
                  await ProduitsAPI.supprimerProduit(id);
                  _fetchProduits(); // Rafraîchir la liste après la suppression
                  Navigator.of(context).pop(); // Fermer la boîte de dialogue
                } catch (error) {
                  print("Erreur lors de la suppression du produit: $error");
                  // Afficher un message d'erreur si nécessaire
                  Navigator.of(context)
                      .pop(); // Fermer la boîte de dialogue en cas d'erreur
                }
              },
              child: const Text("Supprimer"),
            ),
          ],
        );
      },
    );
  }

  void _modifierProduit(BuildContext context, Map<String, dynamic> produit) {
    // Créer des contrôleurs de texte pour chaque champ du formulaire
    TextEditingController nomController = TextEditingController();
    TextEditingController prixController = TextEditingController();
    TextEditingController quantiteController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    // Afficher une boîte de dialogue de modification sans pré-remplir les champs
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
                // Réinitialiser les valeurs des contrôleurs de texte à une chaîne vide
                nomController.clear();
                prixController.clear();
                quantiteController.clear();
                descriptionController.clear();
                Navigator.of(context).pop();
              },
              child: const Text("Annuler"),
            ),
            TextButton(
              onPressed: () {
                // Implémenter la logique pour modifier le produit avec les nouvelles valeurs
                String nouveauNom = nomController.text;
                double nouveauPrix = double.parse(prixController.text);
                int nouvelleQuantite = int.parse(quantiteController.text);
                String nouvelleDescription = descriptionController.text;

                // Appeler la méthode de modification de produit avec les nouvelles valeurs
                ProduitsAPI.modifierProduit(produit['id'], nouveauNom,
                    nouveauPrix, nouvelleQuantite, nouvelleDescription);

                // Rafraîchir la liste des produits après la modification
                _fetchProduits();

                // Réinitialiser les valeurs des contrôleurs de texte à une chaîne vide
                nomController.clear();
                prixController.clear();
                quantiteController.clear();
                descriptionController.clear();

                // Fermer la boîte de dialogue
                Navigator.of(context).pop();
              },
              child: const Text("Modifier"),
            ),
          ],
        );
      },
    );
  }

  void _deconnexion() {
    // Implémentez ici la logique pour supprimer le token, par exemple :
    // Supprimer le token de l'utilisateur
    // Naviguer vers la page de connexion
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const Connexion()));
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
          // Déplacez le bouton de déconnexion à gauche
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
        child: const Icon(Icons.add), // Couleur de votre choix
      ),
    );
  }

  Widget _buildProduitsList() {
    if (produitsList.isEmpty) {
      return const Center(
        child: Text("Pas de produits"),
      );
    } else {
      return ListView.builder(
        itemCount: produitsList.length,
        itemBuilder: (BuildContext context, int index) {
          final produit = produitsList[index];
          return ListTile(
            title: Text(produit['nom']), // Nom du produit
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Prix: ${produit['prix']}'), // Prix du produit
                Text('Quantité: ${produit['quantite']}'), // Quantité du produit
                Text(
                    'Description: ${produit['description']}'), // Description du produit
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    _modifierProduit(context,
                        produit); // Appeler la fonction de modification du produit
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
            // Vous pouvez afficher d'autres détails du produit ici
          );
        },
      );
    }
  }
}
