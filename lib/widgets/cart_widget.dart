// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:provider/provider.dart';
// import 'package:pos_portal/view_model/cart_view_model.dart';
// import '../utils/colors.dart';
// import '../model/cart.dart';
//
// class CartShop extends StatefulWidget {
//   const CartShop({super.key});
//
//   @override
//   State<CartShop> createState() => _CartShopState();
// }
//
// class _CartShopState extends State<CartShop> {
//   @override
//   Widget build(BuildContext context) {
//     final cartViewModel = Provider.of<CartViewModel>(context);
//     return Container(
//         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//         color: Colors.white,
//       child: Consumer<CartViewModel>(
//         builder: (context, cartViewModel, _) {
//           int cartLength = cartViewModel.cartLength;
//           double total = cartViewModel.getTotalPrice();
//           print("Change detected in CartShop widget. Total price: $total"); // Not printed
//           return Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(right: 20),
//                     child: Stack(
//                       children: [
//                         const SizedBox(
//                           height: 33,
//                           width: 38,
//                         ),
//                         SvgPicture.asset(
//                           'assets/svg/icon_cart.svg',
//                           width: 33.25,
//                           height: 32.81,
//                         ),
//                         Positioned(
//                           right: 0,
//                           top: 0,
//                           child: Container(
//                             width: 16,
//                             height: 16,
//                             decoration: BoxDecoration(
//                               color: MyColors.error,
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: Center(
//                               child: Text(
//                                 cartLength.toString(),
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 11,
//                                   fontWeight: FontWeight.w600,
//                                   fontFamily: 'Montserrat',
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const Padding(
//                     padding: EdgeInsets.only(right: 6),
//                     child: Text(
//                       'Total:',
//                       style: TextStyle(
//                           color: Colors.black,
//                           fontSize: 16,
//                           fontWeight: FontWeight.w500,
//                           fontFamily: 'Montserrat'),
//                     ),
//                   ),
//                   Text(
//                     'Rp ${total.toStringAsFixed(2)}',
//                     style: const TextStyle(
//                         color: Colors.black,
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                         fontFamily: 'Montserrat'),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 width: MediaQuery.of(context).size.width * 0.30,
//                 child: ElevatedButton(
//                   style: ButtonStyle(
//                     backgroundColor: MaterialStateProperty.all(MyColors.primary),
//                     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                       RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                   ),
//                   onPressed: () {
//                     // Navigate to the payment method page
//                   },
//                   child: const Text(
//                     'Bayar',
//                     style: TextStyle(
//                         fontFamily: 'Montserrat',
//                         fontSize: 16,
//                         fontWeight: FontWeight.w700,
//                         color: Colors.white),
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:pos_portal/view_model/cart_provider.dart';
import 'package:provider/provider.dart';
class CartShop extends StatefulWidget {
  const CartShop({super.key});

  @override
  State<CartShop> createState() => _CartShopState();
}

class _CartShopState extends State<CartShop> {
  late CartProvider _cartProvider;
  @override
  Widget build(BuildContext context) {
    _cartProvider = Provider.of<CartProvider>(context);
    return Text('Cart length: ${_cartProvider.carts.length}');
  }
}

