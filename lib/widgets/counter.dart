import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pos_portal/utils/colors.dart';

class Counter extends StatefulWidget {
  final ValueSetter<int> onChanged;
  final int? initialValue;
  final int? max;
  const Counter({super.key, required this.onChanged, this.initialValue, this.max});

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  @override
  void initState() {
    super.initState();
    _countController =
        TextEditingController(text: widget.initialValue.toString());
    _counterValue = widget.initialValue ?? 1;
  }

  @override
  void dispose() {
    _countController
        .dispose();
    super.dispose();
  }

  late TextEditingController _countController;
  int _counterValue = 1;

  void _incrementCount() {
    if(widget.max != null && _counterValue >= widget.max!) return;
    setState(() {
      _counterValue++;
      _countController.text = _counterValue.toString();
      widget.onChanged(_counterValue);
    });
  }

  void _decrementCount() {
    setState(() {
      if (_counterValue > 1) {
        _counterValue--;
        _countController.text = _counterValue.toString();
        widget.onChanged(_counterValue);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.07,
            height: MediaQuery.of(context).size.width * 0.08,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
            ),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.transparent, width: 0),
                    color: const Color.fromRGBO(0, 0, 0, 0.05),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  clipBehavior: Clip.hardEdge,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Center(
                      widthFactor: 0.7,
                      child: IconButton(
                        onPressed: _decrementCount,
                        icon: const Icon(Icons.remove),
                        iconSize: MediaQuery.of(context).size.width * 0.03,
                        color: Colors.black,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: const Border(
                            left: BorderSide(color: MyColors.neutral, width: 1),
                            right:
                                BorderSide(color: MyColors.neutral, width: 1),
                          ),
                        ),
                        child: TextFormField(
                          controller: _countController, // Update this line
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9]')), // Filter hanya angka
                            FilteringTextInputFormatter.deny(RegExp(
                                r'^0+(?!$)')), // Filter agar tidak dimulai dengan 0 kecuali jika 0 adalah satu-satunya angka
                          ],
                          validator: (value) {
                            final intValue = int.tryParse(value!);
                            if (intValue == null || intValue < 1) {
                              return 'Nilai minimum adalah 1';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            if (value.isEmpty) {
                              _countController.text = '1';
                              _counterValue = 1;
                            } else {
                              _counterValue = int.parse(value);
                            }
                          },

                          style: const TextStyle(
                              fontSize: 17,
                              color: Color(0xFF051529),
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w500),
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(4),
                                right: Radius.circular(4),
                              ),
                            ),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    ),
                    Center(
                      widthFactor: 0.7,
                      child: IconButton(
                        onPressed: _incrementCount,
                        icon: const Icon(Icons.add),
                        iconSize: MediaQuery.of(context).size.width * 0.03,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
