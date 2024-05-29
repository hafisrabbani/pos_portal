import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pos_portal/utils/colors.dart';
import 'package:pos_portal/utils/helpers.dart';

class InputField extends StatefulWidget {
  final ValueChanged<int?>? onNilaiAngkaChanged;

  final String? label;
  final bool? isWajibIsi;
  final bool isDuit;
  late bool inputAngka;
  final bool? isExpanded;
  final String hintText;
  final String? initialValue;
  final TextEditingController controller;

  InputField({
    super.key,
    this.label = '',
    this.isDuit = false,
    required this.controller,
    this.onNilaiAngkaChanged,
    this.isExpanded,
    this.isWajibIsi = false,
    required this.hintText,
    this.inputAngka = false,
    this.initialValue,
  });

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    if (widget.isDuit) {
      widget.inputAngka = true;
    }
    final CurrencyTextInputFormatter formatter =
        CurrencyTextInputFormatter.currency(
      locale: 'id',
      decimalDigits: 0,
      symbol: widget.isDuit ? 'Rp ' : '',
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: (widget.label == '') ? 0 : 10),
          child: Row(
            children: [
              Text(
                widget.label ?? '',
                textAlign: TextAlign.left,
                style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF525666)),
              ),
              Text(
                widget.isWajibIsi! ? '*' : '',
                textAlign: TextAlign.left,
                style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: MyColors.error),
              ),
            ],
          ),
        ),
        TextFormField(
          initialValue: widget.initialValue,
          expands: widget.isExpanded ?? false,
          controller: widget.controller,
          cursorColor: MyColors.primary,
          keyboardType:
              widget.inputAngka ? (TextInputType.number) : TextInputType.text,
          onChanged: widget.inputAngka || widget.isDuit
              ? (value) {
                  if (value.isNotEmpty) {
                    final valueHarga = formatter.getUnformattedValue();
                    debugPrint('valueHarga ${valueHarga.toString()}');
                    widget.onNilaiAngkaChanged!(valueHarga as int? ?? 0);
                  }
                }
              : null,
          inputFormatters: widget.isDuit || widget.inputAngka
              ? <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                  formatter
                ]
              : <TextInputFormatter>[],
          style: const TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w500,
              fontSize: 17),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: MyColors.primary,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: MyColors.neutral,
              ),
            ),
            hintText: widget.hintText,
            hintStyle: const TextStyle(
              color: MyColors.neutral,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}
