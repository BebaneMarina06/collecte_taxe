import 'package:e_taxe/design/design.dart';
import 'package:e_taxe/vues/app_scaffold.dart';
import 'package:e_taxe/controllers/auth_controller.dart';
import 'package:e_taxe/controllers/client_controller.dart';
import 'package:e_taxe/components/client_card.dart';
import 'package:e_taxe/widgets/responsive_body.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Clients extends StatefulWidget {
  const Clients({super.key});

  @override
  State<Clients> createState() => _ClientsState();
}

class _ClientsState extends State<Clients> {
  final AuthController _authController = Get.find<AuthController>();
  final ClientController _clientController = Get.put(ClientController());
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Différer le chargement après le build pour éviter l'erreur setState() during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadClients();
    });
    _searchController.addListener(() {
      _clientController.searchQuery.value = _searchController.text;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadClients() async {
    final collecteurId = _authController.collecteurId;
    if (collecteurId != null) {
      await _clientController.loadClients(
        collecteurId: collecteurId,
        actif: true,
        refresh: true,
      );
    } else {
      // Si collecteurId est null, essayer de charger quand même (sans filtre)
      await _clientController.loadClients(
        collecteurId: null,
        actif: true,
        refresh: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentIndex: 1,
      child: Scaffold(
        backgroundColor: Design.primaryColor,
        body: ResponsiveBody(
          includeScroll: false,
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () => Get.offNamed('/AccueilAgent'),
                  ),
                  Expanded(
                    child: Text(
                      'Liste des clients',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: const CircleBorder(),
                        backgroundColor: Design.secondColor,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () async {
                        await Get.toNamed('/AddClient');
                        // Recharger la liste après retour de la page d'ajout
                        _loadClients();
                      },
                      child: const Icon(Icons.add, size: 20),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _searchController,
                cursorColor: Design.secondColor,
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Rechercher un client',
                  hintStyle: TextStyle(color: Design.mediumGrey),
                  filled: true,
                  fillColor: Design.inputColor,
                  prefixIcon: Icon(Icons.search, color: Design.mediumGrey),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 14.0,
                    horizontal: 16.0,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Design.secondColor, width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Obx(() {
                if (_clientController.isLoading.value && _clientController.clients.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (_clientController.errorMessage.value.isNotEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _clientController.errorMessage.value,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        TextButton(
                          onPressed: _loadClients,
                          child: const Text('Réessayer'),
                        ),
                      ],
                    ),
                  );
                }
                
                final filteredClients = _clientController.getFilteredClients();
                
                if (filteredClients.isEmpty) {
                  return Center(
                    child: Text(
                      _clientController.searchQuery.value.isNotEmpty
                          ? 'Aucun client trouvé'
                          : 'Aucun client',
                      style: TextStyle(color: Design.mediumGrey),
                    ),
                  );
                }
                
                  return RefreshIndicator(
                    onRefresh: _loadClients,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: filteredClients.length,
                      itemBuilder: (context, index) {
                        final client = filteredClients[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: ClientCard(
                            client: client,
                            onTap: () {
                              _clientController.selectedClient.value = client;
                              Get.toNamed('/DetailsClient');
                            },
                          ),
                        );
                      },
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
