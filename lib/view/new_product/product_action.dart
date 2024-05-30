import 'dart:io';
import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pos_portal/data/type/stock_type.dart';
import 'package:pos_portal/utils/colors.dart';
import 'package:pos_portal/view_model/new_product_view_model.dart';
import 'package:pos_portal/widgets/card_action.dart';
import 'package:pos_portal/widgets/floating_button.dart';
import 'package:pos_portal/widgets/input_field.dart';
import 'package:pos_portal/widgets/topbar.dart';
import 'package:pos_portal/model/product.dart';
import '../../routes/route_name.dart';

class NewProductAction extends StatefulWidget {
  const NewProductAction({super.key});

  @override
  State<NewProductAction> createState() => _NewProductActionState();
}

class _NewProductActionState extends State<NewProductAction> {
  List<List<dynamic>> _data = [];
  String? filePath;

  void _pickFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;
    String? filePath = result.files.first.path;

    if (filePath == null) return;

    final input = File(filePath).openRead();
    final fields = await input
        .transform(utf8.decoder)
        .transform(const CsvToListConverter())
        .toList();
    var temp = fields.sublist(1);
    List<List<dynamic>> temp0 = [];
    temp.forEach((element) {
      List<dynamic> row = element[0].toString().split(';');
      temp0.add(row);
    });
    setState(() {
      _data = temp0;
    });

    bool resultImport = await importData();
    if (resultImport) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Berhasil mengimport data'),
        ),
      );
      Navigator.pushNamed(context, RoutesName.product);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal mengimport data'),
        ),
      );
    }
  }

  Future<bool> importData() async {
    if (_data.isEmpty) return false;
    bool result = await newProductViewModel.importData(_data);
    return result;
  }

  final NewProductViewModel newProductViewModel = NewProductViewModel();
  TextEditingController namaProdukController = TextEditingController();
  TextEditingController hargaProdukController = TextEditingController();
  TextEditingController stokProdukController = TextEditingController();
  int? hargaProduk = 0;
  int? stokProduk = 0;
  int productId = 0;
  StockType? _character = StockType.unlimited;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _loadProduct();
      _isInitialized = true;
    }
  }

  Future<void> _loadProduct() async {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final productId = args['productId'];
    setState(() {
      this.productId = productId;
    });
    if (productId != 0) {
      final product = await newProductViewModel.getProductById(productId);
      setState(() {
        namaProdukController.text = product.name;
        hargaProdukController.text = (product.price.toInt()).toString();
        stokProdukController.text =
        product.stock != null ? product.stock.toString() : '';
        hargaProduk = product.price.toInt();
        stokProduk = product.stock;
        _character =
        product.stockType == 0 ? StockType.unlimited : StockType.limited;
      });
    }
  }

  @override
  void dispose() {
    namaProdukController.dispose();
    hargaProdukController.dispose();
    stokProdukController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final productId = args['productId'];
    return Scaffold(
      appBar: topBar(
          context: context,
          title: productId == 0 ? 'Tambah Produk' : 'Ubah Produk',
          isCanBack: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CardAction(
                    isImport: true,
                    onPressed: () {
                      _pickFile();
                    },
                  ),
                  const SizedBox(height: 20),
                  HeadingSection(title: 'Detail Produk'),
                  InputField(
                    controller: namaProdukController,
                    label: 'Nama Produk',
                    isWajibIsi: true,
                    hintText: 'Masukkan Nama Produk',
                  ),
                  const SizedBox(height: 25),
                  InputField(
                    controller: hargaProdukController,
                    label: 'Harga Produk',
                    isWajibIsi: true,
                    hintText: 'Rp 0',
                    isDuit: true,
                    onNilaiAngkaChanged: (value) {
                      setState(() {
                        hargaProduk = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24.0),
              child: Divider(
                thickness: 4,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeadingSection(title: 'Stok'),
                  RadioListTile<StockType>(
                    dense: true,
                    title: const Text(
                      'Tidak Terbatas',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                    value: StockType.unlimited,
                    groupValue: _character,
                    onChanged: (StockType? value) {
                      setState(() {
                        _character = value;
                      });
                    },
                    contentPadding: const EdgeInsets.all(0),
                    activeColor: MyColors.primary,
                  ),
                  RadioListTile<StockType>(
                    dense: true,
                    title: const Text(
                      'Terbatas',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                    value: StockType.limited,
                    groupValue: _character,
                    onChanged: (StockType? value) {
                      setState(() {
                        _character = value;
                      });
                    },
                    contentPadding: const EdgeInsets.all(0),
                    activeColor: MyColors.primary,
                  ),
                  if (_character == StockType.limited)
                    Container(
                      margin: const EdgeInsets.only(left: 54),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.35,
                        child: InputField(
                          controller: stokProdukController,
                          hintText: '0',
                          isWajibIsi: true,
                          label: 'Jumlah Stok',
                          inputAngka: true,
                          onNilaiAngkaChanged: (value) {
                            setState(() {
                              stokProduk = value;
                            });
                          },
                          onChanged: (p0) {
                            setState(() {
                              print(
                                  "stok contol : ${stokProdukController.text}");
                            });
                          },
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: FloatingButtonDefault(
          title: 'Simpan',
          heroTag: "addProduct",
          actionPressed: () async {
            if (isFilled) {
              bool result = productId == 0
                  ? await newProductViewModel.addProduct(product)
                  : await newProductViewModel.updateProduct(product);
              if (result) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Berhasil menyimpan produk'),
                  ),
                );
                Navigator.pushNamed(context, RoutesName.product);
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Harap isi semua data'),
                ),
              );
            }
          },
          isFilled: true,
          isDisabled: !isFilled,
        ),
      ),
    );
  }

  bool get isFilled =>
      namaProdukController.text.isNotEmpty &&
          hargaProdukController.text.isNotEmpty &&
          (stokProdukController.text.isNotEmpty ||
              _character == StockType.unlimited);

  Product get product => Product(
      id: productId == 0 ? null : productId,
      name: namaProdukController.text,
      price: hargaProduk!.toDouble(),
      stockType: _character == StockType.unlimited ? 0 : 1,
      stock: _character == StockType.unlimited ? null : stokProduk);

  Container HeadingSection({required String title}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Text(title,
          style: const TextStyle(
              fontSize: 18,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w600)),
    );
  }
}
