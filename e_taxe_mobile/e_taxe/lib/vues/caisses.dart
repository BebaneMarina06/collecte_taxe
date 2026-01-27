import 'package:e_taxe/design/design.dart';
import 'package:e_taxe/vues/app_scaffold.dart';
import 'package:e_taxe/controllers/collecte_controller.dart';
import 'package:e_taxe/controllers/statistiques_controller.dart';
import 'package:e_taxe/controllers/auth_controller.dart';
import 'package:e_taxe/components/collecte_card.dart';
import 'package:e_taxe/models/collecte.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Caisses extends StatefulWidget {
  const Caisses({super.key});

  @override
  State<Caisses> createState() => _CaissesState();
}

class _CaissesState extends State<Caisses> {
  final CollecteController _collecteController = Get.put(CollecteController());
  final StatistiquesController _statistiquesController = Get.put(StatistiquesController());
  final AuthController _authController = Get.find<AuthController>();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    final collecteurId = _authController.collecteurId;
    if (collecteurId != null) {
      await Future.wait([
        _statistiquesController.loadStatistiques(collecteurId),
        _collecteController.loadCollectes(
          collecteurId: collecteurId,
          refresh: true,
        ),
      ]);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  double _calculateTotalCash() {
    return _collecteController.collectes
        .where((c) => c.typePaiement.toLowerCase() == 'cash' && c.isCompleted)
        .fold(0.0, (sum, c) => sum + c.montant);
  }

  double _calculateTotalDigital() {
    return _collecteController.collectes
        .where((c) => 
            (c.typePaiement.toLowerCase() == 'mobile_money' ||
             c.typePaiement.toLowerCase() == 'bamboo' ||
             c.typePaiement.toLowerCase() == 'carte') && 
            c.isCompleted)
        .fold(0.0, (sum, c) => sum + c.montant);
  }

  List<Collecte> _getFilteredCollectes() {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      return _collecteController.collectes.take(10).toList();
    }
    return _collecteController.collectes.where((collecte) {
      final contribuableName = collecte.contribuable?.fullName.toLowerCase() ?? '';
      final reference = collecte.reference.toLowerCase();
      return contribuableName.contains(query) || reference.contains(query);
    }).take(10).toList();
  }

  @override
  Widget build(BuildContext context) {
    final myWidth = MediaQuery.of(context).size.width;
    final numberFormat = NumberFormat.currency(symbol: '', decimalDigits: 0, locale: 'fr');
    
    return AppScaffold(
      currentIndex: 3,
      child: Scaffold(
        backgroundColor: Design.primaryColor,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Get.offNamed('/AccueilAgent');
            },
          ),
          title: const Text(
            'Caisses',
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
          centerTitle: true,
          backgroundColor: Design.primaryColor,
        ),
        body: RefreshIndicator(
          onRefresh: _loadData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Caisse physique (Cash)
                      Obx(() => Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Container(
                          width: myWidth / 2.3,
                          height: 110,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: const Color(0xFFF16E28),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                top: -30,
                                right: -30,
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFF99763),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Caisse physique (Cash)',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${numberFormat.format(_calculateTotalCash())} XAF',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                      // Caisse numérique
                      Obx(() => Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Container(
                          width: myWidth / 2.3,
                          height: 110,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: const Color(0xFF7A5FF1),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                top: -30,
                                right: -30,
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF9A83F5),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Caisse numérique',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${numberFormat.format(_calculateTotalDigital())} XAF',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                    ],
                  ),
                ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: myWidth/2.3
,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Design.secondColor,
                ),
                child: TextButton(
                  onPressed: () {
                    // Action à définir
                    Get.offNamed('/CaisseNumerique');

                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Cercle avec l'icône
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white24, // léger fond pour contraste
                        ),
                        child: const Icon(
                          Icons.arrow_circle_left,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Caisse numérique',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: myWidth/2.3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Design.secondColor,
                ),
                child: TextButton(
                  onPressed: () {
                    Get.offNamed('/CaissePhysique');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Cercle avec l'icône
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white24, // léger fond pour contraste
                        ),
                        child: const Icon(
                          Icons.wallet,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Caisse physique',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
                const SizedBox(height: 20),
                // Champ de recherche
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {});
                    },
                    cursorColor: Design.secondColor,
                    style: const TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Rechercher une collecte',
                      hintStyle: TextStyle(color: Design.mediumGrey),
                      filled: true,
                      fillColor: Design.inputColor,
                      prefixIcon: Icon(Icons.search, color: Design.mediumGrey),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, color: Colors.grey),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {});
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
                ),
                const SizedBox(height: 10),
                // Liste des dernières collectes
                Obx(() {
                  if (_collecteController.isLoading.value && _collecteController.collectes.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final filteredCollectes = _getFilteredCollectes();

                  if (filteredCollectes.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Center(
                        child: Text(
                          _searchController.text.isNotEmpty
                              ? 'Aucune collecte trouvée'
                              : 'Aucune collecte',
                          style: TextStyle(color: Design.mediumGrey),
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: [
                      ...filteredCollectes.map((collecte) => Padding(
                        padding: const EdgeInsets.only(bottom: 5.0, left: 16.0, right: 16.0),
                        child: CollecteCard(
                          collecte: collecte,
                          onTap: () {
                            _collecteController.selectedCollecte.value = collecte;
                            Get.toNamed('/DetailsCollecte', arguments: collecte.id);
                          },
                        ),
                      )),
                      const SizedBox(height: 20),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
