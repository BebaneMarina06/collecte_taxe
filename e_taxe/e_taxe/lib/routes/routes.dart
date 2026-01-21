import 'package:e_taxe/authentification/connexion.dart';
import 'package:e_taxe/vues/accueil_agent.dart';
import 'package:e_taxe/vues/actualite_agent.dart';
import 'package:e_taxe/vues/accessibilite_localisation.dart';
import 'package:e_taxe/vues/add_client.dart';
import 'package:e_taxe/vues/add_collecte.dart';
import 'package:e_taxe/vues/caisse_numerique.dart';
import 'package:e_taxe/vues/caisse_physique.dart';
import 'package:e_taxe/vues/caisses.dart';
import 'package:e_taxe/vues/choix_langue.dart';
import 'package:e_taxe/vues/clients.dart';
import 'package:e_taxe/vues/cloture_journee.dart';
import 'package:e_taxe/vues/details_client.dart';
import 'package:e_taxe/vues/details_collecte.dart';
import 'package:e_taxe/vues/historique_collecte.dart';
import 'package:e_taxe/vues/notifcations.dart';
import 'package:e_taxe/vues/profil.dart';
import 'package:e_taxe/vues/profils_informations.dart';
import 'package:e_taxe/vues/change_password.dart';
import 'package:e_taxe/vues/scanner_qr.dart';
import 'package:e_taxe/vues/carte_collectes.dart';
import 'package:get/get.dart';


class Routes{
  //routes connexion
  static  String ConnexionAgents = '/ConnexionAgents';
  // routes accueil agent
  static String AccueilAgent = '/AccueilAgent';
  // routes actualite agent
  static String ActualiteAgent = '/ActualiteAgent';
  // routes clients
  static String Clients = '/Clients';
  // routes details client
  static String DetailsClient = '/DetailsClient';
  // routes historique collecte
  static String HistoriqueCollecte = '/HistoriqueCollecte';
  // routes add client
  static String AddClient = '/AddClient';
  // routes details collecte
  static String DetailsCollecte = '/DetailsCollecte';
  // routes add collecte
  static String AddCollecte = '/AddCollecte';
  // routes caisses
  static String Caisses = '/Caisses';
  // routes cloture journee
  static String ClotureJournee = '/ClotureJournee';
  // routes caisse physique
  static String CaissePhysique='/CaissePhysique';
  // routes caisse numerique
  static String CaisseNumerique='/CaisseNumerique';
  // routes profil
  static String Profil='/Profil';
  // routes profil_information
  static String ProfilsInformations='/ProfilsInformations';
  // routes choix langue
  static String ChoixLangue='/ChoixLangue';
  // routes des notifications
  static String Notifcations='/Notifcations';
  // routes changement de mot de passe
  static String ChangePassword='/ChangePassword';
  // routes pour le menu bottom navigation bar
  static String MainNavigationRoute = '/MainNavigation';
  // accessibilite & langues
  static String AccessibiliteLocalisation = '/AccessibiliteLocalisation';
  // scanner QR code
  static String ScannerQR = '/ScannerQR';
  // carte des collectes
  static String CarteCollectes = '/CarteCollectes';



}

final getPages=[
//routes connexion Agents
GetPage(
  name:Routes.ConnexionAgents,
  page:()=>ConnexionAgents(),
  transition:Transition.fadeIn
)
// routes accueil agent
, GetPage(
  name:Routes.AccueilAgent,
  page:()=>AccueilAgent(),
  transition:Transition.fadeIn
),
// routes actualite agent
GetPage(
  name:Routes.ActualiteAgent,
  page:()=>ActualiteAgent(),
  transition:Transition.fadeIn
)
// routes clients
, GetPage(
  name:Routes.Clients,
  page:()=>Clients(),
  transition:Transition.fadeIn
),
// routes details client
GetPage(
  name:Routes.DetailsClient,
  page:()=>DetailsClient(),
  transition:Transition.fadeIn
),
// routes historique collecte
GetPage(
  name:Routes.HistoriqueCollecte,
  page:()=>HistoriqueCollecte(),
  transition:Transition.fadeIn
),
// routes add client
GetPage(
  name:Routes.AddClient,
  page:()=>AddClient(),
  transition:Transition.fadeIn
),
// routes details collecte
GetPage(
  name:Routes.DetailsCollecte,
  page:()=>DetailsCollecte(),
  transition:Transition.fadeIn
),
// routes add collecte
GetPage(
  name:Routes.AddCollecte,
  page:()=>AddCollecte(),
  transition:Transition.fadeIn
),

// routes caisses
GetPage(
  name:Routes.Caisses,
  page:()=>Caisses(),
  transition:Transition.fadeIn
),
// routes cloture journee
GetPage(
  name:Routes.ClotureJournee,
  page:()=>ClotureJournee(),
  transition:Transition.fadeIn
),
// routes caisse physique
GetPage(
  name:Routes.CaissePhysique,
  page:()=>CaissePhysique(),
  transition:Transition.fadeIn
),
// routes caisse numerique
GetPage(
  name:Routes.CaisseNumerique,
  page:()=>CaisseNumerique(),
  transition: Transition.fadeIn
),
// routes profil
GetPage(
  name:Routes.Profil,
  page:()=>Profil(),
  transition: Transition.fadeIn
),
// routes profil_informations
GetPage(
  name:Routes.ProfilsInformations,
  page:()=>ProfilsInformations(),
  transition: Transition.fadeIn
),
// routes choix de la langue
GetPage(
  name:Routes.ChoixLangue,
  page:()=>ChoixLangue(),
  transition: Transition.fadeIn
),
// routes des notifications
GetPage(
  name:Routes.Notifcations,
  page:()=>Notifcations(),
  transition: Transition.fadeIn
),
// routes changement de mot de passe
GetPage(
  name:Routes.ChangePassword,
  page:()=>ChangePassword(),
  transition: Transition.fadeIn
),
// accessibilite & langues
GetPage(
  name: Routes.AccessibiliteLocalisation,
  page: () => const AccessibiliteLocalisation(),
  transition: Transition.fadeIn,
),
// scanner QR code
GetPage(
  name: Routes.ScannerQR,
  page: () => const ScannerQR(),
  transition: Transition.fadeIn,
),
// carte des collectes
GetPage(
  name: Routes.CarteCollectes,
  page: () => const CarteCollectes(),
  transition: Transition.fadeIn,
),
// GetPage(
//   name: Routes.MainNavigationRoute,
//   page: ()=> const MainNavigation(),
//   transition: Transition.fadeIn
// ),
];