import 'dart:convert';

import 'package:e_taxe/design/design.dart';
import 'package:e_taxe/controllers/client_controller.dart';
import 'package:e_taxe/apis/api_service.dart';
import 'package:e_taxe/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class DetailsClient extends StatefulWidget {
  const DetailsClient({super.key});

  @override
  State<DetailsClient> createState() => _DetailsClientState();
}

class _DetailsClientState extends State<DetailsClient> {
  final ClientController _clientController = Get.put(ClientController());
  int? _clientId;
  Map<String, dynamic>? _statutFiscal;
  bool _loadingStatut = false;
  String? _statutError;

  @override
  void initState() {
    super.initState();
    // Récupérer l'ID du client depuis les arguments ou utiliser le client sélectionné
    _clientId = Get.arguments as int?;

    // Si un client est déjà sélectionné dans le controller, on l'utilise
    // Sinon, on charge le client par son ID
    if (_clientController.selectedClient.value == null && _clientId != null) {
      _clientController.loadClient(_clientId!);
    }

    // Charger le statut fiscal si possible
    _loadStatutFiscal();
  }

  Future<void> _loadStatutFiscal() async {
    if (_clientId == null) return;
    setState(() {
      _loadingStatut = true;
      _statutError = null;
    });
    try {
      final base = await ApiService.baseUrl;
      final token = await StorageService.getToken();
      final headers = <String, String>{
        'Content-Type': 'application/json',
      };
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
      final uri = Uri.parse('$base/api/contribuables/${_clientId}/statut-fiscal');
      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        setState(() {
          _statutFiscal = data;
        });
      } else {
        setState(() {
          _statutError = 'Impossible de récupérer le statut fiscal';
        });
      }
    } catch (e) {
      setState(() {
        _statutError = e.toString();
      });
    } finally {
      setState(() {
        _loadingStatut = false;
      });
    }
  }

  Widget _buildStatutFiscal() {
    if (_loadingStatut) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 8),
            Text(
              'Chargement du statut fiscal...',
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
      );
    }

    if (_statutError != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Text(
          'Statut fiscal: erreur de chargement',
          style: const TextStyle(fontSize: 12, color: Colors.red),
        ),
      );
    }

    if (_statutFiscal == null) {
      return const SizedBox.shrink();
    }

    final label = _statutFiscal?['label'] as String? ?? 'Inconnu';
    final code = _statutFiscal?['code'] as String? ?? 'inconnu';

    Color bgColor;
    if (code == 'a_jour') {
      bgColor = Colors.green.shade100;
    } else if (code == 'partiellement_paye') {
      bgColor = Colors.orange.shade100;
    } else if (code == 'en_retard') {
      bgColor = Colors.red.shade100;
    } else {
      bgColor = Colors.grey.shade200;
    }

    Color textColor;
    if (code == 'a_jour') {
      textColor = Colors.green.shade800;
    } else if (code == 'partiellement_paye') {
      textColor = Colors.orange.shade800;
    } else if (code == 'en_retard') {
      textColor = Colors.red.shade800;
    } else {
      textColor = Colors.grey.shade800;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Statut fiscal',
            style: TextStyle(fontSize: 13, color: Colors.black87),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Design.primaryColor,
      appBar: AppBar(
        backgroundColor: Design.primaryColor,
        centerTitle: true,
        title: const Text(
          'Détails du client',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.offNamed('/Clients');
          },
        ),
      ),
      body: Obx(() {
        if (_clientController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final client = _clientController.selectedClient.value;
        
        if (client == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.person_off, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                const Text(
                  'Client non trouvé',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Get.offNamed('/Clients'),
                  child: const Text('Retour à la liste'),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 10,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        infoRow("Nom", client.nom),
                        infoRow("Prénom", client.prenom),
                        if (client.telephone != null)
                          infoRow("Numéro de téléphone", client.telephone!),
                        if (client.adresse != null)
                          infoRow("Adresse", client.adresse!),
                        infoRow("Statut", client.actif == true ? "Actif" : "Inactif"),
                        const SizedBox(height: 8),
                        _buildStatutFiscal(),
                        if (client.createdAt != null)
                          infoRow(
                            "Date de création",
                            "${client.createdAt!.day}/${client.createdAt!.month}/${client.createdAt!.year}",
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  /// Widget réutilisable pour les lignes d'information
  Widget infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: Colors.black87),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 13,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
