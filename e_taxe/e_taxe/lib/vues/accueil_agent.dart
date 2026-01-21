import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart'
    show CarouselSlider, CarouselOptions;
import 'package:e_taxe/design/design.dart';
import 'package:e_taxe/widgets/responsive_body.dart';
import 'package:e_taxe/controllers/auth_controller.dart';
import 'package:e_taxe/controllers/collecte_controller.dart';
import 'package:e_taxe/controllers/statistiques_controller.dart';
import 'package:e_taxe/services/sync_service.dart';
import 'package:e_taxe/components/collecte_card.dart';
import 'package:e_taxe/components/card_accueil.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class AccueilAgent extends StatefulWidget {
  const AccueilAgent({super.key});

  @override
  State<AccueilAgent> createState() => _AccueilAgentState();
}

class _AccueilAgentState extends State<AccueilAgent> {
  final AuthController _authController = Get.find<AuthController>();
  final CollecteController _collecteController = Get.put(CollecteController());
  final StatistiquesController _statistiquesController = Get.put(StatistiquesController());
  final SyncService _syncService = SyncService();
  
  // Liste des image du slide
  List imageList = [
    {"id": 1, "image_path": 'assets/first_img_slide.png'},
    {"id": 2, "image_path": 'assets/second_img_slide.png'},
  ];
  final CarouselSliderController carouselController =
      CarouselSliderController();
  int currentIndexS = 0;
  int _pendingSyncCount = 0;
  Timer? _timeUpdateTimer;
  String? _timeRemaining;

  @override
  void initState() {
    super.initState();
    // Différer le chargement après le build pour éviter l'erreur setState() during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
      _checkPendingSync();
    });
    _startTimeUpdate();
  }

  @override
  void dispose() {
    _timeUpdateTimer?.cancel();
    super.dispose();
  }

  void _startTimeUpdate() {
    _updateTimeRemaining();
    _timeUpdateTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _updateTimeRemaining();
    });
  }

  void _updateTimeRemaining() {
    final timeRemaining = _authController.closingTimeService.getTimeRemaining();
    setState(() {
      _timeRemaining = timeRemaining;
    });
  }

  Future<void> _loadData() async {
    final collecteurId = _authController.collecteurId;
    if (collecteurId != null) {
      await Future.wait([
        _collecteController.loadCollectes(
          collecteurId: collecteurId,
          refresh: true,
        ),
        _statistiquesController.loadStatistiques(collecteurId),
      ]);
    }
  }

  Widget _ActionCard({
    required Color background,
    required Color accent,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: background,
          ),
          child: Stack(
            children: [
              Positioned(
                top: -30,
                right: -30,
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    color: accent,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: background, size: 20),
                    ),
                    const Spacer(),
                    Text(
                      label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _checkPendingSync() async {
    try {
      final count = await _syncService.getPendingCount();
      setState(() {
        _pendingSyncCount = count;
      });
    } catch (e) {
      // Ignorer les erreurs sur le web (mode hors ligne non supporté)
      setState(() {
        _pendingSyncCount = 0;
      });
    }
  }

  Future<void> _handleSync() async {
    await _syncService.syncAll();
    await _checkPendingSync();
    await _loadData(); // Recharger les données après synchronisation
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Design.primaryColor,
      body: ResponsiveBody(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40.0, left: 20, right: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Flexible(
                            child: Obx(() => Text(
                                  'Bonjour, ${_authController.collecteurFullName.isNotEmpty ? _authController.collecteurFullName.split(' ').first : 'Collecteur'}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                )),
                          ),
                          const SizedBox(width: 6),
                          const Icon(Icons.waving_hand, color: Colors.yellow, size: 18),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Wrap(
                      spacing: 10,
                      children: [
                        GestureDetector(
                          onTap: () => Get.offNamed('/Notifcations'),
                          child: Stack(
                            children: [
                              Container(
                                height: 34,
                                width: 34,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(360),
                                ),
                                child: const Icon(Icons.notifications, color: Colors.black, size: 18),
                              ),
                              Positioned(
                                right: 6,
                                top: 10,
                                child: Container(
                                  height: 8,
                                  width: 8,
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (_pendingSyncCount > 0)
                          GestureDetector(
                            onTap: _handleSync,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.sync, color: Colors.white, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    '$_pendingSyncCount',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        GestureDetector(
                          onTap: () => Get.toNamed('/Profil'),
                          child: Container(
                            height: 34,
                            width: 34,
                            decoration: BoxDecoration(
                              color: Design.secondColor,
                              borderRadius: BorderRadius.circular(360),
                            ),
                            child: const CircleAvatar(
                              backgroundColor: Design.secondColor,
                              backgroundImage: AssetImage('assets/avatar_profil.png'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                  bottom: 8.0,
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final bool isNarrow = constraints.maxWidth < 360;
                    Widget? timerChip;
                    
                    if (_timeRemaining != null) {
                      timerChip = Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: _timeRemaining!.contains('min') &&
                                  int.tryParse(_timeRemaining!.replaceAll('min', '').trim()) != null &&
                                  int.parse(_timeRemaining!.replaceAll('min', '').trim()) <= 15
                              ? Colors.orange
                              : Design.secondColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.access_time, color: Colors.white, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              'Fermeture: $_timeRemaining',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      );
                    }

                    if (isNarrow) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Une nouvelle journée commence !',
                            style: TextStyle(fontSize: 14, color: Design.mediumGrey),
                          ),
                          if (timerChip != null) ...[
                            const SizedBox(height: 8),
                            timerChip,
                          ],
                        ],
                      );
                    }

                    return Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Une nouvelle journée commence !',
                            style: TextStyle(fontSize: 14, color: Design.mediumGrey),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (timerChip != null) timerChip,
                      ],
                    );
                  },
                ),
              ),
              Stack(
                children: [
                  Container(
                    height: 180,
                    width: double.infinity,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: CarouselSlider(
                  items: imageList.map((item) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          item['image_path'],
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                    );
                  }).toList(),
                  carouselController: carouselController,
                      options: CarouselOptions(
                        height: 180,
                        scrollPhysics: const BouncingScrollPhysics(),
                        autoPlay: true,
                        viewportFraction: 1.0,
                        onPageChanged: (index, reason) {
                          setState(() {
                            currentIndexS = index;
                          });
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: imageList.asMap().entries.map((entry) {
                        return GestureDetector(
                          onTap: () => carouselController.animateToPage(entry.key),
                          child: Container(
                            width: currentIndexS == entry.key ? 16 : 7,
                            height: 7.0,
                            margin: const EdgeInsets.symmetric(horizontal: 3.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: currentIndexS == entry.key
                                  ? Design.secondColor
                                  : Design.softSkyBlue,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
          SizedBox(height: 10),
          // Cartes de statistiques
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Obx(() {
                final stats = _statistiquesController.statistiques.value;
                final numberFormat = NumberFormat.currency(symbol: '', decimalDigits: 0, locale: 'fr');
                
                return Row(
                  children: [
                    MontantCard(
                      icon: Icons.attach_money,
                      title: 'Total collecté',
                      subtitle: 'Total',
                      subtitleMontant: stats != null 
                          ? '${numberFormat.format(stats.totalCollecte)} XAF'
                          : '0 XAF',
                      color: Design.secondColor,
                    ),
                    const SizedBox(width: 10),
                    MontantCard(
                      icon: Icons.account_balance_wallet,
                      title: 'Commission',
                      subtitle: 'Total',
                      subtitleMontant: stats != null
                          ? '${numberFormat.format(stats.commissionTotale)} XAF'
                          : '0 XAF',
                      color: const Color(0xFF7A5FF1),
                    ),
                    const SizedBox(width: 10),
                    MontantCard(
                      icon: Icons.history,
                      title: 'Collectes',
                      subtitle: 'Total',
                      subtitleMontant: stats != null
                          ? '${stats.nombreCollectes}'
                          : '0',
                      color: const Color(0xFFF16E28),
                    ),
                  ],
                );
              }),
            ),
          ),
          SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final bool sideBySide = constraints.maxWidth >= 520;
                    final double itemWidth = sideBySide
                        ? (constraints.maxWidth - 12) / 2
                        : constraints.maxWidth;

                    return Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        SizedBox(
                          width: itemWidth,
                          child: _ActionCard(
                            background: const Color(0xFFF16E28),
                            accent: const Color(0xFFF99763),
                            icon: Icons.attach_money,
                            label: 'Ajouter une collecte',
                            onTap: () => Get.toNamed('/AddCollecte'),
                          ),
                        ),
                        SizedBox(
                          width: itemWidth,
                          child: _ActionCard(
                            background: const Color(0xFF7A5FF1),
                            accent: const Color(0xFF9A83F5),
                            icon: Icons.person_2,
                            label: 'Ajouter un client',
                            onTap: () => Get.toNamed('/AddClient'),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Collectes récentes',
                      style: TextStyle(fontSize: 16, color: Design.mediumGrey),
                    ),
                    TextButton(
                      onPressed: () => Get.toNamed('/HistoriqueCollecte'),
                      child: Text(
                        'Voir plus',
                        style: TextStyle(fontSize: 14, color: Design.secondColor),
                      ),
                    ),
                  ],
                ),
              ),
              Obx(() {
                if (_collecteController.isLoading.value &&
                    _collecteController.collectes.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (_collecteController.errorMessage.value.isNotEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            _collecteController.errorMessage.value,
                            style: const TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          TextButton(
                            onPressed: _loadData,
                            child: const Text('Réessayer'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final recentCollectes =
                    _collecteController.getRecentCollectes(limit: 5);

                if (recentCollectes.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                      child: Text(
                        'Aucune collecte récente',
                        style: TextStyle(color: Design.mediumGrey),
                      ),
                    ),
                  );
                }

                return Column(
                  children: recentCollectes.map((collecte) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: CollecteCard(
                        collecte: collecte,
                        onTap: () {
                          _collecteController.selectedCollecte.value = collecte;
                          Get.toNamed('/DetailsCollecte');
                        },
                      ),
                    );
                  }).toList(),
                );
              }),
            ],
          ),
        ),
      );
  }
}
