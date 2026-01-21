import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_taxe/design/design.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:flutter/material.dart' as cs;

class ActualiteAgent extends StatefulWidget {
  const ActualiteAgent({super.key});

  @override
  State<ActualiteAgent> createState() => _ActualiteAgentState();
}

class _ActualiteAgentState extends State<ActualiteAgent> {
  // Liste des image du slide
  List imageList=[
   { "id":1,"image_path":'assets/first_img_slide.png','titre':'une collecte de taxe municipale','paragraphe':'Digitalisez et optimisez la collecte des taxes municipale. Gagnez du temps , reduisez les erreurs et offrez un service modernisé à vos  contribuable'},
   { "id":2,"image_path":'assets/second_img_slide.png','titre':'Un suivi cotidien de vos collecte','paragraphe':'Consultez en temps reels les details de vos collectes. Suivez vos performances,visualisez les montants perçus et maitrisez votre activicté jour apres jours'},
  ];
    final CarouselSliderController carouselController = CarouselSliderController();
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final myWidth = MediaQuery.of(context).size.width;
    final myHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Design.primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            children: [
              Container(
                width: myWidth / 1.05,
                height: 320,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: CarouselSlider(
                  items: imageList.map((item) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        item['image_path'],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    );
                  }).toList(),
                  carouselController: carouselController,
                  options: CarouselOptions(
                    height: 320,
                    scrollPhysics: const BouncingScrollPhysics(),
                    autoPlay: true,
                    viewportFraction: 1.0,
                    onPageChanged: (index, reason) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: imageList.asMap().entries.map((entry) {
                  final isActive = currentIndex == entry.key;
                  return GestureDetector(
                    onTap: () => carouselController.animateToPage(entry.key),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: isActive ? 16 : 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: isActive
                            ? Design.secondColor
                            : Design.softSkyBlue,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) =>
                    FadeTransition(opacity: animation, child: child),
                child: Column(
                  key: ValueKey<int>(currentIndex),
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        imageList[currentIndex]['titre'],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        imageList[currentIndex]['paragraphe'],
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: myHeight * 0.15),
              Container(
                width: myWidth / 1.1,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Design.secondColor,
                ),
                child: TextButton(
                  onPressed: () {
                    Get.offNamed('/ConnexionAgents');
                  },
                  child: const Text(
                    'Se connecter',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}