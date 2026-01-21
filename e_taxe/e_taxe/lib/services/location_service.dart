import 'package:geolocator/geolocator.dart';
import '../apis/api_service.dart';
import '../services/storage_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LocationService {

  static Future<Map<String, String>> _getHeaders() async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    final token = await StorageService.getToken();
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  /// Demander les permissions de localisation
  static Future<bool> requestLocationPermission() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('⚠️ LocationService: Permission de localisation refusée');
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print('❌ LocationService: Permission de localisation refusée définitivement');
        return false;
      }

      print('✅ LocationService: Permission de localisation accordée');
      return true;
    } catch (e) {
      print('❌ LocationService: Erreur lors de la demande de permission: $e');
      return false;
    }
  }

  /// Obtenir la position actuelle
  static Future<Position?> getCurrentPosition() async {
    try {
      final hasPermission = await requestLocationPermission();
      if (!hasPermission) {
        return null;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      print('✅ LocationService: Position obtenue: ${position.latitude}, ${position.longitude}');
      return position;
    } catch (e) {
      print('❌ LocationService: Erreur lors de la récupération de la position: $e');
      return null;
    }
  }

  /// Enregistrer la position GPS d'une collecte
  static Future<bool> saveCollecteLocation(int collecteId, Position position) async {
    try {
      print('📱 LocationService: Enregistrement position pour collecte $collecteId');
      
      final url = await ApiService.baseUrl;
      final response = await http.post(
        Uri.parse('$url/api/collectes/$collecteId/location'),
        headers: await _getHeaders(),
        body: json.encode({
          'latitude': position.latitude,
          'longitude': position.longitude,
          'accuracy': position.accuracy,
          'altitude': position.altitude,
          'heading': position.heading,
          'speed': position.speed,
          'timestamp': position.timestamp.toIso8601String(),
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ LocationService: Position enregistrée avec succès');
        return true;
      } else {
        print('❌ LocationService: Erreur ${response.statusCode}: ${response.body}');
        return false;
      }
    } catch (e) {
      print('❌ LocationService: Exception lors de l\'enregistrement: $e');
      return false;
    }
  }

  /// Récupérer la position d'une collecte
  static Future<Map<String, dynamic>?> getCollecteLocation(int collecteId) async {
    try {
      final url = await ApiService.baseUrl;
      final response = await http.get(
        Uri.parse('$url/api/collectes/$collecteId/location'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        return null;
      }
    } catch (e) {
      print('❌ LocationService: Erreur lors de la récupération: $e');
      return null;
    }
  }

  /// Vérifier si la position est dans une zone autorisée
  static Future<bool> isInAuthorizedZone(Position position, int collecteurId) async {
    try {
      final url = await ApiService.baseUrl;
      final response = await http.get(
        Uri.parse('$url/api/collecteurs/$collecteurId/zones'),
        headers: await _getHeaders(),
      );

      List<Map<String, dynamic>> zones = [];
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        zones = data.map((item) => item as Map<String, dynamic>).toList();
      }
      
      if (zones.isEmpty) {
        // Si aucune zone définie, autoriser partout
        return true;
      }

      // Vérifier si la position est dans l'une des zones
      for (var zone in zones) {
        final centerLat = zone['latitude'] as double?;
        final centerLng = zone['longitude'] as double?;
        final radius = zone['radius'] as double? ?? 1000.0; // Rayon par défaut: 1km

        if (centerLat != null && centerLng != null) {
          final distance = Geolocator.distanceBetween(
            centerLat,
            centerLng,
            position.latitude,
            position.longitude,
          );

          if (distance <= radius) {
            print('✅ LocationService: Position dans la zone autorisée');
            return true;
          }
        }
      }

      print('⚠️ LocationService: Position hors zone autorisée');
      return false;
    } catch (e) {
      print('❌ LocationService: Erreur lors de la vérification de zone: $e');
      // En cas d'erreur, autoriser pour ne pas bloquer
      return true;
    }
  }
}
