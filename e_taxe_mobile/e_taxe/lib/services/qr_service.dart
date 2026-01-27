import 'dart:convert';
import 'package:http/http.dart' as http;
import '../apis/api_service.dart';
import '../models/contribuable.dart';
import '../services/storage_service.dart';

class QRService {

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

  /// Scanner un QR code et récupérer le contribuable associé
  static Future<Contribuable?> scanContribuableQR(String qrCode) async {
    try {
      print('📱 QRService: Scan QR code: $qrCode');
      
      // Appel API pour récupérer le contribuable par QR code
      final url = await ApiService.baseUrl;
      final response = await http.get(
        Uri.parse('$url/api/contribuables/qr/$qrCode'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('✅ QRService: Contribuable trouvé: ${data['nom']} ${data['prenom']}');
        return Contribuable.fromJson(data);
      } else if (response.statusCode == 404) {
        print('⚠️ QRService: Contribuable non trouvé pour QR code: $qrCode');
        return null;
      } else {
        print('❌ QRService: Erreur ${response.statusCode}: ${response.body}');
        throw Exception('Erreur lors du scan du QR code');
      }
    } catch (e) {
      print('❌ QRService: Exception lors du scan: $e');
      throw Exception('Erreur lors du scan du QR code: $e');
    }
  }

  /// Vérifier un reçu par QR code
  static Future<Map<String, dynamic>?> verifyReceiptQR(String qrCode) async {
    try {
      print('📱 QRService: Vérification reçu QR code: $qrCode');
      
      final url = await ApiService.baseUrl;
      final response = await http.get(
        Uri.parse('$url/api/collectes/qr/$qrCode'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('✅ QRService: Reçu trouvé: ${data['reference']}');
        return data as Map<String, dynamic>;
      } else if (response.statusCode == 404) {
        print('⚠️ QRService: Reçu non trouvé pour QR code: $qrCode');
        return null;
      } else {
        print('❌ QRService: Erreur ${response.statusCode}: ${response.body}');
        throw Exception('Erreur lors de la vérification du reçu');
      }
    } catch (e) {
      print('❌ QRService: Exception lors de la vérification: $e');
      throw Exception('Erreur lors de la vérification du reçu: $e');
    }
  }

  /// Générer un QR code pour un reçu (retourne les données à encoder)
  static String generateReceiptQRCode(int collecteId, String reference) {
    final qrData = {
      'type': 'receipt',
      'collecte_id': collecteId,
      'reference': reference,
      'timestamp': DateTime.now().toIso8601String(),
    };
    return json.encode(qrData);
  }
}
