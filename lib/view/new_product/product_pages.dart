import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:pos_portal/data/type/product_type.dart';
import 'package:pos_portal/model/product.dart';
import 'package:pos_portal/routes/route_name.dart';
import 'package:pos_portal/utils/colors.dart';
import 'package:pos_portal/view_model/new_product_view_model.dart';
import 'package:pos_portal/widgets/button.dart';
import 'package:pos_portal/widgets/custom_dialog.dart';
import 'package:pos_portal/widgets/floating_button.dart';
import 'package:pos_portal/widgets/card_action.dart';
import 'package:pos_portal/widgets/new_card_products.dart';
import 'package:pos_portal/widgets/topbar.dart';

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
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
    _tabController.addListener(_handleTabSelection);
    loadProducts(ProductType.all);
  }

  void _handleTabSelection() {
    if (!_tabController.indexIsChanging) {
      switch (_tabController.index) {
        case 0:
          loadProducts(ProductType.all);
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

  void loadProducts(ProductType type) async{
    final _products = await _newProductViewModel.loadProducts(type);
    setState(() {
      products = _products;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: topBar(
        context: context,
        title: 'Produk',
      ),
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
            child: TabBarView(
              controller: _tabController,
              children: [
                buildTabContent(products), // Content for "Semua" tab
                buildTabContent(products), // Content for "Menipis" tab
                buildTabContent(products), // Content for "Terlaris" tab
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
          Navigator.pushNamed(context, RoutesName.productAction, arguments: {'productId': 0});
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
            bool isSucceed = await _newProductViewModel.deleteProduct(idProduct);
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

  Widget buildTabContent(List<Product> products) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ...products.map((product) {
            print('product: ${product.name}');
            return NewCardProducts(product: product);
          }),
        ],
      ),
    );
  }
}

