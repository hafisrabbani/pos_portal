import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pos_portal/data/type/product_type.dart';
import 'package:pos_portal/model/product.dart';
import 'package:pos_portal/routes/route_name.dart';
import 'package:pos_portal/utils/colors.dart';
import 'package:pos_portal/view_model/new_product_view_model.dart';
import 'package:pos_portal/widgets/button.dart';
import 'package:pos_portal/widgets/custom_dialog.dart';
import 'package:pos_portal/widgets/custom_text_field.dart';
import 'package:pos_portal/widgets/floating_button.dart';
import 'package:pos_portal/widgets/card_action.dart';
import 'package:pos_portal/widgets/new_card_products.dart';
import 'package:pos_portal/widgets/topbar.dart';

import '../../model/item_transaction.dart';

class NewProductPage extends StatefulWidget {
  const NewProductPage({super.key});

  @override
  State<NewProductPage> createState() => _NewProductPageState();
}

class _NewProductPageState extends State<NewProductPage>
    with SingleTickerProviderStateMixin {
  final tabs = const [
    Tab(text: "Semua"),
    Tab(text: "Menipis"),
    Tab(text: "Terlaris"),
  ];
  late TabController _tabController;
  final NewProductViewModel _newProductViewModel = NewProductViewModel();
  List<Product> products = [];
  List<Product> almostOutOfStockProducts = [];
  List<Product> bestSellerProducts = [];
  bool isShowSearch = false;
  final TextEditingController _searchController = TextEditingController();

  void filterProduct(String query) {
    final List<Product> filteredProducts = products
        .where((product) =>
            product.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      products = filteredProducts;
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
    _tabController.addListener(_handleTabSelection);
    loadProducts(ProductType.all);
    loadProducts(ProductType.almostOutOfStock);
    loadProducts(ProductType.bestSeller);
  }

  void _handleTabSelection() {
    if (!_tabController.indexIsChanging) {
      switch (_tabController.index) {
        case 0:
          loadProducts(ProductType.all);
          break;
        case 1:
          loadProducts(ProductType.almostOutOfStock);
          break;
        case 2:
          loadProducts(ProductType.bestSeller);
          break;
      }
    }
  }

  void loadProducts(ProductType type) async {
    final _products = await _newProductViewModel.loadProducts(type);
    setState(() {
      switch (type) {
        case ProductType.all:
          products = _products;
          break;
        case ProductType.almostOutOfStock:
          almostOutOfStockProducts = _products;
          break;
        case ProductType.bestSeller:
          bestSellerProducts = _products;
          break;
      }
    });
  }

  void reloadProducts() {
    _tabController.index = 0;
    loadProducts(ProductType.all);
    loadProducts(ProductType.almostOutOfStock);
    loadProducts(ProductType.bestSeller);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: topBar(context: context, title: 'Produk', isCanBack: false),
      body: Column(
        children: [
          isShowSearch
              ? Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          isShowSearch = false;
                          _searchController.clear();
                          _handleTabSelection();
                        });
                      },
                      icon: const Icon(Icons.arrow_back),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          filterProduct(value);
                        },
                        decoration: const InputDecoration(
                          hintText: 'Cari produk',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                )
              : Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          isShowSearch = true;
                        });
                      },
                      icon: const Icon(Icons.search),
                    ),
                    Expanded(
                      child: TabBar(
                        controller: _tabController,
                        tabs: tabs,
                        indicatorColor: MyColors.primary,
                        labelStyle: TextStyle(
                          color: MyColors.primary,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                buildTabContent(products, false),
                // Content for "Semua" tab
                buildTabContent(almostOutOfStockProducts, false),
                // Content for "Menipis" tab
                buildTabContent(bestSellerProducts, true),
                // Content for "Terlaris" tab
              ],
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingButtonDefault(
        heroTag: "product",
        title: 'Tambah Produk',
        actionPressed: () {
          Navigator.pushNamed(context, RoutesName.productAction,
              arguments: {'productId': 0});
        },
      ),
    );
  }

  void _showConfirmDeleteDialog(int idProduct) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomConfirmationDialog(
          title: 'Hapus Produk',
          content: 'Apakah Anda yakin ingin menghapus produk ini?',
          onConfirm: () async {
            bool isSuccess =
                await _newProductViewModel.deleteProduct(idProduct);
            if (isSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Produk berhasil dihapus'),
                ),
              );

              setState(() {
                reloadProducts();
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Produk gagal dihapus'),
                ),
              );
            }
            Navigator.of(context).pop();
          },
          onCancel: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  Widget buildTabContent(List<Product> products, bool isBestSellerTab) {
    return SingleChildScrollView(
      child: Column(
        children: products.isNotEmpty
            ? [
                ...products.asMap().entries.map((entry) {
                  final index = entry.key;
                  final product = entry.value;
                  return GestureDetector(
                    onLongPress: () {
                      _showConfirmDeleteDialog(product.id!);
                    },
                    child: NewCardProducts(
                      product: product,
                      isBestSeller: isBestSellerTab,
                      index: index,
                    ), // Tambahkan kurung kurawal penutup di sini
                  );
                }).toList(),
                const SizedBox(height: 100),
              ]
            : [
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('Tidak ada produk'),
                  ),
                ),
              ],
      ),
    );
  }
}
