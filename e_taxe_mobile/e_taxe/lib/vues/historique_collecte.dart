import 'package:e_taxe/design/design.dart';
import 'package:e_taxe/utils/responsive_layout.dart';
import 'package:e_taxe/widgets/responsive_body.dart';
import 'package:e_taxe/vues/app_scaffold.dart';
import 'package:e_taxe/controllers/collecte_controller.dart';
import 'package:e_taxe/controllers/auth_controller.dart';
import 'package:e_taxe/components/collecte_card.dart';
import 'package:e_taxe/models/collecte.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HistoriqueCollecte extends StatefulWidget {
  const HistoriqueCollecte({super.key});

  @override
  State<HistoriqueCollecte> createState() => _HistoriqueCollecteState();
}

class _HistoriqueCollecteState extends State<HistoriqueCollecte> {
  final CollecteController _collecteController = Get.put(CollecteController());
  final AuthController _authController = Get.find<AuthController>();
  final TextEditingController _searchController = TextEditingController();
  
  String? _selectedStatut;
  String? _selectedDateFilter;
  List<Collecte> _filteredCollectes = [];

  @override
  void initState() {
    super.initState();
    // Différer le chargement pour éviter les setState pendant le build initial
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCollectes();
    });
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    _applyFilters();
  }

  Future<void> _loadCollectes() async {
    final collecteurId = _authController.collecteurId;
    if (collecteurId != null) {
      await _collecteController.loadCollectes(
        collecteurId: collecteurId,
        refresh: true,
      );
      _applyFilters();
    }
  }

  void _applyFilters() {
    final query = _searchController.text.toLowerCase();
    List<Collecte> filtered = List<Collecte>.from(_collecteController.collectes);

    // Filtre par recherche
    if (query.isNotEmpty) {
      filtered = filtered.where((collecte) {
        final contribuableName = collecte.contribuable?.fullName.toLowerCase() ?? '';
        final reference = collecte.reference.toLowerCase();
        final telephone = collecte.contribuable?.telephone?.toLowerCase() ?? '';
        return contribuableName.contains(query) ||
            reference.contains(query) ||
            telephone.contains(query);
      }).toList();
    }

    // Filtre par statut
    if (_selectedStatut != null && _selectedStatut!.isNotEmpty) {
      filtered = filtered.where((c) => c.statut == _selectedStatut).toList();
    }

    // Filtre par date
    if (_selectedDateFilter != null && _selectedDateFilter!.isNotEmpty) {
      final now = DateTime.now();
      filtered = filtered.where((c) {
        switch (_selectedDateFilter) {
          case 'today':
            return c.dateCollecte.year == now.year &&
                c.dateCollecte.month == now.month &&
                c.dateCollecte.day == now.day;
          case 'week':
            final weekAgo = now.subtract(const Duration(days: 7));
            return c.dateCollecte.isAfter(weekAgo);
          case 'month':
            return c.dateCollecte.year == now.year &&
                c.dateCollecte.month == now.month;
          case 'year':
            return c.dateCollecte.year == now.year;
          default:
            return true;
        }
      }).toList();
    }

    setState(() {
      _filteredCollectes = filtered;
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final maxWidth = ResponsiveLayout.maxContentWidth(context);
    final isTablet = ResponsiveLayout.isTablet(context);

    return AppScaffold(
      currentIndex: 2,
      child: Scaffold(
        backgroundColor: Design.primaryColor,
        body: ResponsiveBody(
          includeScroll: false,
          child: Column(
            children: <Widget>[
              Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        onPressed: () => Get.offNamed('/AccueilAgent'),
                      ),
                      Expanded(
                        child: Text(
                          'Historique de collecte',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => Get.toNamed('/CarteCollectes'),
                            icon: const Icon(Icons.map_outlined),
                          ),
                          IconButton(
                            onPressed: () async {
                              await Get.toNamed('/AddCollecte');
                              // Recharger la liste après retour de la page d'ajout
                              _loadCollectes();
                            },
                            icon: const Icon(Icons.add_circle_outline),
                          ),
                        ],
                      ),
                    ],
                  ),

                const SizedBox(height: 16),
                TextField(
                  controller: _searchController,
                  cursorColor: Design.secondColor,
                  style: const TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Rechercher une collecte (nom, téléphone, référence)',
                    hintStyle: TextStyle(color: Design.mediumGrey),
                    filled: true,
                    fillColor: Design.inputColor,
                    prefixIcon: Icon(Icons.search, color: Design.mediumGrey),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: Colors.grey),
                            onPressed: () {
                              _searchController.clear();
                              _applyFilters();
                            },
                          )
                        : null,
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
                LayoutBuilder(
                  builder: (context, constraints) {
                    final double fieldWidth =
                        isTablet ? (constraints.maxWidth - 12) / 2 : constraints.maxWidth;
                    return Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        SizedBox(
                          width: fieldWidth,
                          child: DropdownButtonFormField<String>(
                            value: _selectedStatut,
                            isExpanded: true,
                            decoration: InputDecoration(
                              hintText: 'Statut',
                              hintStyle: TextStyle(color: Design.mediumGrey, fontSize: 12),
                              filled: true,
                              fillColor: Design.inputColor,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            items: const [
                              DropdownMenuItem(value: null, child: Text('Tous')),
                              DropdownMenuItem(value: 'pending', child: Text('En attente')),
                              DropdownMenuItem(value: 'completed', child: Text('Complété')),
                              DropdownMenuItem(value: 'cancelled', child: Text('Annulé')),
                            ],
                            onChanged: (value) {
                              setState(() => _selectedStatut = value);
                              _applyFilters();
                            },
                          ),
                        ),
                        SizedBox(
                          width: fieldWidth,
                          child: DropdownButtonFormField<String>(
                            value: _selectedDateFilter,
                            isExpanded: true,
                            decoration: InputDecoration(
                              hintText: 'Période',
                              hintStyle: TextStyle(color: Design.mediumGrey, fontSize: 12),
                              filled: true,
                              fillColor: Design.inputColor,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            items: const [
                              DropdownMenuItem(value: null, child: Text('Toutes')),
                              DropdownMenuItem(value: 'today', child: Text('Aujourd\'hui')),
                              DropdownMenuItem(value: 'week', child: Text('Cette semaine')),
                              DropdownMenuItem(value: 'month', child: Text('Ce mois')),
                              DropdownMenuItem(value: 'year', child: Text('Cette année')),
                            ],
                            onChanged: (value) {
                              setState(() => _selectedDateFilter = value);
                              _applyFilters();
                            },
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            _selectedStatut != null || _selectedDateFilter != null
                                ? Icons.filter_alt
                                : Icons.filter_alt_outlined,
                            color: _selectedStatut != null || _selectedDateFilter != null
                                ? Design.secondColor
                                : Design.mediumGrey,
                          ),
                          tooltip: 'Réinitialiser les filtres',
                          onPressed: () {
                            setState(() {
                              _selectedStatut = null;
                              _selectedDateFilter = null;
                            });
                            _applyFilters();
                          },
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Obx(() {
                    if (_collecteController.isLoading.value &&
                        _collecteController.collectes.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (_collecteController.collectes.isNotEmpty) {
                      return Center(  
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _collecteController.errorMessage.value,
                              style: const TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            TextButton(
                              onPressed: _loadCollectes,
                              child: const Text('Réessayer'),
                            ),
                          ],
                        ),
                      );
                    }

                    final collectesToShow =
                        _filteredCollectes.isEmpty &&
                                _searchController.text.isEmpty &&
                                _selectedStatut == null &&
                                _selectedDateFilter == null
                            ? _collecteController.collectes
                            : _filteredCollectes;

                    if (collectesToShow.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: Design.mediumGrey,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _searchController.text.isNotEmpty ||
                                      _selectedStatut != null ||
                                      _selectedDateFilter != null
                                  ? 'Aucune collecte trouvée'
                                  : 'Aucune collecte',
                              style: TextStyle(
                                  color: Design.mediumGrey, fontSize: 16),
                            ),
                            if (_searchController.text.isNotEmpty ||
                                _selectedStatut != null ||
                                _selectedDateFilter != null) ...[
                              const SizedBox(height: 8),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _searchController.clear();
                                    _selectedStatut = null;
                                    _selectedDateFilter = null;
                                  });
                                  _applyFilters();
                                },
                                child: const Text('Réinitialiser les filtres'),
                              ),
                            ],
                          ],
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: _loadCollectes,
                      child: Center(
                        child: SizedBox(
                          width: maxWidth,
                          child: ListView.builder(
                            padding:
                                const EdgeInsets.symmetric(vertical: 10.0),
                            itemCount: collectesToShow.length,
                            itemBuilder: (context, index) {
                              final collecte = collectesToShow[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: CollecteCard(
                                  collecte: collecte,
                                  onTap: () {
                                    _collecteController
                                        .selectedCollecte.value = collecte;
                                    Get.toNamed('/DetailsCollecte',
                                        arguments: collecte.id);
                                  },
                                ),
                              );
                            },
                          ),
                        ),
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
