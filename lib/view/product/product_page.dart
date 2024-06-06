import 'package:flutter/material.dart';
import 'package:pos_portal/utils/colors.dart';
import 'package:pos_portal/view_model/product_view_model.dart';
import 'package:pos_portal/widgets/custom_dialog.dart';
import 'package:pos_portal/widgets/floating_button.dart';
import 'package:pos_portal/widgets/topbar.dart';

import '../../data/type/product_type.dart';
import '../../model/product.dart';
import '../../routes/route_name.dart';
import '../../widgets/card_product.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage>
    with SingleTickerProviderStateMixin {
  final tabs = const [
    Tab(text: "Semua"),
    Tab(text: "Menipis"),
    Tab(text: "Terlaris"),
  ];
  late TabController _tabController;
  final ProductViewModel _productViewModel = ProductViewModel();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
    _tabController.addListener(_handleTabSelection);
    _productViewModel.addListener(_updateProducts);
    loadProducts(ProductType.all);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    _productViewModel.removeListener(_updateProducts);
    super.dispose();
  }

  void _handleTabSelection() {
    if (!_tabController.indexIsChanging) {
      switch (_tabController.index) {
        case 0:
          loadProducts(ProductType.all);
          print('all');
          break;
        case 1:
          loadProducts(ProductType.almostOutOfStock);
          print('almost out of stock');
          break;
        case 2:
          loadProducts(ProductType.bestSeller);
          print('best seller');
          break;
      }
    }
  }

  void loadProducts(ProductType type) {
    _productViewModel.loadProducts(type);
  }

  void _updateProducts() {
    setState(() {});
  }

  void _showConfirmDeleteDialog(int idProduct) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomConfirmationDialog(
          title: 'Hapus Produk',
          content: 'Apakah Anda yakin ingin menghapus produk ini?',
          onConfirm: () async {
            bool isSucceed = await _productViewModel.deleteProduct(idProduct);
            if (isSucceed) {
              _handleTabSelection();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Produk berhasil dihapus'),
                ),
              );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: topBar(context: context, title: 'Produk', isCanBack: false),
      body: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.search),
              ),
              Expanded(
                child: TabBar(
                  controller: _tabController,
                  tabs: tabs,
                  indicatorColor: MyColors.primary,
                ),
              ),
            ],
          ),
          Expanded(
            child: ValueListenableBuilder<List<Product>>(
              valueListenable: _productViewModel.productsNotifier,
              builder: (context, products, _) {
                return TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _tabController,
                  children: [
                    buildTabContent(products), // Content for "Semua" tab
                    buildTabContent(products), // Content for "Menipis" tab
                    buildTabContent(products), // Content for "Terlaris" tab
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingButtonDefault(
        heroTag: "product",
        title: 'Tambah Produk',
        actionPressed: () {
          _productViewModel.saveSelectedProductId(0);
          Navigator.pushNamed(context, RoutesName.productAction);
        },
      ),
    );
  }

  Widget buildTabContent(List<Product> products) {
    return SingleChildScrollView(
      child: Column(
        children: products.isNotEmpty
            ? [
                ...products.map((product) {
                  return GestureDetector(
                    onLongPress: () {
                      _showConfirmDeleteDialog(product.id!);
                    },
                    child: CardProducts(product: product),
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
