import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_portal/utils/colors.dart';
import 'package:pos_portal/utils/helpers.dart';
import 'package:pos_portal/widgets/button.dart';
import 'package:pos_portal/widgets/input_field.dart';

class DialogTunai extends StatefulWidget {
  final int totalPesanan;

  const DialogTunai({Key? key, required this.totalPesanan});

  @override
  State<DialogTunai> createState() => _DialogTunaiState();
}

class _DialogTunaiState extends State<DialogTunai> {
  TextEditingController inputUangDiterima = TextEditingController();
  int? uangDiterima = 0;
  int? kembalian;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      alignment: Alignment.bottomCenter,
      backgroundColor: Colors.white,
      contentPadding: EdgeInsets.zero,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Konfirmasi',
            style: GoogleFonts.dmSans(
              textStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.close_rounded),
          ),
        ],
      ), // Remove default padding
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.35,
                      child: InputField(
                        controller: inputUangDiterima,
                        label: 'Uang Diterima',
                        isDuit: true,
                        onNilaiAngkaChanged: (value) {
                          setState(() {
                            uangDiterima = value;
                          });
                        },
                        hintText: '0',
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: ButtonDefault(
                        title: 'Hitung',
                        onPressed: () {
                          if (uangDiterima != null &&
                              uangDiterima! >= widget.totalPesanan) {
                            hitungKembalian(uangDiterima!);
                            debugPrint(
                                'uang diterima ${uangDiterima.toString()}');
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Uang diterima kurang dari total pesanan')),
                            );
                          }
                        },
                        isFilled: true,
                        isNeedSvg: true,
                        svgPath: 'assets/svg/icon_calculator.svg',
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(16),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: MyColors.neutral),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total Pesanan',
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                'Rp ${formatRupiah(widget.totalPesanan)}',
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                          width: 1,
                          child: Container(
                            color: MyColors.neutral,
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Uang Kembalian',
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                'Rp ${formatRupiah((kembalian ?? 0))}',
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 16,
                                    color: MyColors.onSecondary,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.06,
                margin: EdgeInsets.only(bottom: 16, top: 8),
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: ButtonDefault(
                  title: 'Uang Sudah Diterima',
                  onPressed: (kembalian != null) ? () {} : () {},
                  isFilled: true,
                  isDisabled: (uangDiterima! < widget.totalPesanan),
                ),
              )
            ],
          ),
        ),
        // child: KonfirmasiTunai(context),
      ),
    );
  }

  void hitungKembalian(int uangDiterima) {
    int totalPesanan = widget.totalPesanan;
    int kembalian = uangDiterima - totalPesanan;
    setState(() {
      this.kembalian = kembalian;
    });
  }

  Column KonfirmasiTunai(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min, // Set the mainAxisSize to min
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SvgPicture.asset(
          'assets/svg/ilustrasi_tunai.svg',
          height: 173,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 8),
          child: Text(
            'Apakah Anda yakin sudah dibayar?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.055,
              width: MediaQuery.of(context).size.width * 0.32,
              child: ButtonDefault(
                title: 'Hitung',
                onPressed: () {},
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.055,
              width: MediaQuery.of(context).size.width * 0.32,
              child: ButtonDefault(
                title: 'Lanjutkan',
                isFilled: true,
                onPressed: () {},
              ),
            ),
          ],
        ),
        SizedBox(height: 24), // Add some bottom spacing
      ],
    );
  }
}
