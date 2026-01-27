import 'package:e_taxe/design/design.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CaissePhysique extends StatelessWidget {
  const CaissePhysique({super.key});

  @override
  Widget build(BuildContext context) {
    final myWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Design.primaryColor,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Get.offNamed('/Caisses');
            },
          ),
        ),
        title: const Text(
          'Caisse physique',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        centerTitle: true,
        backgroundColor: Design.primaryColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              width: myWidth / 1.1,
              child: Card(
                color: Design.orangeCustom, // orange vif
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Total collecté numériquement",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      const SizedBox(height: 12),

                      // Montant et devise
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            "500 000",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "XAF",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Ligne inférieure avec flèche et % en vert
                      Row(
                        children: [
                          Icon(
                            Icons.trending_up,
                            color: Colors.greenAccent,
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            "2.5%",
                            style: TextStyle(
                              color: Colors.greenAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            "que la semaine passé",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              width: myWidth / 1.1,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Design.secondColor,
              ),
              child: TextButton(
                onPressed: () {
                  Get.offNamed('/ClotureJournee');
                },
                child: Text(
                  'Cloturer la journée',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          // Champ de recherche
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
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
          ),
          SizedBox(height: 10),
          // Liste des dernieres collectes
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.toNamed('/DetailsClient');
                    },
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      color: Design.inputColor,
                      child: Container(
                        height: 62,
                        width: myWidth / 1.1,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  'Edvile N\'Ndong',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '02/07/2023 à 10:00',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(
                                          0xFFB6B6B6,
                                        ), // Ou Design.mediumGrey
                                      ),
                                    ),
                                    SizedBox(width: 100),
                                    Text(
                                      '3000 XAF',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFFB6B6B6),
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Colors.black54,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed('/DetailsClient');
                    },
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      color: Design.inputColor,
                      child: Container(
                        height: 62,
                        width: myWidth / 1.1,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  'Edvile N\'Ndong',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '02/07/2023 à 10:00',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(
                                          0xFFB6B6B6,
                                        ), // Ou Design.mediumGrey
                                      ),
                                    ),
                                    SizedBox(width: 100),
                                    Text(
                                      '3000 XAF',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFFB6B6B6),
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Colors.black54,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed('/DetailsClient');
                    },
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      color: Design.inputColor,
                      child: Container(
                        height: 62,
                        width: myWidth / 1.1,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  'Edvile N\'Ndong',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '02/07/2023 à 10:00',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(
                                          0xFFB6B6B6,
                                        ), // Ou Design.mediumGrey
                                      ),
                                    ),
                                    SizedBox(width: 100),
                                    Text(
                                      '3000 XAF',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFFB6B6B6),
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Colors.black54,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed('/DetailsClient');
                    },
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      color: Design.inputColor,
                      child: Container(
                        height: 62,
                        width: myWidth / 1.1,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  'Edvile N\'Ndong',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '02/07/2023 à 10:00',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(
                                          0xFFB6B6B6,
                                        ), // Ou Design.mediumGrey
                                      ),
                                    ),
                                    SizedBox(width: 100),
                                    Text(
                                      '3000 XAF',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFFB6B6B6),
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Colors.black54,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed('/DetailsClient');
                    },
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      color: Design.inputColor,
                      child: Container(
                        height: 62,
                        width: myWidth / 1.1,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  'Edvile N\'Ndong',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '02/07/2023 à 10:00',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(
                                          0xFFB6B6B6,
                                        ), // Ou Design.mediumGrey
                                      ),
                                    ),
                                    SizedBox(width: 100),
                                    Text(
                                      '3000 XAF',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFFB6B6B6),
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Colors.black54,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed('/DetailsClient');
                    },
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      color: Design.inputColor,
                      child: Container(
                        height: 62,
                        width: myWidth / 1.1,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  'Edvile N\'Ndong',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '02/07/2023 à 10:00',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(
                                          0xFFB6B6B6,
                                        ), // Ou Design.mediumGrey
                                      ),
                                    ),
                                    SizedBox(width: 100),
                                    Text(
                                      '3000 XAF',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFFB6B6B6),
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Colors.black54,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
