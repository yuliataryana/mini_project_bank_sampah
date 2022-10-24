import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mini_project_bank_sampah/common/utils.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final onBoardItem = [
    {
      "image": "assets/intro1.png",
      "title": "Jangan Buang Sampahmu!",
      "description": "Ayo kumpulkan dan pilah sampahmu!"
    },
    {
      "image": "assets/intro2.png",
      "title": "Nabung dengan Mudah",
      "description": "Tabungkan di Bank Sampah SAHAJA!"
    },
    {
      "image": "assets/intro3.png",
      "title": "Gabung dan Panen Komisi!",
      "description":
          "Dengan bergabung dan mengumpulkan sampah, akan dapat komisi"
    },
  ];

  int _currentPage = 0;

  late final PageController _pageController;

  @override
  void initState() {
    _pageController = PageController();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // create onboarding page with skip button, dot indicator,  and done button
    // when done button pressed, navigate to login page

    return Scaffold(
      backgroundColor: hexToColor('#F0F6DC'),
      body: Stack(
        children: <Widget>[
          PageView.builder(
            controller: _pageController,
            itemCount: onBoardItem.length,
            itemBuilder: (context, index) {
              return Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(onBoardItem[index]['image'] ?? ""),
                    Text(
                      onBoardItem[index]['title'] ?? "",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.bokor(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: hexToColor("#7A9D30"),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      onBoardItem[index]['description'] ?? "",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.livvic(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Column(
              children: [
                _currentPage < 2
                    ? const SizedBox()
                    : Row(
                        children: [
                          Expanded(child: Container()),
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/welcome');
                              },
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                backgroundColor: hexToColor("#7A9D30"),
                              ),
                              child: Text(
                                "Mulai",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.livvic(
                                    color: hexToColor("#F0F6DC"), fontSize: 18),
                              ),
                            ),
                          ),
                          Expanded(child: Container()),
                        ],
                      ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/welcome');
                      },
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          color: hexToColor('#7A9D30'),
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Row(
                      children: List.generate(
                        onBoardItem.length,
                        (index) => buildDot(index: index),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        if (_currentPage >= 2) {
                          Navigator.pushNamed(context, '/welcome');
                        } else {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.ease,
                          );
                        }
                      },
                      child: Text(
                        _currentPage == 2 ? 'Done' : "Next",
                        style: TextStyle(
                          color: hexToColor('#7A9D30'),
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  AnimatedContainer buildDot({required int index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 16),
      height: 12,
      width: 12,
      decoration: BoxDecoration(
        color: index == _currentPage
            ? Theme.of(context).primaryColor
            : Colors.grey,
        shape: BoxShape.circle,
      ),
    );
  }
}
