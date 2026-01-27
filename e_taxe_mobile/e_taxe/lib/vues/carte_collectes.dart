import 'package:e_taxe/design/design.dart';
import 'package:e_taxe/controllers/collecte_controller.dart';
import 'package:e_taxe/controllers/auth_controller.dart';
import 'package:e_taxe/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart' as fm;
import 'package:latlong2/latlong.dart' as latlng;
import 'package:geolocator/geolocator.dart';

class CarteCollectes extends StatefulWidget {
  const CarteCollectes({super.key});

  @override
  State<CarteCollectes> createState() => _CarteCollectesState();
}

class _CarteCollectesState extends State<CarteCollectes> {
  final CollecteController _collecteController = Get.put(CollecteController());
  final AuthController _authController = Get.find<AuthController>();
  
  final fm.MapController _mapController = fm.MapController();
  final latlng.LatLng _defaultCenter = const latlng.LatLng(0.4162, 9.4673);
  List<fm.Marker> _markers = [];
  Position? _currentPosition;
  bool _isLoading = true;
  bool _hasPermission = false;
  bool _mapReady = false;

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    // Demander la permission
    _hasPermission = await LocationService.requestLocationPermission();
    
    if (_hasPermission) {
      // Obtenir la position actuelle
      _currentPosition = await LocationService.getCurrentPosition();
    }

    // Charger les collectes pour la carte
    await _loadCollectesForMap();

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _loadCollectesForMap() async {
    try {
      final markers = <fm.Marker>[];
      final collecteurId = _authController.collecteurId;
      if (collecteurId == null) return;

      // Charger les collectes
      await _collecteController.loadCollectes(
        collecteurId: collecteurId,
        refresh: true,
      );

      // Créer les marqueurs
      for (var collecte in _collecteController.collectes) {
        // Récupérer la position de la collecte
        final location = await LocationService.getCollecteLocation(collecte.id);

        if (location != null) {
          final lat = (location['latitude'] as num?)?.toDouble();
          final lng = (location['longitude'] as num?)?.toDouble();
          
          if (lat != null && lng != null) {
            markers.add(
              fm.Marker(
                width: 44,
                height: 44,
                point: latlng.LatLng(lat, lng),
                child: _buildCollecteMarker(
                  title: collecte.contribuable?.fullName ?? 'Collecte',
                  subtitle: '${collecte.montant} XAF - ${collecte.statut}',
                  color: _markerColor(collecte.statut),
                ),
              ),
            );
          }
        }
      }

      // Ajouter un marqueur pour la position actuelle
      if (_currentPosition != null) {
        markers.add(
          fm.Marker(
            width: 44,
            height: 44,
            point: latlng.LatLng(
              _currentPosition!.latitude,
              _currentPosition!.longitude,
            ),
            child: _buildCollecteMarker(
              title: 'Ma position',
              subtitle: 'Position actuelle',
              color: Colors.blue,
              icon: Icons.my_location,
            ),
          ),
        );
      }

      setState(() {
        _markers = markers;
      });

      if (_mapReady) {
        _centerMap();
      }
    } catch (e) {
      print('❌ Erreur lors du chargement de la carte: $e');
    }
  }

  void _centerMap() {
    final target = _currentPosition != null
        ? latlng.LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
        : _defaultCenter;

    _mapController.move(target, _currentPosition != null ? 13 : 12);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Design.primaryColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Carte des collectes',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        centerTitle: true,
        backgroundColor: Design.primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadCollectesForMap,
            tooltip: 'Actualiser',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : !_hasPermission
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.location_off,
                        size: 64,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Permission de localisation requise',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Veuillez activer la localisation dans les paramètres',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          _hasPermission = await LocationService.requestLocationPermission();
                          if (_hasPermission) {
                            _initializeMap();
                          }
                        },
                        child: const Text('Réessayer'),
                      ),
                    ],
                  ),
                )
              : Stack(
                  children: [
                    fm.FlutterMap(
                      mapController: _mapController,
                      options: fm.MapOptions(
                        initialCenter: _currentPosition != null
                            ? latlng.LatLng(
                                _currentPosition!.latitude,
                                _currentPosition!.longitude,
                              )
                            : _defaultCenter,
                        initialZoom: 12,
                        onMapReady: () {
                          _mapReady = true;
                          _centerMap();
                        },
                      ),
                      children: [
                        fm.TileLayer(
                          urlTemplate:
                              'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                          subdomains: const ['a', 'b', 'c'],
                          userAgentPackageName: 'com.example.e_taxe',
                        ),
                        fm.MarkerLayer(markers: _markers),
                      ],
                    ),
                    
                    // Légende
                    Positioned(
                      bottom: 20,
                      left: 20,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildLegendItem('Complété', Colors.green),
                            const SizedBox(height: 4),
                            _buildLegendItem('En attente', Colors.orange),
                            const SizedBox(height: 4),
                            _buildLegendItem('Annulé', Colors.red),
                            const SizedBox(height: 4),
                            _buildLegendItem('Ma position', Colors.blue),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Color _markerColor(String statut) {
    switch (statut) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildCollecteMarker({
    required String title,
    required String subtitle,
    required Color color,
    IconData icon = Icons.location_on,
  }) {
    return Tooltip(
      message: '$title\n$subtitle',
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(4),
        child: Icon(
          icon,
          color: color,
          size: 28,
        ),
      ),
    );
  }
}

