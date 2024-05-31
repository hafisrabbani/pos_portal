import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:pos_portal/routes/route_name.dart';
import 'package:pos_portal/utils/colors.dart';
import 'package:pos_portal/view/app/app_template.dart';
import 'package:pos_portal/widgets/floating_button.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  OnBoardingPageState createState() => OnBoardingPageState();
}

class OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();
  int _currentIndex = 0;

  void _onIntroEnd(context) {
    Navigator.pushNamed(context, RoutesName.home);
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      onChange: _onPageChanged,
      key: introKey,
      globalBackgroundColor: Colors.white,
      allowImplicitScrolling: true,
      infiniteAutoScroll: false,
      globalHeader: Align(
        alignment: Alignment.center,
        child: SafeArea(
          child: SvgPicture.asset(
            'assets/onboarding/logo.svg',
            width: 50,
          ),
        ),
      ),
      globalFooter: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
            width: double.infinity,
            height: 60,
            child: FloatingButtonDefault(
              title: (_currentIndex < 2) ? 'Selanjutnya' : 'Mulai',
              actionPressed: () {
                if (_currentIndex == 3) {
                  _onIntroEnd(context);
                } else {
                  debugPrint('index: $_currentIndex');
                  introKey.currentState?.animateScroll(++_currentIndex);
                }
              },
              heroTag: 'onboarding',
              isFilled: true,
            )),
      ),
      pages: [
        PageViewModel(
          useScrollView: false,
          title: '',
          bodyWidget: SizedBox(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/onboarding/ill1.svg',
                ),
                const SizedBox(height: 20),
                SvgPicture.asset(
                  'assets/onboarding/posportal.svg',
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Mulai Jualan dengan Mudah!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
          decoration: const PageDecoration(
            boxDecoration: BoxDecoration(
              image: DecorationImage(
                  alignment: Alignment.topCenter,
                  image: AssetImage('assets/onboarding/bg1.png')),
            ),
          ),

          // image: _buildImage('img1.jpg'),
        ),
        PageViewModel(
          useScrollView: false,
          title: "",
          bodyWidget: SizedBox(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/onboarding/ill2.svg',
                ),
                SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Text(
                    'Catat transaksi penjualan untuk kelola keuangan toko dengan lebih efisien',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
          decoration: const PageDecoration(
            boxDecoration: BoxDecoration(
              image: DecorationImage(
                  alignment: Alignment.topCenter,
                  image: AssetImage('assets/onboarding/bg2.png')),
            ),
          ),
        ),
        PageViewModel(
          useScrollView: false,
          title: "",
          bodyWidget: SizedBox(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/onboarding/ill3.svg',
                ),
                const SizedBox(height: 50),
                const Padding(
                  padding: EdgeInsets.all(48.0),
                  child: Text(
                    'Pantau stok dan hindari kehabisan barang dengan fitur manajemen stok',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
          decoration: const PageDecoration(
            boxDecoration: BoxDecoration(
              image: DecorationImage(
                  alignment: Alignment.topCenter,
                  image: AssetImage('assets/onboarding/bg3.png')),
            ),
          ),
        ),
      ],
      onDone: () => _onIntroEnd(context),
      showNextButton: false,
      showDoneButton: false,
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: MyColors.neutral,
        activeSize: Size(36.0, 12.0),
        activeColor: MyColors.primary,
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
