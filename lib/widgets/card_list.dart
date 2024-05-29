// import 'package:flutter/material.dart';
// import 'package:pos_portal/data/type/product_type.dart';
// import 'package:pos_portal/model/cart.dart';
// import 'package:pos_portal/utils/colors.dart';
// import 'package:pos_portal/view_model/cart_provider.dart';
// import 'package:pos_portal/view_model/cart_view_model.dart';
// import 'package:pos_portal/view_model/product_view_model.dart';
// import 'package:pos_portal/widgets/counter.dart';
// import '../model/product.dart';
//
// class CardList extends StatefulWidget {
//   CardList({super.key});
//
//   @override
//   State<CardList> createState() => _CardListState();
// }
//
// class _CardListState extends State<CardList> {
//   late List<bool> isClickedList;
//   final ProductViewModel _productViewModel = ProductViewModel();
//   final CartProvider _cartProvider = CartProvider();
//   bool loading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadProducts();
//     isClickedList = List.generate(1, (index) => false);
//   }
//
//   void _loadProducts() async {
//     await _productViewModel.loadProducts(ProductType.all);
//     setState(() {
//       isClickedList = List.generate(
//           _productViewModel.productsNotifier.value.length,
//           (index) => _cartProvider.isProductInCart(
//               _productViewModel.productsNotifier.value[index].id!));
//       loading = false;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(top: 16, bottom: 24),
//       height: MediaQuery.of(context).size.height * 0.72,
//       child: loading == true
//           ? const Center(
//               child: CircularProgressIndicator(),
//             )
//           : ValueListenableBuilder<List<Product>>(
//               valueListenable: _productViewModel.productsNotifier,
//               builder: (context, products, _) {
//                 return ListView.builder(
//                   itemBuilder: (context, index) {
//                     final product = products[index];
//                     return Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 4.0),
//                       child: Card(
//                         elevation: 0,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         color: MyColors.secondaryDisabled,
//                         child: InkWell(
//                           onTap: () {
//                             _addOrRemoveCart(Cart(
//                                 productId: product.id!,
//                                 quantity: 1,
//                                 price: product.price));
//                             setState(() {
//                               isClickedList[index] = !isClickedList[index];
//                             });
//                           },
//                           child: ListTile(
//                             title: Text(
//                               product.name,
//                               style: const TextStyle(
//                                 fontFamily: 'Montserrat',
//                                 fontWeight: FontWeight.w500,
//                                 fontSize: 14,
//                               ),
//                             ),
//                             subtitle: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Rp ${product.price}',
//                                   style: const TextStyle(
//                                     fontFamily: 'Montserrat',
//                                     fontWeight: FontWeight.w700,
//                                     fontSize: 14,
//                                     color: MyColors.primary,
//                                   ),
//                                 ),
//                                 Text(
//                                   'Stock: ${(product.stockType == 0) ? 'Unlimited' : product.stock}',
//                                   style: const TextStyle(
//                                     fontFamily: 'Montserrat',
//                                     fontWeight: FontWeight.w500,
//                                     fontSize: 10,
//                                     color: MyColors.warning,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             trailing: isClickedList[index]
//                                 ? SizedBox(
//                                     width: 100,
//                                     child: Counter(
//                                       initialValue: 0,
//                                       max: product.stock,
//                                       onChanged: (value) {
//                                         _addToCart(Cart(
//                                             productId: product.id!,
//                                             quantity: value,
//                                             price: product.price));
//                                       },
//                                     ),
//                                   )
//                                 : const SizedBox(),
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                   itemCount: products.length,
//                 );
//               },
//             ),
//     );
//   }
//
//   void _addToCart(Cart cart) {
//     _cartProvider.addToCart(cart);
//   }
//
//   void _addOrRemoveCart(Cart cart) {
//     if (_cartProvider.isProductInCart(cart.productId)) {
//       _cartProvider.removeFromCart(cart.productId);
//     } else {
//       _cartProvider.addToCart(cart);
//     }
//   }
// }
//
//
//


import 'package:flutter/material.dart';
import 'package:pos_portal/data/type/product_type.dart';
import 'package:pos_portal/utils/colors.dart';
import 'package:pos_portal/utils/helpers.dart';
import 'package:pos_portal/view_model/product_view_model.dart';
import 'package:pos_portal/widgets/counter.dart';

class CardList extends StatefulWidget {
  final Function(List<Map<String, dynamic>>, double) onSelectionChanged;

  const CardList({
    Key? key,
    required this.onSelectionChanged,
  }) : super(key: key);

  @override
  State<CardList> createState() => _CardListState();
}

class _CardListState extends State<CardList> {
  late List<bool> isClickedList;
  late List<int> itemQuantities;
  final ProductViewModel _productViewModel = ProductViewModel();
  List<Map<String, dynamic>> selectedItems = [];
  int totalAmount = 0;

  void _loadProducts() async {
    await _productViewModel.loadProducts(ProductType.all);
    setState(() {
      isClickedList = List.generate(
          _productViewModel.productsNotifier.value.length,
          (index) => false);
      itemQuantities = List.generate(
          _productViewModel.productsNotifier.value.length,
          (index) => 1);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void updateSelectedCount() {
    selectedItems = [];
    double totalAmount = 0;
    for (int i = 0; i < isClickedList.length; i++) {
      if (isClickedList[i]) {
        totalAmount += (_productViewModel.productsNotifier.value[i].price) * itemQuantities[i];
        selectedItems.add({
          'productId': _productViewModel.productsNotifier.value[i].id!,
          'name': _productViewModel.productsNotifier.value[i].name,
          'price': _productViewModel.productsNotifier.value[i].price,
          'quantity': itemQuantities[i]
        });
      }
    }
    widget.onSelectionChanged(selectedItems, totalAmount);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16, bottom: 24),
      height: MediaQuery.of(context).size.height * 0.72,
      child: ListView.builder(
        itemBuilder: (context, index) {
          final item = _productViewModel.productsNotifier.value[index];

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: MyColors.secondaryDisabled,
              child: InkWell(
                onTap: () {
                  print("index: $index");
                  setState(() {
                    if (isClickedList[index]) {
                      isClickedList[index] = false;
                      itemQuantities[index] = 1;
                    } else {
                      isClickedList[index] = true;
                    }
                    updateSelectedCount();
                  });
                },
                child: ListTile(
                  title: Text(
                    item.name,
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                      Text(
                        'Rp ${formatRupiah(item.price.toInt())}',
                        style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: MyColors.primary,
                        ),
                      ),
                      Text(
                        'Stock: ${(item.stockType == 0) ? 'Unlimited' : item.stock}',
                        style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w500,
                          fontSize: 10,
                          color: MyColors.warning,
                        ),
                      ),
                    ]
                  ),
                  trailing: isClickedList[index]
                      ? SizedBox(
                    width: 100,
                    child: Counter(
                      max: (item.stockType == 0) ? null : item.stock,
                      initialValue: itemQuantities[index],
                      onChanged: (value) {
                        setState(() {
                          itemQuantities[index] = value; // This line seems to be causing the issue
                          updateSelectedCount();
                        });
                      },
                    ),
                  )
                      : const SizedBox(),
                ),
              ),
            ),
          );
        },
        itemCount: _productViewModel.productsNotifier.value.length,
      ),
    );
  }
}
