import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../services/storage_service.dart';
import '../apis/api_service.dart';

class DeviceService {
  static DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  
  /// Obtenir l'ID unique de l'appareil
  static Future<String?> getDeviceId() async {
    try {
      // Vérifier d'abord si on a un ID stocké
      final storedId = await StorageService.getDeviceId();
      if (storedId != null && storedId.isNotEmpty) {
        return storedId;
      }
      
      if (kIsWeb) {
        // Pour le web, générer un ID basé sur le navigateur
        final newId = 'web_${DateTime.now().millisecondsSinceEpoch}';
        await StorageService.saveDeviceId(newId);
        return newId;
      }
      
      // Pour mobile, générer un ID basé sur les infos de l'appareil
      final deviceId = await _generateDeviceIdFromInfo();
      if (deviceId != null) {
        await StorageService.saveDeviceId(deviceId);
        return deviceId;
      }
      
      // Fallback: générer un ID aléatoire
      return await _generateFallbackDeviceId();
    } catch (e) {
      print('❌ DeviceService: Erreur lors de la récupération de l\'ID: $e');
      return await _generateFallbackDeviceId();
    }
  }
  
  /// Générer un ID basé sur les informations de l'appareil
  static Future<String?> _generateDeviceIdFromInfo() async {
    try {
      String deviceInfoStr = '';
      
      if (Platform.isAndroid) {
        final androidInfo = await DeviceService.deviceInfo.androidInfo;
        deviceInfoStr = '${androidInfo.id}_${androidInfo.model}_${androidInfo.brand}_${androidInfo.device}';
      } else if (Platform.isIOS) {
        final iosInfo = await DeviceService.deviceInfo.iosInfo;
        deviceInfoStr = '${iosInfo.identifierForVendor ?? 'ios'}_${iosInfo.model}_${iosInfo.name}';
      } else {
        return null;
      }
      
      // Créer un hash MD5 pour avoir un ID stable et unique
      final bytes = utf8.encode(deviceInfoStr);
      final digest = md5.convert(bytes);
      final deviceId = 'device_${digest.toString()}';
      
      return deviceId;
    } catch (e) {
      print('❌ DeviceService: Erreur lors de la génération de l\'ID: $e');
      return null;
    }
  }
  
  /// Générer un ID de fallback
  static Future<String> _generateFallbackDeviceId() async {
    try {
      String deviceInfo = '';
      
      if (Platform.isAndroid) {
        final androidInfo = await DeviceService.deviceInfo.androidInfo;
        deviceInfo = '${androidInfo.id}_${androidInfo.model}_${androidInfo.brand}';
      } else if (Platform.isIOS) {
        final iosInfo = await DeviceService.deviceInfo.iosInfo;
        deviceInfo = '${iosInfo.identifierForVendor ?? 'ios'}_${iosInfo.model}';
      }
      
      final fallbackId = 'fallback_${deviceInfo.hashCode}';
      await StorageService.saveDeviceId(fallbackId);
      return fallbackId;
    } catch (e) {
      // Dernier recours
      final lastResortId = 'device_${DateTime.now().millisecondsSinceEpoch}';
      await StorageService.saveDeviceId(lastResortId);
      return lastResortId;
    }
  }
  
  /// Obtenir les informations de l'appareil
  static Future<Map<String, dynamic>> getDeviceInfo() async {
    try {
      final deviceId = await getDeviceId();
      Map<String, dynamic> info = {
        'device_id': deviceId,
        'platform': kIsWeb ? 'web' : (Platform.isAndroid ? 'android' : 'ios'),
      };
      
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        info.addAll({
          'manufacturer': androidInfo.manufacturer,
          'model': androidInfo.model,
          'brand': androidInfo.brand,
          'device': androidInfo.device,
          'android_version': androidInfo.version.release,
          'sdk_int': androidInfo.version.sdkInt,
        });
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        info.addAll({
          'name': iosInfo.name,
          'model': iosInfo.model,
          'system_name': iosInfo.systemName,
          'system_version': iosInfo.systemVersion,
          'identifier_for_vendor': iosInfo.identifierForVendor,
        });
      }
      
      return info;
    } catch (e) {
      print('❌ DeviceService: Erreur lors de la récupération des infos: $e');
      return {
        'device_id': await getDeviceId(),
        'platform': kIsWeb ? 'web' : (Platform.isAndroid ? 'android' : 'ios'),
        'error': e.toString(),
      };
    }
  }
  
  /// Enregistrer l'appareil auprès du backend
  static Future<bool> registerDevice(int collecteurId) async {
    try {
      final deviceInfo = await getDeviceInfo();
      final apiService = ApiService();
      
      final success = await apiService.registerDevice(
        collecteurId: collecteurId,
        deviceInfo: deviceInfo,
      );
      
      if (success) {
        await StorageService.saveDeviceRegistered(true);
        print('✅ DeviceService: Appareil enregistré avec succès');
      } else {
        print('❌ DeviceService: Échec de l\'enregistrement de l\'appareil');
      }
      
      return success;
    } catch (e) {
      print('❌ DeviceService: Erreur lors de l\'enregistrement: $e');
      return false;
    }
  }
  
  /// Vérifier si l'appareil est autorisé
  static Future<bool> isDeviceAuthorized(int collecteurId) async {
    try {
      final deviceId = await getDeviceId();
      if (deviceId == null) return false;
      
      final apiService = ApiService();
      return await apiService.isDeviceAuthorized(collecteurId, deviceId);
    } catch (e) {
      print('❌ DeviceService: Erreur lors de la vérification: $e');
      // En cas d'erreur, autoriser pour ne pas bloquer (peut être changé selon les besoins)
      return true;
    }
  }
}

