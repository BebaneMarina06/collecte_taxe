import 'package:e_taxe/design/design.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClotureJournee extends StatelessWidget {
  const ClotureJournee({super.key});

  @override
  Widget build(BuildContext context) {
    final myWidth = MediaQuery.of(context).size.width;
    final myHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Design.primaryColor,

        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Get.offNamed('/CaissePhysique');
            },
          ),
        ),
        title: Center(
          child: const Text(
            'Clôture de la journée',
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
        ),
      ),
      backgroundColor: Design.primaryColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 15),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: const Text(
                "Renseigner les informations pour cloturer votre journee.",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: const Text(
                'Montant total de cash',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 12, color: Colors.black),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
            width: myWidth/1.1,
              child: TextField(
                cursorColor: Design.secondColor,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: '300 000',
                  hintStyle: TextStyle(color: Design.mediumGrey),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.white, width: 2),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.white, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  filled: true,
                  fillColor: Design.inputColor,
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        'XAF',
                        style: TextStyle(
                          color: Design.secondColor,
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 10,
              color: Design.inputColor,
        
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Design.inputColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                height: 60,
            width: myWidth/1.1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text(
                        '10 000 XAF',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
    const Spacer(), // pousse tout ce qui suit vers la droite
                      // Bouton +
                      GestureDetector(
                        onTap: () {
                          // Action pour ajouter
                        },
                        child: Container(
                          height: 35,
                          width: 37,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Center(
                            child: Icon(Icons.add, size: 20, color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text('0', style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 10),
                      // Bouton -
                      GestureDetector(
                        onTap: () {
                          // Action pour le bouton -
                        },
                        child: Container(
                          height: 35,
                          width: 37,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.remove,
                              size: 20,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 10,
              color: Design.inputColor,
        
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Design.inputColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                height: 60,
            width: myWidth/1.1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text(
                        '5000 XAF',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
    const Spacer(), // pousse tout ce qui suit vers la droite
                      // Bouton +
                      GestureDetector(
                        onTap: () {
                          // Action pour ajouter
                        },
                        child: Container(
                          height: 35,
                          width: 37,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Center(
                            child: Icon(Icons.add, size: 20, color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text('0', style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 10),
                      // Bouton -
                      GestureDetector(
                        onTap: () {
                          // Action pour le bouton -
                        },
                        child: Container(
                          height: 35,
                          width: 37,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.remove,
                              size: 20,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 10,
              color: Design.inputColor,
        
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Design.inputColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                height: 60,
            width: myWidth/1.1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text(
                        '2000 XAF',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
    const Spacer(), // pousse tout ce qui suit vers la droite
                      // Bouton +
                      GestureDetector(
                        onTap: () {
                          // Action pour ajouter
                        },
                        child: Container(
                          height: 35,
                          width: 37,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Center(
                            child: Icon(Icons.add, size: 20, color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text('0', style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 10),
                      // Bouton -
                      GestureDetector(
                        onTap: () {
                          // Action pour le bouton -
                        },
                        child: Container(
                          height: 35,
                          width: 37,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.remove,
                              size: 20,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 10,
              color: Design.inputColor,
        
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Design.inputColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                height: 60,
            width: myWidth/1.1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text(
                        '1000 XAF',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
    const Spacer(), // pousse tout ce qui suit vers la droite
                      // Bouton +
                      GestureDetector(
                        onTap: () {
                          // Action pour ajouter
                        },
                        child: Container(
                          height: 35,
                          width: 37,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Center(
                            child: Icon(Icons.add, size: 20, color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text('0', style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 10),
                      // Bouton -
                      GestureDetector(
                        onTap: () {
                          // Action pour le bouton -
                        },
                        child: Container(
                          height: 35,
                          width: 37,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.remove,
                              size: 20,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              color: Design.inputColor,
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Design.inputColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                height: 60,
            width: myWidth/1.1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text(
                        '500 XAF',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
    const Spacer(), // pousse tout ce qui suit vers la droite
                      // Bouton +
                      GestureDetector(
                        onTap: () {
                          // Action pour ajouter
                        },
                        child: Container(
                          height: 35,
                          width: 37,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Center(
                            child: Icon(Icons.add, size: 20, color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text('0', style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 10),
                      // Bouton -
                      GestureDetector(
                        onTap: () {
                          // Action pour le bouton -
                        },
                        child: Container(
                          height: 35,
                          width: 37,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.remove,
                              size: 20,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: myHeight/20),
            Container(
            width: myWidth/1.1,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Design.secondColor,
              ),
              child: TextButton(
                onPressed: () {},
                child: Text(
                  'Enregistrer',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            SizedBox(height: 5,)
          ],
        ),
      ),
    );
  }
}
