import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'routes/routes.dart';
import 'controllers/auth_controller.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialiser le service de notifications
  await NotificationService.initialize();
  await initializeDateFormatting('fr');
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    // Initialiser le controller d'authentification
    Get.put(AuthController());
    
    return ScreenUtilInit(
      designSize: const Size(375, 812), // Taille de référence (iPhone X)
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'E-TAXE',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          initialRoute: Routes.ConnexionAgents,
          getPages: getPages,
        );
      },
    );
  }
}

