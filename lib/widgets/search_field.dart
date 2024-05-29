import 'package:flutter/material.dart';
import 'package:pos_portal/utils/colors.dart';

class SearchField extends StatefulWidget {
  final TextEditingController controller;
  final bool isAdaBatal;

  const SearchField({
    super.key,
    required this.controller,
    this.isAdaBatal = false,
  });

  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  @override
  void initState() {
    super.initState();
    // Add a listener to the controller to rebuild the widget when the text changes
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    // Remove the listener when the widget is disposed
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    // Rebuild the widget when the text changes
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return widget.isAdaBatal
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.71,
                child: TextFormField(
                  controller: widget.controller,
                  style:
                      const TextStyle(fontFamily: 'Montserrat', fontSize: 17),
                  decoration: InputDecoration(
                    suffixIcon: widget.controller.text.isNotEmpty
                        ? IconButton(
                            onPressed: widget.controller.clear,
                            icon: const Icon(
                              Icons.cancel_rounded,
                              color: MyColors.neutral,
                            ),
                          )
                        : null,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: MyColors.primary),
                    ),
                    prefixIcon: Icon(Icons.search, color: MyColors.neutral),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: MyColors.tertiary,
                    hintText: 'Cari',
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.17,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'Batal',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: MyColors.primary,
                      ),
                    ),
                  ),
                ),
              )
            ],
          )
        : TextFormField(
            controller: widget.controller,
            style: const TextStyle(fontFamily: 'Montserrat', fontSize: 17),
            decoration: InputDecoration(
              suffixIcon: widget.controller.text.isNotEmpty
                  ? IconButton(
                      onPressed: widget.controller.clear,
                      icon: const Icon(
                        Icons.cancel_rounded,
                        color: MyColors.neutral,
                      ),
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: MyColors.primary),
              ),
              prefixIcon: Icon(Icons.search, color: MyColors.neutral),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: MyColors.tertiary,
              hintText: 'Cari',
            ),
          );
  }
}
