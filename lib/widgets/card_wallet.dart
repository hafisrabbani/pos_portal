import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CardWallet extends StatefulWidget {
  const CardWallet({
    super.key,
  });

  @override
  State<CardWallet> createState() => _CardWalletState();
}

class _CardWalletState extends State<CardWallet> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Color(0xFF0C2073),
            borderRadius: BorderRadius.circular(16),
          ),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.187,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                Positioned(
                  right: 0,
                  child: SvgPicture.asset('assets/svg/card_element_right.svg'),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child:
                      SvgPicture.asset('assets/svg/card_element_topright.svg'),
                ),
                Positioned(
                  right: 0,
                  child: SvgPicture.asset(
                      'assets/svg/card_element_curvedline.svg'),
                ),
                Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset('assets/svg/logo_white.svg',
                                width: 20, height: 26.89),
                            SizedBox(width: 8),
                            Text(
                              'Total Omzet',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 14),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            'Rp 4.500.000',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          ),
                        ),
                        Text(
                          '10/05/2024',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ]),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
