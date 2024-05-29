// transaction_id_card.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pos_portal/utils/colors.dart';

class CopyIdClipboard extends StatefulWidget {
  final int transactionId;

  const CopyIdClipboard({required this.transactionId, super.key});

  @override
  _CopyIdClipboardState createState() => _CopyIdClipboardState();
}

class _CopyIdClipboardState extends State<CopyIdClipboard> {
  bool _isCopied = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 45,
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.25),
                  spreadRadius: 2,
                  blurRadius: 2,
                  offset: const Offset(0, 2), // changes position of shadow
                ),
              ],
              color: Colors.white,
              border: Border.all(
                color: MyColors.neutral,
                width: 1,
              ),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4), bottomLeft: Radius.circular(4)),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Text(
                widget.transactionId.toString(),
                style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
                    color: MyColors.primary),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 45,
          child: Container(
            height: 45,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.25),
                  spreadRadius: 2,
                  blurRadius: 2,
                  offset: const Offset(0, 2), // changes position of shadow
                ),
              ],
              border: const Border(
                top: BorderSide(color: Colors.grey), // Border atas
                bottom: BorderSide(color: Colors.grey), // Border bawah
                right: BorderSide(color: Colors.grey), // Border kanan
              ),
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(4),
                  bottomRight: Radius.circular(4)),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
              child: GestureDetector(
                onTap: () {
                  Clipboard.setData(
                      ClipboardData(text: widget.transactionId.toString()));
                  setState(() {
                    _isCopied = true;
                  });
                  Future.delayed(const Duration(seconds: 2), () {
                    setState(() {
                      _isCopied = false;
                    });
                  });
                },
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: _isCopied
                      ? Icon(
                          Icons.check,
                          color: Colors.green,
                          key: ValueKey<bool>(_isCopied),
                        )
                      : Column(
                          key: ValueKey<bool>(
                              _isCopied), // Unique key for the Column
                          children: const [
                            Icon(
                              Icons.content_copy_rounded,
                              color: Colors.black54,
                            ),
                            Text(
                              'COPY',
                              style: TextStyle(
                                fontSize: 8,
                                fontFamily: 'Montserrat',
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
